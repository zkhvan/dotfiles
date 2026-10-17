-- pi_bridge — host-side Neovim → pi bridge (Slice 4: Mutagen-derived discovery)
--
-- Sends the current visual selection (or current line in normal mode) to a
-- running pi TUI inside a Mutagen-synchronized VM, as a user prompt or an
-- editor insert. Talks to a global pi extension (~/.pi/agent/extensions/
-- nvim-bridge) over a warm multiplexed SSH connection via a small Node client.
--
-- Targeting is derived from the selected buffer's Mutagen configuration:
--   * walk up from the buffer for mutagen.yml/.yaml, pick the most specific
--     local `alpha`, derive the SSH endpoint and remote `beta`;
--   * canonicalize a relative `beta` against the remote $HOME over SSH (cached);
--   * read the per-process registry on the VM, filter by canonical VM root,
--     ping each candidate, and auto-select the single live match (cached).
-- Explicit overrides (mapping triples) take precedence over discovery.

local M = {}

local MAX_REQUEST_BYTES = 1024 * 1024 -- 1 MiB, must match the extension

--- @class zkhvan.pi_bridge.Override
--- @field host_root string     absolute host path root
--- @field vm_root string       canonical VM path root (taken as-is)
--- @field ssh_endpoint string  [user@]host reachable from the host machine

--- @class zkhvan.pi_bridge.Config
--- @field overrides? zkhvan.pi_bridge.Override[]  explicit mappings (win over discovery)
--- @field node_path? string     fallback VM node path if a registry entry lacks one
--- @field control_path? string  SSH ControlPath template (defaults under cache)

--- @type zkhvan.pi_bridge.Config?
local config = nil

-- endpoint\0remote_path -> canonical vm_root
local root_cache = {}
-- endpoint\0vm_root -> { endpoint, socket, node, client, pid, name }
local target_cache = {}
-- Neovim startup cwd: the anchor for the session-locked target.
local home_cwd = nil
-- The single locked target for this Neovim session, or nil until first use:
-- { endpoint, host_root, vm_root, target }
local locked = nil

-- Resolve the runtime dir (3-branch rule) and cat every registry entry. POSIX
-- sh, single-quote-free so it can be wrapped in `sh -c '<this>'` for the remote.
local READ_REGISTRY = table.concat({
  'uid=$(id -u);',
  'if [ -n "$XDG_RUNTIME_DIR" ]; then dir="$XDG_RUNTIME_DIR/pi-nvim";',
  'elif [ -d "/run/user/$uid" ]; then dir="/run/user/$uid/pi-nvim";',
  'else dir="${TMPDIR:-/tmp}/pi-nvim-$uid"; fi;',
  '[ -d "$dir" ] || exit 0;',
  'for f in "$dir"/*.json; do [ -f "$f" ] && cat "$f"; done',
}, ' ')

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = 'pi' })
end

--- @param opts zkhvan.pi_bridge.Config
function M.setup(opts)
  config = opts or {}
  -- Anchor the session lock on where Neovim was started (captured before any
  -- later :cd / rooter changes). PiBridgeRetarget re-locks if needed.
  home_cwd = vim.fn.getcwd()
  vim.api.nvim_create_user_command('PiBridgeInfo', function()
    M.info()
  end, { desc = 'pi bridge: show the locked target and current-buffer mapping' })
  vim.api.nvim_create_user_command('PiBridgeRetarget', function()
    M.retarget()
  end, { desc = "pi bridge: re-lock the target to the current buffer's project" })
end

-- ---------------------------------------------------------------------------
-- shell / ssh helpers
-- ---------------------------------------------------------------------------

--- Single-quote a string for a POSIX remote shell.
local function shquote(s)
  return "'" .. tostring(s):gsub("'", "'\\''") .. "'"
end

local function control_path()
  if config.control_path and config.control_path ~= '' then
    return config.control_path
  end
  local dir = vim.fn.stdpath('cache') .. '/pi-bridge'
  vim.fn.mkdir(dir, 'p')
  return dir .. '/cm-%C'
end

local function ssh_base()
  return {
    'ssh',
    '-o', 'BatchMode=yes',
    '-o', 'ConnectTimeout=5',
    '-o', 'ControlMaster=auto',
    '-o', 'ControlPath=' .. control_path(),
    '-o', 'ControlPersist=60',
  }
end

--- Run one remote command synchronously. `remote_cmd` is a single pre-quoted
--- string handed to the remote login shell. Returns the vim.system result.
local function ssh_run(endpoint, remote_cmd, stdin, timeout)
  local cmd = ssh_base()
  cmd[#cmd + 1] = endpoint
  cmd[#cmd + 1] = remote_cmd
  return vim
    .system(cmd, { stdin = stdin, text = true, timeout = timeout or 8000 })
    :wait()
end

local function first_json_line(s)
  if not s or #s == 0 then
    return nil
  end
  local line = s:match('^[^\n]*')
  if not line or #line == 0 then
    return nil
  end
  -- luanil so JSON null decodes to Lua nil (not the vim.NIL sentinel).
  local ok, decoded = pcall(vim.json.decode, line, { luanil = { object = true, array = true } })
  if ok and type(decoded) == 'table' then
    return decoded
  end
  return nil
end

-- ---------------------------------------------------------------------------
-- selection + formatting (unchanged from earlier slices)
-- ---------------------------------------------------------------------------

--- @return integer lo, integer hi, boolean in_visual
local function line_range()
  local first = vim.fn.mode():sub(1, 1)
  local in_visual = first == 'v' or first == 'V' or first == '\22'
  local lo, hi
  if in_visual then
    lo, hi = vim.fn.line('v'), vim.fn.line('.')
  else
    lo = vim.fn.line('.')
    hi = lo
  end
  if lo > hi then
    lo, hi = hi, lo
  end
  return lo, hi, in_visual
end

local function line_label(lo, hi)
  if lo == hi then
    return ('line %d'):format(lo)
  end
  return ('lines %d-%d'):format(lo, hi)
end

local function blockquote(lines)
  local out = {}
  for _, l in ipairs(lines) do
    out[#out + 1] = (l == '') and '>' or ('> ' .. l)
  end
  return table.concat(out, '\n')
end

local function build_message(instruction, location, lines)
  local parts = {}
  if instruction and instruction ~= '' then
    parts[#parts + 1] = instruction
    parts[#parts + 1] = ''
  end
  parts[#parts + 1] = location
  parts[#parts + 1] = ''
  parts[#parts + 1] = blockquote(lines)
  return table.concat(parts, '\n')
end

-- ---------------------------------------------------------------------------
-- path helpers
-- ---------------------------------------------------------------------------

--- Normalize to an absolute, symlink-resolved, trailing-slash-free path.
local function canon_host(p)
  if not p or p == '' then
    return nil
  end
  local abs = vim.fn.fnamemodify(p, ':p')
  abs = vim.fn.resolve(abs)
  abs = abs:gsub('/+$', '')
  return abs
end

--- Number of path segments (specificity for "most specific alpha").
local function depth(p)
  local n = 0
  for _ in p:gmatch('[^/]+') do
    n = n + 1
  end
  return n
end

--- Does `root` contain (or equal) `p`?
local function contains(root, p)
  return p == root or vim.startswith(p, root .. '/')
end

--- Map a contained host path to its VM path under host_root -> vm_root.
local function map_path(abs, host_root, vm_root)
  if abs == host_root then
    return vm_root
  end
  return vm_root .. '/' .. abs:sub(#host_root + 2)
end

--- Location metadata for the message. Degrades to an unmapped host-only label
--- when the buffer is outside the locked project (or unnamed) so the selection
--- still sends, but pi is told it cannot open surrounding VM context.
--- @return string location, boolean degraded
local function build_location(abs, host_root, vm_root, lo, hi, modified)
  local range = line_label(lo, hi)
  local location, degraded
  if abs and contains(host_root, abs) then
    location = ('Location: %s, %s'):format(map_path(abs, host_root, vm_root), range)
    degraded = false
  else
    location = ('Location: unmapped host path %s, %s'):format(abs or '(unnamed buffer)', range)
    degraded = true
  end
  if modified then
    location = location .. ' (unsaved buffer)'
  end
  return location, degraded
end

-- ---------------------------------------------------------------------------
-- Mutagen discovery: buffer path -> { endpoint, host_root, vm_root }
-- ---------------------------------------------------------------------------

--- Parse a `beta` endpoint of shape [user@]host:path.
--- @return string? endpoint, string? remote_path_or_error
local function parse_beta(beta)
  if beta:find('://', 1, true) then
    return nil, 'scheme URL not supported'
  end
  local colon = beta:find(':', 1, true)
  if not colon then
    return nil, 'missing host:path colon'
  end
  local endpoint = beta:sub(1, colon - 1)
  local rpath = beta:sub(colon + 1)
  if endpoint == '' or rpath == '' then
    return nil, 'empty endpoint or path'
  end
  return endpoint, rpath
end

--- Canonicalize a (possibly relative) remote path against the remote $HOME.
local function canonical_vm_root(endpoint, rpath)
  local key = endpoint .. '\0' .. rpath
  if root_cache[key] then
    return root_cache[key]
  end
  local inner = 'cd -- "$HOME" && cd -- ' .. shquote(rpath) .. ' && pwd -P'
  local r = ssh_run(endpoint, 'sh -c ' .. shquote(inner), nil, 8000)
  if r.code ~= 0 then
    local d = vim.trim(r.stderr or '')
    return nil, d ~= '' and d or ('canonicalization failed (exit ' .. tostring(r.code) .. ')')
  end
  local root = vim.trim(r.stdout or ''):gsub('/+$', '')
  if root == '' then
    return nil, 'empty canonical root'
  end
  root_cache[key] = root
  return root
end

--- Run yq over one Mutagen file, returning a list of { name, alpha, beta }.
local function run_yq(mutagen_file)
  local expr = '(.sync // {}) | to_entries | '
    .. 'map(select(.key != "defaults") | {"name": .key, "alpha": .value.alpha, "beta": .value.beta})'
  local r = vim
    .system({ 'yq', '-o=json', '-I=0', expr, mutagen_file }, { text = true, timeout = 5000 })
    :wait()
  if r.code ~= 0 then
    return nil, vim.trim(r.stderr or '') 
  end
  local out = vim.trim(r.stdout or '')
  if out == '' then
    return {}
  end
  local ok, decoded = pcall(vim.json.decode, out)
  if not ok or type(decoded) ~= 'table' then
    return nil, 'unparseable yq output'
  end
  return decoded
end

--- Collect every sync entry from all Mutagen files above `abs`, with the
--- entry's local alpha resolved to an absolute host path.
local function collect_entries(abs)
  local entries = {}
  local yq_missing = false
  -- Start at `abs` itself when it is a directory (a startup-cwd anchor that is
  -- a project root with a root-level mutagen.yml); otherwise treat `abs` as a
  -- file and start from its containing directory.
  local dir = (vim.fn.isdirectory(abs) == 1) and abs or vim.fn.fnamemodify(abs, ':h')
  local seen = {}
  while dir and dir ~= '' and not seen[dir] do
    seen[dir] = true
    for _, fname in ipairs({ 'mutagen.yml', 'mutagen.yaml' }) do
      local mf = dir .. '/' .. fname
      if vim.fn.filereadable(mf) == 1 then
        local list, err = run_yq(mf)
        if list then
          for _, e in ipairs(list) do
            if type(e.alpha) == 'string' and type(e.beta) == 'string' then
              local alpha_abs = canon_host(vim.fn.fnamemodify(dir .. '/' .. e.alpha, ':p'))
              if alpha_abs then
                entries[#entries + 1] = { alpha = alpha_abs, beta = e.beta, file = mf }
              end
            end
          end
        elseif err and err:find('yq') then
          yq_missing = true
        end
      end
    end
    local parent = vim.fn.fnamemodify(dir, ':h')
    if parent == dir then
      break
    end
    dir = parent
  end
  return entries, yq_missing
end

--- Resolve the buffer path to a mapping via override (explicit-wins) or Mutagen.
--- @return table? mapping { endpoint, host_root, vm_root }, string? error
local function resolve_mapping(abs)
  -- 1) explicit overrides win, most-specific host_root prefix.
  local best_ovr, best_ovr_depth
  for _, o in ipairs((config and config.overrides) or {}) do
    local hr = canon_host(o.host_root)
    if hr and contains(hr, abs) then
      local d = depth(hr)
      if not best_ovr_depth or d > best_ovr_depth then
        best_ovr, best_ovr_depth = { endpoint = o.ssh_endpoint, host_root = hr, vm_root = (o.vm_root:gsub('/+$', '')) }, d
      end
    end
  end
  if best_ovr then
    return best_ovr
  end

  -- 2) Mutagen discovery: most-specific containing alpha.
  local entries, yq_missing = collect_entries(abs)
  if yq_missing then
    return nil, 'yq not found on host; install yq (mikefarah) or add an override'
  end
  local matches = {}
  for _, e in ipairs(entries) do
    if contains(e.alpha, abs) then
      matches[#matches + 1] = e
    end
  end
  if #matches == 0 then
    return nil, 'no Mutagen mapping for ' .. abs .. '; add an override'
  end
  table.sort(matches, function(a, b)
    return depth(a.alpha) > depth(b.alpha)
  end)
  if #matches > 1 and depth(matches[1].alpha) == depth(matches[2].alpha) then
    return nil, 'ambiguous Mutagen mapping for ' .. abs .. '; add an override'
  end
  local m = matches[1]
  local endpoint, rpath = parse_beta(m.beta)
  if not endpoint then
    return nil, "unsupported Mutagen beta '" .. m.beta .. "' (" .. rpath .. '); add an override'
  end
  local vm_root, verr = canonical_vm_root(endpoint, rpath)
  if not vm_root then
    return nil, 'could not resolve VM root for ' .. m.beta .. ': ' .. verr
  end
  return { endpoint = endpoint, host_root = m.alpha, vm_root = vm_root }
end

-- ---------------------------------------------------------------------------
-- Target discovery: (endpoint, vm_root) -> live socket, via registry + ping
-- ---------------------------------------------------------------------------

--- Read + filter + ping. Returns the list of live matching registry entries.
--- @return table[]? live, string? error
local function discover_live(endpoint, vm_root)
  local read = ssh_run(endpoint, 'sh -c ' .. shquote(READ_REGISTRY), nil, 6000)
  if read.code ~= 0 then
    local d = vim.trim(read.stderr or '')
    return nil, 'registry read failed on ' .. endpoint .. (d ~= '' and (': ' .. d) or '')
  end

  local candidates = {}
  for line in (read.stdout or ''):gmatch('[^\n]+') do
    local ok, e = pcall(vim.json.decode, line, { luanil = { object = true, array = true } })
    if ok and type(e) == 'table' and e.root == vm_root then
      candidates[#candidates + 1] = e
    end
  end
  if #candidates == 0 then
    return nil, 'no pi session registered for ' .. vm_root .. ' on ' .. endpoint
  end

  local live = {}
  for _, e in ipairs(candidates) do
    local node = e.node or (config and config.node_path)
    if node and e.client and e.socket then
      local remote = shquote(node) .. ' ' .. shquote(e.client) .. ' ' .. shquote(e.socket)
      local pr = ssh_run(endpoint, remote, '{"op":"ping"}\n', 6000)
      local ack = first_json_line(pr.stdout)
      if ack and ack.ok and ack.pid == e.pid then
        e.node = node
        live[#live + 1] = e
      end
    end
  end
  if #live == 0 then
    return nil, 'no live pi session for ' .. vm_root .. ' on ' .. endpoint .. ' (stale registry)'
  end
  return live
end

--- @return table? target { endpoint, socket, node, client }, string? error
local function resolve_target(endpoint, vm_root)
  local key = endpoint .. '\0' .. vm_root
  if target_cache[key] then
    return target_cache[key]
  end
  local live, err = discover_live(endpoint, vm_root)
  if not live then
    return nil, err
  end
  if #live > 1 then
    return nil, ('%d matching pi sessions for %s; picker not yet implemented (Slice 5)'):format(#live, vm_root)
  end
  local e = live[1]
  local target = {
    endpoint = endpoint,
    socket = e.socket,
    node = e.node,
    client = e.client,
    pid = e.pid,
    name = e.name,
  }
  target_cache[key] = target
  return target
end

--- Clear the sticky target for a mapping (used before an explicit re-send).
function M.clear_target(endpoint, vm_root)
  target_cache[endpoint .. '\0' .. vm_root] = nil
end

-- ---------------------------------------------------------------------------
-- session lock: one target per Neovim instance, anchored on startup cwd
-- ---------------------------------------------------------------------------

--- @return table? lock, string? error, string? why ('nomap'|'notarget')
local function lock_from(anchor)
  local mapping, merr = resolve_mapping(anchor)
  if not mapping then
    return nil, merr, 'nomap'
  end
  local target, terr = resolve_target(mapping.endpoint, mapping.vm_root)
  if not target then
    return nil, terr, 'notarget'
  end
  return {
    endpoint = mapping.endpoint,
    host_root = mapping.host_root,
    vm_root = mapping.vm_root,
    target = target,
  }
end

--- Establish (once) and return the session-locked target. Anchors on the
--- Neovim startup cwd; only if that does not map to any project does it fall
--- back to the current buffer. If the startup project maps but has no live pi,
--- that is an error (we never silently target another project's pi).
--- @return table? lock, string? error
local function ensure_lock(buf_abs)
  if locked then
    return locked
  end
  local home = home_cwd and canon_host(home_cwd)
  if home then
    local l, err, why = lock_from(home)
    if l then
      locked = l
      return locked
    end
    if why ~= 'nomap' then
      return nil, err -- project identified but no live pi; do not fall back
    end
  end
  if buf_abs and buf_abs ~= '' then
    local l, err = lock_from(buf_abs)
    if l then
      locked = l
      return locked
    end
    return nil, err
  end
  return nil, 'no Mutagen mapping for the startup directory or the current buffer; add an override'
end

-- ---------------------------------------------------------------------------
-- transport (final send is async)
-- ---------------------------------------------------------------------------

local function handle_ack(obj)
  local ack = first_json_line(obj.stdout)
  if ack then
    if ack.ok then
      local delivery = ack.delivery
      if delivery == 'steer' then
        notify('Sent to pi (steering)')
      elseif delivery == 'editor' then
        notify('Inserted into pi editor')
      else
        notify('Sent to pi')
      end
    else
      local code = ack.error and ack.error.code
      if code == 'socket_missing' or code == 'socket_refused' then
        -- The locked pi is gone: drop the lock + cached target so the next send
        -- re-discovers. We never retry or redirect this send (RFC D39-D40).
        if locked then
          target_cache[locked.endpoint .. '\0' .. locked.vm_root] = nil
        end
        locked = nil
      end
      local msg = (ack.error and ack.error.message) or 'unknown error'
      notify('pi bridge: ' .. msg, vim.log.levels.ERROR)
    end
    return
  end

  local detail
  if obj.stderr and #obj.stderr > 0 then
    detail = vim.trim(obj.stderr)
  else
    detail = 'exit code ' .. tostring(obj.code)
  end
  notify('pi bridge transport error: ' .. detail, vim.log.levels.ERROR)
end

--- @param mode 'prompt'|'editor'
local function dispatch(mode, text, target)
  local json = vim.json.encode({ op = 'send', mode = mode, text = text })
  if #json > MAX_REQUEST_BYTES then
    notify('selection too large (> 1 MiB); not sent', vim.log.levels.ERROR)
    return
  end

  local remote = shquote(target.node) .. ' ' .. shquote(target.client) .. ' ' .. shquote(target.socket)
  local cmd = ssh_base()
  cmd[#cmd + 1] = target.endpoint
  cmd[#cmd + 1] = remote

  vim.system(cmd, { stdin = json .. '\n', text = true, timeout = 10000 }, function(obj)
    vim.schedule(function()
      handle_ack(obj)
    end)
  end)
end

-- ---------------------------------------------------------------------------
-- public entrypoint
-- ---------------------------------------------------------------------------

--- @param mode 'prompt'|'editor'
local function send(mode)
  if not config then
    notify('pi bridge is not configured (call require("zkhvan.pi_bridge").setup{})', vim.log.levels.ERROR)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local lo, hi, in_visual = line_range()
  local lines = vim.api.nvim_buf_get_lines(bufnr, lo - 1, hi, false)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local modified = vim.bo[bufnr].modified

  if in_visual then
    vim.cmd([[silent! execute "normal! \<Esc>"]])
  end

  local abs = name ~= '' and canon_host(name) or nil

  -- Target is the session lock (anchored on startup cwd), NOT the current
  -- buffer, so sends stay attached to the same pi even when the buffer leaves
  -- the project. Resolved before the optional-note prompt (RFC D5).
  local lock, lerr = ensure_lock(abs)
  if not lock then
    notify('pi bridge: ' .. lerr, vim.log.levels.ERROR)
    return
  end

  local location, degraded = build_location(abs, lock.host_root, lock.vm_root, lo, hi, modified)
  if degraded then
    notify('unmapped path: pi cannot open surrounding VM context', vim.log.levels.WARN)
  end

  local label = mode == 'editor' and 'Insert into pi (optional note): ' or 'Message to pi (optional): '
  vim.ui.input({ prompt = label }, function(input)
    if input == nil then
      return
    end
    dispatch(mode, build_message(input, location, lines), lock.target)
  end)
end

--- Submit the current selection (or line) to pi as a user prompt.
function M.send_prompt()
  send('prompt')
end

--- Insert the current selection (or line) into pi's editor without submitting.
function M.send_editor()
  send('editor')
end

--- Re-lock the session target to the current buffer's project (explicit
--- switch). Forces fresh discovery so a moved/replaced pi is re-selected.
function M.retarget()
  locked = nil
  target_cache = {}
  local name = vim.api.nvim_buf_get_name(0)
  local anchor = (name ~= '' and canon_host(name)) or (home_cwd and canon_host(home_cwd))
  if not anchor then
    notify('pi bridge: no buffer or cwd to retarget from', vim.log.levels.ERROR)
    return
  end
  local l, err = lock_from(anchor)
  if not l then
    notify('pi bridge retarget: ' .. err, vim.log.levels.ERROR)
    return
  end
  locked = l
  notify(
    ('pi bridge locked to pid %s (%s) — %s'):format(
      tostring(l.target.pid),
      tostring(l.target.name or 'unnamed'),
      l.vm_root
    )
  )
end

--- Show (and, on first call, establish) the locked target plus how the current
--- buffer maps against it. Debugging aid for discovery + locking.
function M.info()
  if not config then
    notify('pi bridge is not configured', vim.log.levels.ERROR)
    return
  end
  local name = vim.api.nvim_buf_get_name(0)
  local abs = name ~= '' and canon_host(name) or nil
  local out = { 'pi bridge:', '  startup cwd  : ' .. (home_cwd or '?') }

  local lock, lerr = ensure_lock(abs)
  if not lock then
    out[#out + 1] = '  target       : ERROR — ' .. lerr
    notify(table.concat(out, '\n'), vim.log.levels.WARN)
    return
  end

  out[#out + 1] = ('  LOCKED pid   : %s (%s)'):format(tostring(lock.target.pid), tostring(lock.target.name or 'unnamed'))
  out[#out + 1] = '  endpoint     : ' .. lock.endpoint
  out[#out + 1] = '  host_root    : ' .. lock.host_root
  out[#out + 1] = '  vm_root      : ' .. lock.vm_root
  out[#out + 1] = '  socket       : ' .. lock.target.socket

  if abs and contains(lock.host_root, abs) then
    out[#out + 1] = '  this buffer  : ' .. map_path(abs, lock.host_root, lock.vm_root)
  else
    out[#out + 1] = '  this buffer  : ' .. (abs or '(unnamed)') .. '  (outside locked project → unmapped)'
  end

  local live = discover_live(lock.endpoint, lock.vm_root)
  if live then
    out[#out + 1] = ('  live in proj : %d'):format(#live)
    for _, e in ipairs(live) do
      out[#out + 1] = ('    - pid %s  %s'):format(tostring(e.pid), tostring(e.name or 'unnamed'))
    end
  end
  notify(table.concat(out, '\n'), vim.log.levels.INFO)
end

return M

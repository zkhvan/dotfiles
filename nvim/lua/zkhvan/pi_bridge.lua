-- pi_bridge — host-side Neovim → pi bridge
--
-- Sends the current visual selection (or current line in normal mode) to a
-- running pi TUI inside a Mutagen-synchronized VM as a user prompt. Talks to a
-- project-local pi extension over a warm multiplexed SSH connection via a small
-- Node client bound to a Unix socket.
--
-- TODO: This implementation hardcodes the SSH endpoint, socket, and host/VM
-- root mapping; those live in the machine-local config
-- (after/plugin/local.lua). This module holds the reusable selection, mapping,
-- formatting, and transport logic.

local M = {}

--- @class zkhvan.pi_bridge.Config
--- @field ssh_endpoint string      [user@]host reachable from the host machine
--- @field host_root string         absolute host path root synced to the VM
--- @field vm_root string           absolute VM path root (canonical)
--- @field socket string            VM path of the pi bridge Unix socket
--- @field node_path string         absolute node binary path on the VM
--- @field client string            VM path of nvim-bridge-client.mjs
--- @field control_path? string     SSH ControlPath template (defaults under cache)

--- @type zkhvan.pi_bridge.Config?
local config = nil

local MAX_REQUEST_BYTES = 1024 * 1024 -- 1 MiB, must match the extension

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = 'pi' })
end

--- @param opts zkhvan.pi_bridge.Config
function M.setup(opts)
  config = opts
  vim.api.nvim_create_user_command('PiBridgeInfo', function()
    M.info()
  end, { desc = 'pi bridge: show mapping for the current buffer' })
end

-- ---------------------------------------------------------------------------
-- selection
-- ---------------------------------------------------------------------------

--- Expand the current selection to complete intersecting buffer lines.
--- Works for characterwise, linewise, blockwise, and reversed selections; in
--- normal mode it returns the current line.
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

-- ---------------------------------------------------------------------------
-- formatting
-- ---------------------------------------------------------------------------

local function line_label(lo, hi)
  if lo == hi then
    return ('line %d'):format(lo)
  end
  return ('lines %d-%d'):format(lo, hi)
end

--- Map a host buffer path to its canonical VM path, or nil if unmapped.
--- Tolerates symlinked roots (e.g. a symlinked vault) by also comparing the
--- symlink-resolved forms of both the buffer path and the host root.
--- @return string? vmpath
local function map_to_vm(abs)
  if abs == '' then
    return nil
  end

  local roots = { config.host_root }
  local rroot = vim.fn.resolve(config.host_root)
  if rroot ~= config.host_root then
    roots[#roots + 1] = rroot
  end

  local candidates = { abs }
  local rabs = vim.fn.resolve(abs)
  if rabs ~= abs then
    candidates[#candidates + 1] = rabs
  end

  for _, root in ipairs(roots) do
    for _, cand in ipairs(candidates) do
      if cand == root then
        return config.vm_root
      end
      if vim.startswith(cand, root .. '/') then
        return config.vm_root .. '/' .. cand:sub(#root + 2)
      end
    end
  end
  return nil
end

--- Build the location metadata line and whether the path is unmapped.
--- @return string location, boolean degraded
local function build_location(abs, lo, hi, modified)
  local range = line_label(lo, hi)
  local vmpath = map_to_vm(abs)
  local location
  if vmpath then
    location = ('Location: %s, %s'):format(vmpath, range)
  else
    local shown = abs ~= '' and abs or '(unnamed buffer)'
    location = ('Location: unmapped host path %s, %s'):format(shown, range)
  end
  if modified then
    location = location .. ' (unsaved buffer)'
  end
  return location, vmpath == nil
end

--- Print the current buffer's mapping for debugging the hardcoded slice.
function M.info()
  if not config then
    notify('pi bridge is not configured', vim.log.levels.ERROR)
    return
  end
  local name = vim.api.nvim_buf_get_name(0)
  local abs = name ~= '' and vim.fn.fnamemodify(name, ':p') or ''
  local rabs = abs ~= '' and vim.fn.resolve(abs) or ''
  local vmpath = map_to_vm(abs)
  local lines = {
    'pi bridge mapping:',
    '  ssh endpoint : ' .. config.ssh_endpoint,
    '  host_root    : ' .. config.host_root,
    '  host_root(rs): ' .. vim.fn.resolve(config.host_root),
    '  vm_root      : ' .. config.vm_root,
    '  buffer path  : ' .. (abs ~= '' and abs or '(unnamed)'),
    '  buffer(resl) : ' .. (rabs ~= '' and rabs or '(unnamed)'),
    '  mapped VM    : ' .. (vmpath or 'UNMAPPED'),
    '  socket       : ' .. config.socket,
  }
  notify(
    table.concat(lines, '\n'),
    vmpath and vim.log.levels.INFO or vim.log.levels.WARN
  )
end

--- Render selected lines as a Markdown blockquote (blank lines become ">").
local function blockquote(lines)
  local out = {}
  for _, l in ipairs(lines) do
    if l == '' then
      out[#out + 1] = '>'
    else
      out[#out + 1] = '> ' .. l
    end
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
-- transport
-- ---------------------------------------------------------------------------

local function control_path()
  if config.control_path and config.control_path ~= '' then
    return config.control_path
  end
  local dir = vim.fn.stdpath('cache') .. '/pi-bridge'
  vim.fn.mkdir(dir, 'p')
  return dir .. '/cm-%C'
end

local function handle_ack(obj)
  local ack
  if obj.stdout and #obj.stdout > 0 then
    local line = obj.stdout:match('^[^\n]*')
    if line and #line > 0 then
      local ok, decoded = pcall(vim.json.decode, line)
      if ok and type(decoded) == 'table' then
        ack = decoded
      end
    end
  end

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
      local msg = (ack.error and ack.error.message) or 'unknown error'
      notify('pi bridge: ' .. msg, vim.log.levels.ERROR)
    end
    return
  end

  -- No parseable ack: a transport failure (SSH, missing node/client, etc.).
  local detail
  if obj.stderr and #obj.stderr > 0 then
    detail = vim.trim(obj.stderr)
  else
    detail = 'exit code ' .. tostring(obj.code)
  end
  notify('pi bridge transport error: ' .. detail, vim.log.levels.ERROR)
end

--- @param mode 'prompt'|'editor'
local function dispatch(mode, text)
  local json = vim.json.encode({ op = 'send', mode = mode, text = text })
  if #json > MAX_REQUEST_BYTES then
    notify('selection too large (> 1 MiB); not sent', vim.log.levels.ERROR)
    return
  end

  local cmd = {
    'ssh',
    '-o',
    'BatchMode=yes',
    '-o',
    'ConnectTimeout=5',
    '-o',
    'ControlMaster=auto',
    '-o',
    'ControlPath=' .. control_path(),
    '-o',
    'ControlPersist=60',
    config.ssh_endpoint,
    config.node_path,
    config.client,
    config.socket,
  }

  vim.system(
    cmd,
    { stdin = json .. '\n', text = true, timeout = 10000 },
    function(obj)
      vim.schedule(function()
        handle_ack(obj)
      end)
    end
  )
end

-- ---------------------------------------------------------------------------
-- public entrypoint
-- ---------------------------------------------------------------------------

--- Shared flow for both delivery modes: capture the selection, map the path,
--- collect an optional instruction, then dispatch.
--- @param mode 'prompt'|'editor'
local function send(mode)
  if not config then
    notify(
      'pi bridge is not configured (call require("zkhvan.pi_bridge").setup{})',
      vim.log.levels.ERROR
    )
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local lo, hi, in_visual = line_range()
  local lines = vim.api.nvim_buf_get_lines(bufnr, lo - 1, hi, false)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local abs = name ~= '' and vim.fn.fnamemodify(name, ':p') or ''
  local modified = vim.bo[bufnr].modified

  if in_visual then
    -- Leave visual mode now that the range and lines are captured.
    vim.cmd([[silent! execute "normal! \<Esc>"]])
  end

  local location, degraded = build_location(abs, lo, hi, modified)
  if degraded then
    notify(
      'unmapped path: pi cannot open surrounding VM context',
      vim.log.levels.WARN
    )
  end

  local label = mode == 'editor' and 'Insert into pi (optional note): '
    or 'Message to pi (optional): '
  vim.ui.input({ prompt = label }, function(input)
    if input == nil then
      -- Escape / cancel: send nothing.
      return
    end
    dispatch(mode, build_message(input, location, lines))
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

return M

local lsp = require('kz.lsp')
local format = require('kz.format')

local M = {}

-- ===========================================================================
-- Type definitions
-- ===========================================================================

---@class Tool
---@field name string -- tool or lspconfig name
---@field type ToolType
---@field lspconfig? fun(): lspconfig.Config
---@field efmconfig? fun(): any

---@alias ToolType 'tool'|'lsp'

-- ===========================================================================

M.servers = {}

--- A list of tools.
---@type table<string, Tool>
M.tools = {}

--- Register a tool.
---@param tool Tool
function M.register(tool)
  M.tools[tool.name] = tool
end

function M.get_lspconfig(name)
  local tool = M.tools[name]
  if tool == nil then
    return {}
  end

  if tool.type ~= 'lsp' then
    return {}
  end

  ---@type lspconfig.Config
  local config = {
    name = tool.name,
  }

  config = vim.tbl_deep_extend('force', lsp.base_config, config)

  if tool.lspconfig ~= nil then
    config = vim.tbl_deep_extend('force', config, tool.lspconfig())
  end

  return config
end

function M.get_lspconfigs()
  return vim
    .iter(M.tools)
    :filter(function(_, tool)
      return tool.type == 'lsp'
    end)
    :map(function(name, _)
      return M.get_lspconfig(name)
    end)
    :totable()
end

function M.get_lspconfig_names()
  return vim
    .iter(M.get_lspconfigs())
    :filter(function(config)
      if config.mason_lspconfig == nil then
        return true
      end
      return config.mason_lspconfig
    end)
    :map(function(config)
      return config.name
    end)
    :totable()
end

function M.get_efmconfig(name)
  local tool = M.tools[name]
  if tool == nil then
    return {}
  end

  if tool.efmconfig == nil then
    return {}
  end

  return tool.efmconfig()
end

function M.get_efmconfigs()
  return vim
    .iter(M.tools)
    :filter(function(_, tool)
      return tool.efmconfig ~= nil
    end)
    :map(function(name, _)
      return M.get_efmconfig(name)
    end)
    :fold({}, function(acc, efmconfig)
      for ft, languages in pairs(efmconfig) do
        acc[ft] = acc[ft] or {}
        for _, language in ipairs(languages) do
          table.insert(acc[ft], language)
        end
      end
      return acc
    end)
end

function M.get_tools()
  return vim
    .iter(M.tools)
    :filter(function(_, v)
      return v.type == 'tool'
    end)
    :totable()
end

function M.setup_mason_lspconfig()
  local lspconfig = require('lspconfig')
  local mason_lspconfig = require('mason-lspconfig')

  -- Enable lsp log level
  vim.lsp.set_log_level(vim.lsp.log_levels.OFF)

  mason_lspconfig.setup({
    automatic_installation = true,
    ensure_installed = M.get_lspconfig_names(),
  })

  ---@type table<string, fun(server_name: string)>
  local handlers = {}

  -- Setup default handler
  handlers[1] = function(server_name)
    local config = M.get_lspconfig(server_name)
    lspconfig[server_name].setup(config)
  end

  mason_lspconfig.setup_handlers(handlers)
end

function M.setup_efmconfig()
  local efmconfigs = M.get_efmconfigs()

  local efmls_config = {
    filetypes = vim.tbl_keys(efmconfigs),
    settings = {
      rootMarkers = { '.git/' },
      languages = efmconfigs,
    },
    init_options = {
      documentFormatting = true,
      documentRangeFormatting = true,
    },
  }

  require('lspconfig').efm.setup(efmls_config)
end

function M.setup_conformconfig()
  local pipelines = format.pipelines

  require('conform').setup({
    formatters_by_ft = pipelines,
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end

      return {
        timeout_ms = 2000,
        lsp_fallback = true,
      }
    end,
    default_format_opts = {
      stop_after_first = true,
    },
  })

  vim.bo.formatexpr = "v:lua.require('conform').formatexpr()"
end

return M

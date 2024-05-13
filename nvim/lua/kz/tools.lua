local lsp = require('kz.lsp')

local M = {}

-- ===========================================================================
-- Type definitions
-- ===========================================================================

---@class Tool
---@field name string -- tool or lspconfig name
---@field type ToolType
---@field lspconfig? fun(): lspconfig.Config

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

  config = vim.tbl_deep_extend(
    'force',
    lsp.base_config,
    config
  )

  if tool.lspconfig ~= nil then
    config = vim.tbl_deep_extend('force', config, tool.lspconfig())
  end

  return config
end

function M.get_lspconfigs()
  return vim
      .iter(M.tools)
      :filter(
        function(_, tool)
          return tool.type == 'lsp'
        end
      )
      :map(function(name, _)
        return M.get_lspconfig(name)
      end)
      :totable()
end

function M.get_lspconfig_names()
  return vim
      .iter(M.get_lspconfigs())
      :map(function(config)
        return config.name
      end)
      :totable()
end

function M.get_tools()
  return vim
      .iter(pairs(M.tools))
      :filter(
        function(_, v)
          return v.type == 'tool'
        end
      )
      :totable()
end

function M.setup_mason_lspconfig()
  local lspconfig = require('lspconfig')
  local mason_lspconfig = require('mason-lspconfig')

  mason_lspconfig.setup({
    automatic_installation = true,
    ensure_installed       = M.get_lspconfig_names()
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

return M

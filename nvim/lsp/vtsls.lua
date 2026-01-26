---@brief
---
--- https://github.com/yioneko/vtsls
---
--- `vtsls` can be installed with npm:
--- ```sh
--- npm install -g @vtsls/language-server
--- ```
---
--- To configure a TypeScript project, add a
--- [`tsconfig.json`](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html)
--- or [`jsconfig.json`](https://code.visualstudio.com/docs/languages/jsconfig) to
--- the root of your project.
---
--- ### Vue support
---
--- Since v3.0.0, the Vue language server requires `vtsls` to support TypeScript.
---
--- ```
--- -- If you are using mason.nvim, you can get the ts_plugin_path like this
--- -- For Mason v1,
--- -- local mason_registry = require('mason-registry')
--- -- local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'
--- -- For Mason v2,
--- -- local vue_language_server_path = vim.fn.expand '$MASON/packages' .. '/vue-language-server' .. '/node_modules/@vue/language-server'
--- -- or even
--- -- local vue_language_server_path = vim.fn.stdpath('data') .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
--- local vue_language_server_path = '/path/to/@vue/language-server'
--- local vue_plugin = {
---   name = '@vue/typescript-plugin',
---   location = vue_language_server_path,
---   languages = { 'vue' },
---   configNamespace = 'typescript',
--- }
--- vim.lsp.config('vtsls', {
---   settings = {
---     vtsls = {
---       tsserver = {
---         globalPlugins = {
---           vue_plugin,
---         },
---       },
---     },
---   },
---   filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
--- })
--- ```
---
--- - `location` MUST be defined. If the plugin is installed in `node_modules`, `location` can have any value.
--- - `languages` must include vue even if it is listed in filetypes.
--- - `filetypes` is extended here to include Vue SFC.
---
--- You must make sure the Vue language server is setup. For example,
---
--- ```
--- vim.lsp.enable('vue_ls')
--- ```
---
--- See `vue_ls` section and https://github.com/vuejs/language-tools/wiki/Neovim for more information.

return {
  cmd = { 'vtsls', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  -- root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root_markers =
      { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' }

    -- Don't start LSP inside node_modules
    if fname:match('node_modules') then
      -- Find the project root by walking up until we're out of node_modules
      local dir =
        vim.fs.find({ 'node_modules' }, { path = fname, upward = true })[1]

      -- Now find the actual project root from that directory
      local root_dir = vim.fs.dirname(
        vim.fs.find(root_markers, { path = dir, upward = true })[1]
      )

      on_dir(root_dir)
      return
    end

    -- Normal root detection for files outside node_modules
    local root_dir = vim.fs.dirname(
      vim.fs.find(root_markers, { path = fname, upward = true })[1]
    )

    on_dir(root_dir)
    return
  end,
  settings = {
    vtsls = {
      tsserver = {
        log = 'verbose',
        maxTsServerMemory = 10240,
        useSeparateSyntaxServer = false,
        useSyntaxServer = 'never',
      },
    },
  },
}

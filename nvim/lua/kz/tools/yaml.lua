local tools = require('kz.tools')

tools.register({
  name = 'yamlls',
  type = 'lsp',
  lspconfig = function()
    ---@type lspconfig.Config
    return {
      settings = {
        yaml = {
          schemaStore = {
            enable = true,
            url = 'https://www.schemastore.org/api/json/catalog.json',
          },
          -- schemas = {
          --   ['https://json.schemastore.org/github-action.json'] = {
          --     '/action.yml',
          --     '/action.yaml',
          --   },
          --   ['https://json.schemastore.org/github-workflow.json'] = {
          --     '**/.github/workflows/*.yml',
          --     '**/.github/workflows/*.yaml',
          --     '**/.gitea/workflows/*.yml',
          --     '**/.gitea/workflows/*.yaml',
          --     '**/.forgejo/workflows/*.yml',
          --     '**/.forgejo/workflows/*.yaml',
          --   },
          -- },
        },
        redhat = {
          telemetry = {
            enabled = false,
          },
        },
      },
    }
  end,
})

local tools = require('kz.tools')

tools.register({
  name = 'yamlls',
  type = 'lsp',
  lspconfig = function()
    ---@type lspconfig.Config|{}
    return {
      settings = {
        yaml = {
          schemaStore = {
            enable = true,
            url = 'https://www.schemastore.org/api/json/catalog.json',
          },
          schemas = {
            ['https://json.schemastore.org/circleciconfig.json'] = {
              '/.circleci/*.yaml',
              '/.circleci/*.yml',
            },
            ['https://raw.githubusercontent.com/dbowling/null-schema/refs/heads/main/null.schema.json'] = {
              '/cluster.yaml',
            },
          },
          -- Add custom schemas like this
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

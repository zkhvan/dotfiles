local tools = require('kz.tools')

tools.register({
  name = 'tflint',
  type = 'tool',
})

tools.register({
  name = 'terraformls',
  type = 'lsp',
  lspconfig = function()
    ---@type lspconfig.Config
    return {
      cmd = {
        'terraform-ls',
        'serve',
      },
      init_options = {
        validation = {
          enableEnhancedValidation = false,
        },
        terraform = {
          logFilePath = vim.fn.stdpath('state') .. 'terraform-ls.log',
        },
        indexing = {
          ignorePaths = {
            '**/.terraform/*',
            '**/.terraform.lock.hcl',
            '**/terraform.tfstate',
            '**/terraform.tfstate.backup',
            '**/terraform.plan',
            '**/terraform*.plan',
            '**/crash.log',
            '**/vendor/*',
            '**/.vscode/*',
            '**/.idea/*',
            '**/.project',
            '**/generated/*',
            '**/build/*',
          },
        },

        experimentalFeatures = {
          prefillRequiredFields = true,
        },
        -- logFilePath = vim.env.XDG_STATE_HOME
      },
    }
  end,
})

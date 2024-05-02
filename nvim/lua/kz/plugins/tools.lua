return {
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = function()
      require('mason').setup({
        ui = {
          border = 'rounded',
          icons = {
            package_installed = '',
            package_pending = '󱍷',
            package_uninstalled = '',
          },
        },
      })
    end,
  },
}

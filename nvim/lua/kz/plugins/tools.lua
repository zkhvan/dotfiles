local tools = require('kz.tools')

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

      local mr = require('mason-registry')
      vim.iter(tools.get_tools()):each(function(tool_name)
        local pkg = mr.get_package(tool_name)

        if pkg:is_installed() then
          return
        end

        vim.notify(('Installing %s'):format(pkg.name))

        local handle_closed = vim.schedule_wrap(function()
          return pkg:is_installed()
            and vim.notify(('Successfully installed %s'):format(pkg.name))
        end)

        pkg:install():once('closed', handle_closed)
      end)
    end,
  },
}

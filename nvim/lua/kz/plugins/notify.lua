return {
  {
    'rcarriga/nvim-notify',
    lazy = false,
    priority = 1000,
    config = function()
      local notify = require('notify')
      notify.setup()
      vim.notify = notify
    end,
  },
}

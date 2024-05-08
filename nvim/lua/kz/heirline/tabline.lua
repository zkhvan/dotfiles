local conditions = require('heirline.conditions')
return {
  init = function(self)
    self.branch = conditions.is_git_repo()
        and vim.api.nvim_buf_get_var(0, 'gitsigns_head')
      or ''

    self.cwd = vim.uv.cwd()
  end,

  require('kz.heirline.cwd'),
  require('kz.heirline.git'),
  require('kz.heirline.bufferstats'),

  { provider = '%=', hl = 'StatusLineNC' },

  require('kz.heirline.clipboard'),
  -- require("kz.heirline.remote"),
  require('kz.heirline.lazy'),
  require('kz.heirline.doctor'),
}

return {
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('telescope').load_extension('file_browser')
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      local t = require('telescope')

      t.setup({
        defaults = {
          mappings = {
            i = {
              ["<Esc>"] = "close",
            },
          },
          results_title = false,
        },
        extensions = {
          file_browser = {
            hijack_netrw = true,
            layout_strategy = 'vertical',
            prompt_title = 'Explorer ? <C-/> ls mappings / <A-d> del / <A-m> mv / <A-r> ren',
          },
        },
      })

      t.load_extension('fzf')

      require('kz.mappings').bind_telescope()
    end
  }
}

--- @module 'lazy'
--- @type LazySpec[]
return {
  {
    'Afourcat/treesitter-terraform-doc.nvim',
    ft = { 'terraform', 'hcl' },
    config = function(_, opts)
      local doc = require('treesitter-terraform-doc')
      doc.setup(opts)
      -- The plugin doesn't support configuring providers through config.
      -- https://github.com/Afourcat/treesitter-terraform-doc.nvim/blob/e959c1f19f12642da05587443523dc09cf7991a8/lua/treesitter-terraform-doc/init.lua#L217-L225
      table.insert(doc.providers,
        {
          prefix = "pagerduty",
          name = "pagerduty",
        }
      )
    end,
  },
}

local mappings = require('kz.mappings')

-- =========================================================================
-- Completion
-- =========================================================================

---@type LazySpec[]
return {
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      { 'dcampos/cmp-snippy', dependencies = { 'dcampos/nvim-snippy' } },
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-path',
      'onsails/lspkind.nvim',
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = 'snippy' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lsp' },
        }, { -- group 2 only if nothing in above had results
          { name = 'buffer' },
        }),
        snippet = {
          expand = function(args)
            require('snippy').expand_snippet(args.body)
          end,
        },
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/types/cmp.lua#L35-L40
          fields = {
            cmp.ItemField.Kind,
            cmp.ItemField.Abbr,
            cmp.ItemField.Menu,
          },
          format = function(entry, vim_item)
            local kind_formatted = require('lspkind').cmp_format({
              mode = 'symbol_text', -- show only symbol annotations
              menu = {
                buffer = 'ʙᴜꜰ',
                cmdline = '', -- cmp-cmdline used on cmdline
                latex_symbols = 'ʟᴛx',
                luasnip = 'sɴɪᴘ',
                snippy = 'sɴɪᴘ',
                nvim_lsp = 'ʟsᴘ',
                nvim_lua = 'ʟᴜᴀ',
                path = 'ᴘᴀᴛʜ',
              },
            })(entry, vim_item)

            local strings =
              vim.split(kind_formatted.kind, '%s', { trimempty = true })

            kind_formatted.kind = (strings[1] or '')

            local smallcaps_type = require('kz.utils.string').smallcaps(
              strings[2]
            ) or ''

            kind_formatted.menu = ('  %s.%s'):format(
              kind_formatted.menu or entry.source.name,
              smallcaps_type
            )

            return kind_formatted
          end,
        },
      })
      mappings.bind_snippy()
    end,
  },
}

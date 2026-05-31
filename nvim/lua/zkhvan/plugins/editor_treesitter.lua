local FT_TO_LANG_ALIASES = {
  dotenv = 'bash',
  tiltfile = 'starlark',
}

local ENSURE_INSTALLED = {
  'lua',
  'luadoc',
  'vim',
  'vimdoc',
}

-- blacklist if highlighting doesn't look right or is worse than vim regex
local HIGHLIGHTING_DISABLED = {
  -- treesitter language, not ft
  -- see https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
  'dockerfile',
}

local installing = {}

local function maybe_install_parser(lang)
  if installing[lang] then
    return
  end

  local installed = require('nvim-treesitter').get_installed()
  if vim.tbl_contains(installed, lang) then
    return
  end

  local available = require('nvim-treesitter').get_available()
  if not vim.tbl_contains(available, lang) then
    return
  end

  installing[lang] = true
  require('nvim-treesitter').install(lang)
end

local function start_treesitter(args)
  local ft = vim.bo[args.buf].filetype
  local lang = vim.treesitter.language.get_lang(ft)
  if not lang then
    return
  end

  local has_parser = pcall(vim.treesitter.get_parser, args.buf, lang)
  if not has_parser then
    maybe_install_parser(lang)
    return
  end

  if not vim.tbl_contains(HIGHLIGHTING_DISABLED, lang) then
    pcall(vim.treesitter.start, args.buf, lang)
  end

  vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

--- @module 'lazy'
--- @type LazySpec[]
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = function()
      local treesitter = require('nvim-treesitter')
      treesitter.install(ENSURE_INSTALLED):wait(300000)
      treesitter.update():wait(300000)
    end,
    config = function()
      require('nvim-treesitter').setup()

      -- Aliases
      for ft, parser in pairs(FT_TO_LANG_ALIASES) do
        vim.treesitter.language.register(parser, ft)
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('zkhvan_treesitter', { clear = true }),
        callback = start_treesitter,
      })
    end,
  },
}

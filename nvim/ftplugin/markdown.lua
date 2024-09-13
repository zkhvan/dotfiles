-- ftplugin/markdown.lua

local map = vim.keymap.set

if package.loaded['various-textobjs'] then
  local textobjs = require('various-textobjs')

  map({ 'o', 'x' }, 'iC', function()
    textobjs.mdFencedCodeBlock('inner')
  end, { desc = 'textobj: md fenced code block' })
end

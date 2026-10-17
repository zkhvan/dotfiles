require('zkhvan.editor').space(2)

-- Hanging indent for soft-wrapped list items, aligned with the item's text.
-- `list:-1` uses the width of the 'formatlistpat' match, so the pattern is
-- extended to swallow the checkbox marker too (`- [ ] ` -> 6, not 2).
-- Must live in after/ftplugin: $VIMRUNTIME/ftplugin/markdown.vim resets
-- 'formatlistpat' and loads after ~/.config/nvim/ftplugin/markdown.lua.
vim.opt_local.breakindentopt = 'list:-1'
vim.opt_local.formatlistpat = table.concat({
  -- ordered/unordered marker, then an optional [ ] / [x] / [-] checkbox
  [==[^\s*\(\d\+[.)]\|[-*+]\)\s\+\(\[[^]]\{-}\]\s\+\)\?]==],
  -- link reference definitions (from the stock markdown ftplugin)
  [==[^\[^\ze[^\]]\+\]:\&^.\{4}]==],
}, [[\|]])

-- Continue the list marker on <CR> (`r`) and o/O (`o`). The stock markdown
-- ftplugin removes both and flags its bullets `f` ("never repeat this leader"),
-- so re-enable here. Driven by 'comments', NOT 'formatlistpat' above.
-- `- [ ]` must precede `- ` or the shorter leader wins.
-- Known gaps: ordered lists don't continue ('comments' can't increment), and
-- <CR> on an empty item leaves a dangling marker instead of ending the list.
vim.opt_local.formatoptions:append('ro')
vim.opt_local.comments = 'b:- [ ],b:-,b:*,b:+,n:>'

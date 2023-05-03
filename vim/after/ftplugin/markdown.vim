" after/ftplugin/markdown.vim
"

call kz#TwoSpace()

setlocal wrap
setlocal linebreak
setlocal breakindent
setlocal nomodeline
setlocal spell

" Override pandoc
setlocal textwidth=78
" the line will be right after column 80, &tw+3
setlocal colorcolumn=+3

if exists('$ITERM_PROFILE') || has('gui_macvim')
  let s:cpo_save = &cpoptions
  set cpoptions&vim

  nnoremap  <silent><buffer><special>  <Leader>mp
        \ :<C-U>MarkdownPreview<CR>

  nnoremap  <silent><buffer><special>  <Leader>mn
        \ :<C-U>exec printf('silent !open %s/%s', 'http://localhost:3000', fnamemodify(expand("%"), ":~:.:r"))<CR>

  " https://stackoverflow.com/questions/4525261/getting-relative-paths-in-vim
  " echo fnamemodify(expand("%"), ":~:.")

  let &cpoptions = s:cpo_save
  unlet s:cpo_save
endif

if kzplug#Exists('zk-nvim')
  if luaeval('require("zk.util").notebook_root(vim.fn.expand("%:p")) ~= nil')
    " Create a note after asking for a title
    nmap <silent> <Leader>zn :<C-U>execute 'ZkNew { title = "' . input('Title: ') . '" }'<CR>

    " Create a new note in the same directory as the current buffer, using the current selection for title.
    vmap <silent> <Leader>znt :ZkNewFromTitleSelection { dir = '<C-R>=expand('%:p:h')<CR>'}<CR>

    " Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
    " vmap <silent> <Leader>znc :ZkNewFromContentSelection { dir = '<C-R>=expand('%:p:h')<CR>', title = '<C-R>=input('Title: ')<CR>' }<CR>
    " TODO: do this in vimscript
    lua << EOF
      local function map(...) vim.api.nvim_buf_set_keymap(0, ...) end
      local opts = { noremap=true, silent=false }
      map("v", "<leader>znc", ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", opts)
EOF

    " Open notes
    nmap <silent> <Leader>zo :<C-U>ZkNotes { sort = { 'modified' } }<CR>

    " Open notes associated with the tags
    nmap <silent> <Leader>zt :<C-U>ZkTags<CR>

    " Open notes linking to the current buffer.
    nmap <silent> <Leader>zb :<C-U>ZkBacklinks<CR>

    " Open notes linked by the current buffer.
    nmap <silent> <Leader>zl :<C-U>ZkLinks<CR>

    nmap <silent> <Leader>zf :<C-U>execute 'ZkNotes { sort = { "modified" }, match = "' .
      \ input('Search: ') .
      \ '" }'<CR>
    vmap <silent> <Leader>zf :<C-U>'<,'>ZkMatch<CR>
  endif
endif


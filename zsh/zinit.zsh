# zsh/zinit.zsh

export KZ_SOURCE="${KZ_SOURCE} -> zinit.zsh {"

# ----------------------------------------------------------------------------
# Docker
# ----------------------------------------------------------------------------

zinit lucid has'docker' for \
  as'completion' is-snippet \
  'https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker' \
  \
  as'completion' is-snippet \
  'https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose' \
  \
  from'gh-r' as'program' \
  'jesseduffield/lazydocker' \

# ----------------------------------------------------------------------------
# Git
# ----------------------------------------------------------------------------

zinit lucid as'program' for \
  pick"${ZPFX}/bin/git-*" src'etc/git-extras-completion.zsh' \
  make"PREFIX=${ZPFX}" \
  'tj/git-extras'

# ----------------------------------------------------------------------------
# FZF and friends
# ----------------------------------------------------------------------------

# Binary release in archive, from GitHub-releases page.
# After automatic unpacking it provides program "fzf".
! __kz_has fzf && zinit lucid from'gh-r' as'program' for \
  'junegunn/fzf'

export forgit_ignore='fgi'
export FORGIT_GI_REPO_LOCAL="${XDG_DATA_HOME}/forgit/gi/repos/dvcs/gitignore"
# fzf-git -- `` compl for git commands
zinit lucid for \
  'zkhvan/forgit' \
  'torifat/npms'

# zinit light 'Aloxaf/fzf-tab'

# ----------------------------------------------------------------------------
# Misc
# ----------------------------------------------------------------------------

export _ZO_DATA="${XDG_DATA_HOME}/zoxide"

# no wait, want programs available so i can type before prompt ready
zinit lucid from'gh-r' as'program' for \
  mv'bat* -> bat' pick'bat/bat' \
  atclone'cp -vf bat/bat.1 $ZPFX/share/man/man1' atpull'%atclone' \
  '@sharkdp/bat' \
  \
  pick'delta*/delta' \
  atload'export GIT_PAGER="delta --dark"' \
  'dandavison/delta' \
  \
  mv'fd* -> fd' pick'fd/fd' \
  atclone'cp -vf fd/fd.1 $ZPFX/share/man/man1' atpull'%atclone' \
  '@sharkdp/fd' \
  \
  mv'jq* -> jq'             'stedolan/jq' \
  mv'nvim-ctrl* -> nvctl'   'chmln/nvim-ctrl'   \
  mv'shfmt* -> shfmt'       '@mvdan/sh'         \
  \
  mv'zoxide* -> zoxide' \
  atload'eval "$(zoxide init --no-aliases zsh)" && alias j=__zoxide_z && alias ji=__zoxide_zi' \
  'ajeetdsouza/zoxide' \
  \
  mv'ripgrep* -> rg' pick'rg/rg' \
  atclone'cp -vf rg/doc/rg.1 $ZPFX/share/man/man1' atpull'%atclone' \
  'BurntSushi/ripgrep'

zinit lucid for \
  'OMZP::cp' \
  'OMZP::extract' \
  trigger-load'!man' 'OMZP::colored-man-pages'

# ----------------------------------------------------------------------------
# Completion
# ----------------------------------------------------------------------------

# In-line best history match suggestion
# don't suggest lines longer than
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=78
# as of v4.0 use ZSH/zpty module to async retrieve
export ZSH_AUTOSUGGEST_USE_ASYNC=1
# Removed forward-char
export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(vi-end-of-line)
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1

zinit lucid wait for \
  atload'_zsh_autosuggest_start && bindkey "^n" autosuggest-accept' \
  'zsh-users/zsh-autosuggestions' \
  \
  blockf atpull'zinit creinstall -q .' \
  'zsh-users/zsh-completions'

# ----------------------------------------------------------------------------
# Syntax last, and compinit before it
# ----------------------------------------------------------------------------

# don't add wait, messes with zsh-autosuggest
zinit lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" for \
  'zdharma-continuum/fast-syntax-highlighting'

KZ_SOURCE="${KZ_SOURCE} }"

# shell/after.sh

KZ_SOURCE="${KZ_SOURCE} -> shell/after.sh {"

# ============================================================================
# Use neovim
# Now that path is available, use neovim instead of vim if it is installed
# ============================================================================

__kz_prefer 'nvim' && {
  e() {
    nvim "$@"
  }

  export EDITOR='nvim'
  export VISUAL='nvim'
}

# ============================================================================
# npm stuff
# ============================================================================

__kz_prefer 'trash' && alias rm=trash

# ============================================================================
# FZF settings
# after zinit installation
# ============================================================================

# prefer ripgrep
if __kz_has 'rg'; then
  grepper="rg --glob ''"
  grepargs="--files --ignore-file \"${DOTFILES}/ag/dot.ignore\""
  alias ag='rg --hidden --smart-case --ignore-file "${DOTFILES}/ignore/dot.ignore"'
elif __kz_has "ag"; then
  grepper='ag'
  grepargs='-g ""'
  alias ag='ag --hidden --smart-case'
  # --numbers is a default and not supported on old ag
  # --one-device not supported on old ag
elif __kz_has "fd"; then
  grepper='fd'
  grepargs='--type f'
else
  # using git paths only for FZF
  grepper='
    (git ls-tree -r --name-only HEAD ||
    find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
    sed s/^..//) 2> /dev/null'
  grepargs=''
fi

fzfopts="--height=20 --inline-info --min-height=4"

# ** is globbing completion in ZSH, use tickticktab instead
export FZF_COMPLETION_TRIGGER="\`\`"

export FZF_DEFAULT_COMMAND="${grepper} ${grepargs}"

export FZF_DEFAULT_OPTS="${fzfopts} --tiebreak=end"

export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window down:3:hidden:wrap
  --bind '?:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --header 'Press CTRL-Y to copy command into clipboard'"

export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"

FZF_CTRL_T_OPTS="${fzfopts} --tiebreak=end"

# This is used by fzf#vim#with_preview's preview.sh
__kz_has 'bat' && {
  export FZF_PREVIEW_COMMAND="
    bat --color=always --decorations=never --line-range :100 {}
    "

  FZF_CTRL_T_OPTS="${FZF_CTRL_T_OPTS} --preview='${FZF_PREVIEW_COMMAND}'"
}

export FZF_CTRL_T_OPTS

export FZF_ALT_C_OPTS="
  ${fzfopts}
  --tiebreak=end
  --preview='tree -axi -L 2 --filelimit 100 --noreport {}'"

# This needs to happen before sourcing the default fzf bind scripts
if __kz_has "fd"; then
  # Use fd (https://github.com/sharkdp/fd) instead of the default find
  # command for listing path candidates.
  # - The first argument to the function ($1) is the base path to start traversal
  # - See the source code (completion.{bash,zsh}) for the details.
  _fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
  }

  # Use fd to generate the list for directory completion
  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
  }
fi

unset grepper
unset grepargs
unset fzfopts

# ============================================================================

unset KZ_INIT
export KZ_SOURCE="${KZ_SOURCE} }"

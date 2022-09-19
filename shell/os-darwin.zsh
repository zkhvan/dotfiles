# shell/os-darwin.zsh

export KZ_SOURCE="${KZ_SOURCE} -> shell/os-darwin.zsh"

# ============================================================================
# brew
# ============================================================================

# Assume brew is in normal location, don't check for it
if [[ "$(/usr/bin/uname -m)" == "arm64" ]]
then
  export KZ_BREW_PREFIX="/opt/homebrew"

  fpath=(${KZ_BREW_PREFIX}/share/zsh/site-functions $fpath)

  PATH="${KZ_BREW_PREFIX}/bin:${PATH}"
else
  export KZ_BREW_PREFIX="/usr/local"
fi

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1

# ============================================================================
# iterm2
# ============================================================================

# iTerm2 bin
PATH="${HOME}/.iterm2:${PATH}"

# ============================================================================
# Functions
# ============================================================================

# ----------------------------------------------------------------------------
# List installed brew and deps.
#
# Source: https://zanshin.net/2014/02/03/how-to-list-brew-dependencies/
# ----------------------------------------------------------------------------
bwhytree() {
  brew list -1 --formula | while read c; do
    echo -n "\e[1;34m${c} -> \e[0m"
    brew deps "$c" | awk '{printf(" %s ", $0)}'
    echo ""
  done
}

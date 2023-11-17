# shell/interactive.sh

export KZ_SOURCE="${KZ_SOURCE} -> shell/interactive.sh[interactive] {"
[ -f "${HOME}/.local/dotfiles.lock" ] &&
  "${DOTFILES}/shell/kz-wait-for-dotfiles-lock"

# need this here in case not starting a login shell
source "${DOTFILES}/lib/helpers.sh"

# ==============================================================================
# env management -- Node, PHP, Python, Ruby - These add to path
# ==============================================================================

source "${DOTFILES}/shell/go.sh"
#source "${DOTFILES}/shell/java.sh"
source "${DOTFILES}/shell/asdf.sh"
source "${DOTFILES}/shell/node.sh"
#source "${DOTFILES}/shell/php.sh"
source "${DOTFILES}/shell/python.sh"
#source "${DOTFILES}/shell/ruby.bash"
source "${DOTFILES}/shell/rust.sh"

# ============================================================================
# interactive aliases and functions
# source aliases late so command -v (as in __kz_has) doesn't detect them
# ============================================================================

source "${DOTFILES}/shell/functions.sh" # shell functions
source "${DOTFILES}/shell/aliases.sh"   # generic aliases

if [ "$DOTFILES_OS" = 'Darwin' ]; then
  source "${DOTFILES}/shell/aliases-darwin.sh"
fi

# ============================================================================

KZ_SOURCE="${KZ_SOURCE} }"

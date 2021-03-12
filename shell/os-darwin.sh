# shell/os-darwin.sh

export KZ_SOURCE="${KZ_SOURCE} -> shell/os-darwin.sh"

# ============================================================================
# brew
# ============================================================================

# Assume brew is in normal location, don't check for it
export KZ_BREW_PREFIX="/usr/local"

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1


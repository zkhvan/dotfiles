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

unset KZ_INIT
export KZ_SOURCE="${KZ_SOURCE} }"

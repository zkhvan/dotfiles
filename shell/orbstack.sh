# shell/orbstack.sh

export KZ_SOURCE="${KZ_SOURCE} -> shell/orbstack.sh {"

# ============================================================================
# init
# ============================================================================

[[ -d ${HOME}/.orbstack/shell ]] &&
  __kz_source ${HOME}/.orbstack/shell/init.zsh 2>/dev/null || :

# ============================================================================

KZ_SOURCE="${KZ_SOURCE} }"

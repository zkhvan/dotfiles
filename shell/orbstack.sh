# shell/orbstack.sh

export KZ_SOURCE="${KZ_SOURCE} -> shell/orbstack.sh {"

# ============================================================================
# init
# ============================================================================

[[ -d ${HOME}/.orbstack/shell ]] &&
  __kz_source ${HOME}/.orbstack/shell/init.zsh 2>/dev/null || :

# ============================================================================
# orb wrapper: auto --workdir mapped from host CWD
#
# Translates the host's $PWD into a guest path before calling `orb`:
#   - host $HOME            -> guest $HOME (assumed /home/$USER)
#   - paths under host $HOME -> same suffix under guest $HOME
#   - everything else        -> passed through unchanged
# ============================================================================

if command -v orb >/dev/null 2>&1; then
  orb() {
    local host_home="${HOME}"
    local guest_home="/home/${USER}"
    local cwd="${PWD}"
    local workdir

    if [[ "${cwd}" == "${host_home}" ]]; then
      workdir="${guest_home}"
    elif [[ "${cwd}" == "${host_home}/"* ]]; then
      workdir="${guest_home}/${cwd#${host_home}/}"
    else
      workdir="${cwd}"
    fi

    command orb --workdir "${workdir}" "$@"
  }
fi

# ============================================================================

KZ_SOURCE="${KZ_SOURCE} }"

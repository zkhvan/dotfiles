# shell/node.sh

export KZ_SOURCE="${KZ_SOURCE} -> shell/node.sh {"

# https://nodejs.org/api/repl.html#repl_environment_variable_options
export NODE_REPL_HISTORY="${XDG_DATA_HOME}/node_repl_history"

# ============================================================================
# npm config
# ============================================================================

[[ -f "${LDOTDIR}/npmrc" ]] &&
  export NPM_CONF_USERCONFIG="${LDORDIR}/npmrc"

export NPM_CONFIG_INIT_VERSION="0.0.1"
export NPM_CONFIG_INIT_LICENSE="MIT"
export NPM_CONFIG_STRICT_SSL="TRUE"
export NPM_CONFIG_MESSAGE="Cut %s (via npm version)"
export NPM_CONFIG_SIGN_GIT_TAG="TRUE"

# ============================================================================
# npmrc
# ============================================================================

export NPMRC_STORE="${LDOTDIR}/npmrcs"

# ==============================================================================
# fnm
# ==============================================================================

export FNM_DIR="${XDG_CONFIG_HOME}/fnm"

if [[ -d "${FNM_DIR}" ]]; then
  PATH="${FNM_DIR}:${PATH}"
  eval "$(fnm env)" && KZ_SOURCE="${KZ_SOURCE} -> fnm"
fi

# ============================================================================

KZ_SOURCE="${KZ_SOURCE} }"

# shell/k8s.sh

export KZ_SOURCE="${KZ_SOURCE} -> shell/k8s.sh {"

# ============================================================================
# k9s
# ============================================================================

# Prevent screen-dumps from going into MacOS specific home directory
export K9S_CONFIG_DIR=$XDG_CONFIG_HOME/k9s

# ============================================================================
# kubectl helper functions
# ============================================================================

kx() {
  if [ "$1" ]; then
    kubectl config use-context $1
  else
    kubectl config current-context
  fi
}

kn() {
  if [ "$1" ]; then
    kubectl config set-context --current --namespace $1
  else
    kubectl config view --minify | grep namespace | cut -d" " -f6
  fi
}

# ============================================================================
# kubectl plugins
# ============================================================================

_install_krew_plugins() {
  _plugins=(
    'get-all' # get's ALL the resources
  )

  for plugin in "${_plugins[@]}"; do
    if [[ ! -d "${KREW_ROOT}/store/${plugin}" ]]; then
      kubectl krew install "${plugin}"
    fi
  done
}

export KREW_ROOT=$XDG_CONFIG_HOME/krew
export KREW_NO_UPGRADE_CHECK=1

if [[ -d "${KREW_ROOT}" ]]; then
  PATH="${KREW_ROOT}/bin:${PATH}"

  _install_krew_plugins
fi

# ============================================================================

KZ_SOURCE="${KZ_SOURCE} }"

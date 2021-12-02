# shell/python.sh

export KZ_SOURCE="${KZ_SOURCE} -> shell/python.sh {"

# Let python guess where to `import` packages, or use pip instead
unset PYTHONPATH

# ============================================================================
# Package settings
# ============================================================================

# ==============================================================================
# pyenv for multiple Python binaries
# ==============================================================================

# init once
export PYENV_ROOT="${XDG_CONFIG_HOME}/pyenv"
PATH="${PYENV_ROOT}/bin:${PATH}"

# shims (fails silently if bin is not found)
eval "$(pyenv init --path 2>/dev/null)"

__kz_has 'pyenv' && {
  KZ_SOURCE="${KZ_SOURCE} -> pyenv"
  eval "$(pyenv init -)"
  # should have pyenv-virtualenv plugin if installed via pyenv-installer
  __kz_has 'pyenv-virtualenv-init' && eval "$(pyenv virtualenv-init -)"
  export PIPX_DEFAULT_PYTHON="${PYENV_ROOT}/shims/python"
}

# ==============================================================================
# VirtualEnv for python package isolation
# ==============================================================================

# Default virtualenv
# pipenv compatible!
export WORKON_HOME="${XDG_CONFIG_HOME}/venvs"

# Disable auto-add virtualenv name to prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Assign global var to virtualenv name
virtualenv_info() {
  venv=''
  # Strip out the path and just leave the env name
  [ -n "$VIRTUAL_ENV" ] && venv="${VIRTUAL_ENV##*/}"
  [ -n "$venv" ] && printf '%s\n' "$venv"
}

# ============================================================================
# pipenv
# ============================================================================

__kz_has 'pipenv' && eval "$(pipenv --completion)"

# ==============================================================================

KZ_SOURCE="${KZ_SOURCE} }"

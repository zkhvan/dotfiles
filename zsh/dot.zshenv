# dot.zshenv

# Symlinked to ~/.zshenv
# OUTPUT FORBIDDEN
# zshenv is always sourced, even for bg jobs

export KZ_SOURCE="${KZ_SOURCE} -> .zshenv {"

# ============================================================================
# Profiling -- see .zshrc for its execution
# ============================================================================

if [[ "$ITERM_PROFILE" == "PROFILE"* ]] \
  || [[ -n "$KZ_PROFILE_STARTUP" ]]; then
  export KZ_PROFILE_STARTUP="${KZ_PROFILE_STARTUP:-1}"
  echo "==> Profiling ZSH startup"
  # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
  PS4=$'%D{%M%S%.} %N:%i> '
  export KZ_PROFILE_LOG="${HOME}/.cache/zlog.$$"
  exec 3>&2 2>"$KZ_PROFILE_LOG"
  setopt xtrace prompt_subst
fi

# ============================================================================
# ZSH settings
# ============================================================================

# XDG dirs are defined here
. "${HOME}/.dotfiles/shell/vars.sh"

# using prompt expansion and modifiers to get
#   realpath(dirname(absolute path to this file)
#   https://github.com/filipekiss/dotfiles/commit/c7288905178be3e6c378cc4dea86c1a80ca60660#r29121191
export ZDOTDIR="${${(%):-%N}:A:h}"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zshcache"
export HISTFILE="${HOME}/.local/zsh_history"

# ============================================================================

KZ_SOURCE="${KZ_SOURCE} }"
# vim: ft=zsh

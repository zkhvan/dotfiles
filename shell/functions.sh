# shell/functions.sh

export KZ_SOURCE="${KZ_SOURCE} -> shell/functions.sh"

# ============================================================================
# Scripting
# ============================================================================

current_shell() {
  ps -p $$ | awk 'NR==2 { print $4 }'
}

# ============================================================================
# Directory
# ============================================================================

# Go to git root
cdr() {
  git rev-parse || return 1
  cd -- "$(git rev-parse --show-cdup)" || return 1
}

# ============================================================================
# edit
# This is usually overridden in ./after.sh
# ============================================================================

e() {
  vim "$@"
}

# ============================================================================
# edit upwards
# ============================================================================

eu() {
  end="/"
  gitroot=$(git rev-parse --show-cdup || echo '')
  [ -d "$gitroot" ] && end="$gitroot"
  x=$(pwd)
  while [ "$x" != "$end" ] ; do
    result="$(find "$x" -maxdepth 1 -name "$1")"
    [ -f "$result" ] && {
      e "$result"
      return $?
    }
    x=$(dirname "$x")
  done
  return 1
}

# ============================================================================
# Archiving
# ============================================================================

# Export repo files to specified dir
gitexport() {
  to_dir="${2:-./gitexport}"
  rsync -a "${1:-./}" "$to_dir" --exclude "$to_dir" --exclude .git
}

# ============================================================================
# AWS
# ============================================================================

# Pick an AWS_PROFILE from ~/.aws/config using fzf.
# Usage:
#   awsp           -> pick a profile interactively
#   awsp <name>    -> set profile directly (no fzf)
#   awsp -u        -> unset AWS_PROFILE
awsp() {
  local config="${AWS_CONFIG_FILE:-$HOME/.aws/config}"

  if [ "$1" = "-u" ] || [ "$1" = "--unset" ]; then
    unset AWS_PROFILE
    echo "AWS_PROFILE unset"
    return 0
  fi

  if [ ! -f "$config" ]; then
    echo >&2 "awsp: no config found at $config"
    return 1
  fi

  # Extract profile names: "[profile foo]" -> foo, plus "[default]".
  local profiles
  profiles=$(sed -n -E 's/^\[profile[[:space:]]+(.+)\]$/\1/p; s/^\[(default)\]$/\1/p' "$config")

  if [ -z "$profiles" ]; then
    echo >&2 "awsp: no profiles found in $config"
    return 1
  fi

  local choice
  if [ -n "$1" ]; then
    choice="$1"
  else
    choice=$(printf '%s\n' "$profiles" | fzf --height=40% --reverse \
      --prompt="AWS_PROFILE> " --query="${AWS_PROFILE:-}") || return 0
  fi

  [ -z "$choice" ] && return 0

  export AWS_PROFILE="$choice"
  echo "AWS_PROFILE=$AWS_PROFILE"
}

# ============================================================================
# Network tools
# ============================================================================

# Copy ssh key to clipboard
mykey() {
  enc="${1:-id_ed25519}"
  pubkey="${HOME}/.ssh/${enc}.pub"
  [ ! -f "${pubkey}" ] && {
    (echo >&2 "Could not find public key ${pubkey}")
    exit 1
  }

  if __kz_has "pbcopy"; then
    pbcopy <"$pubkey"
  elif __kz_has "xclip"; then
    xclip "$pubkey"
  fi
}

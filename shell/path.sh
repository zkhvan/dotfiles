# shell/path.sh
#
# Sourced in dot.profile on login shells
#
# Rebuild path starting from system path
#
# shell/vars.sh on the other hand just get inherited.
# XDG is set up in init.sh, which should already have been sourced
# pyenv, chruby, chphp pathing is done in shell/after

export KZ_SOURCE="${KZ_SOURCE} -> shell/path.sh"

# ==============================================================================
# Store default system path
# ==============================================================================

# Probably created via /etc/profile and /etc/profile.d/*
#
# On macOS/OS X/BSD path_helper is run in /etc/profile, which generates paths
# using /etc/paths and /etc/paths.d/* and defines the initial $PATH
# Something like "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"

# Note that as of Mojave /usr/local/bin is in /etc/paths
#
# On arch, via /etc/profile, default path is:
# /usr/local/sbin:/usr/local/bin:/usr/bin
export KZ_SYSTEM_PATH="${KZ_SYSTEM_PATH:-$PATH}"

# ============================================================================
# Begin composition
# ============================================================================

# On BSD system, e.g. Darwin -- path_helper is called, reads /etc/paths
# Move local bin to front for homebrew compatibility
PATH="$KZ_SYSTEM_PATH"

# enforce local bin and sbin order, they come before any system paths
# For Mojave, we'll have /usr/local/bin twice. In zsh at least this gets
# deduped.
PATH="/usr/local/bin:/usr/local/sbin:${KZ_SYSTEM_PATH}"

# ----------------------------------------------------------------------------
# Languages
# ----------------------------------------------------------------------------

# dotnet -- DOTNET_* is in shell/vars.sh
PATH="${DOTNET_INSTALL_DIR}:${PATH}"
PATH="${DOTNET_TOOLS_DIR}:${PATH}"

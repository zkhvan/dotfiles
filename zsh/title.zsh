# zsh/title.zsh
#
# Set title of terminal emulator
# Requires add-zsh-hook module (should have been autoloaded in .zshrc)
#

export KZ_SOURCE="${KZ_SOURCE} -> title.zsh"

# print -P means use same escape chars as PROMPT
# %n          expands to $USERNAME
# %m          expands to hostname up to first '.'
# %~          expands to directory, replacing $HOME with '~'

# ============================================================================
# Hook handlers
# ============================================================================

# ----------------------------------------------------------------------------
# ansi-compatible
# ----------------------------------------------------------------------------

__kz_zhook::ansi::process() {
  print -n "\ek${1}\e\\"
}

__kz_zhook::ansi::title() {
  local title="%n@%m:%~"
  print -Pn "\e${title}\e\\"
}

__kz_ztitle::ansi() {
  add-zsh-hook preexec  __kz_zhook::ansi::process
  add-zsh-hook precmd   __kz_zhook::ansi::title
  add-zsh-hook chpwd    __kz_zhook::ansi::title
}

# ----------------------------------------------------------------------------
# xterm-compatible
# ----------------------------------------------------------------------------

__kz_zhook::xterm::process() {
  print -n "\e]0;${1}\a"
}

__kz_zhook::xterm::title() {
  local title="%n@%m:%~"
  print -Pn "\e]0;${title}\a"
}

__kz_ztitle::xterm() {
  add-zsh-hook preexec  __kz_zhook::xterm::process
  add-zsh-hook precmd   __kz_zhook::xterm::title
  add-zsh-hook chpwd    __kz_zhook::xterm::title
}

# ============================================================================
# Use title hooks
# ============================================================================

case "${TERM}" in
  rxvt*|xterm*) __kz_ztitle::xterm ;;

  # echos on tmux :<
  #*)            __kz_term::ansi ;;
esac

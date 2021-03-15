# zsh/prompt-vimode.zsh
#
# VI mode for ZSH readline
#

export KZ_SOURCE="${KZ_SOURCE} -> prompt-vimode.zsh"

# ZSH var, timeout between <Esc> and mode switch update
export KEYTIMEOUT=2

__kz_prompt_vi_insert='%K{blue}%F{white} I %f%k'
__kz_prompt_vi_normal='%K{green}%F{black} N %f%k'

# http://paulgoscicki.com/archives/2012/09/vi-mode-indicator-in-zsh-prompt/
# use vi mode even if EDITOR is emacs
export KZ_PROMPT_VIMODE="${__kz_prompt_vi_insert}"

# ============================================================================
# Show VI mode indicator
# ============================================================================

zle-line-init zle-keymap-select() {
  case ${KEYMAP} in
    (vicmd)       : "${__kz_prompt_vi_normal}" ;;
    (main|viins)  : "${__kz_prompt_vi_insert}" ;;
  esac
  KZ_PROMPT_VIMODE="$_"

  # force redisplay
  zle reset-prompt
  zle -R
}
zle -N zle-line-init
zle -N zle-keymap-select

# ============================================================================
# End of cmd (after pressing <CR> at any point), back to ins mode
# ============================================================================

zle-line-finish() {
  # This will be the prompt for the current line that we're leaving.
  KZ_PROMPT_VIMODE="${__kz_prompt_vi_insert}"
  # Redraw the current line's prompt before advancing to a readline.
  zle reset-prompt
  zle -R
}
zle -N zle-line-finish

# ============================================================================
# On interrupt (<C-c>)
# ============================================================================

TRAPINT() {
  KZ_PROMPT_VIMODE="${__kz_prompt_vi_insert}"
  export KZ_PROMPT_IS_TRAPPED=1
  return $(( 128 + $1 ))
}

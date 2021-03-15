# zsh/prompt.zsh
#
# prompt-*.zsh should be loaded first
# Use add-zsh-hook for precmd or else the other ZSH prompt plugins may break
#

export KZ_SOURCE="${KZ_SOURCE} -> prompt.zsh"

# ============================================================================
# Generic traps
# @see <http://www.dribin.org/dave/blog/archives/2004/01/25/zsh_win_resize/>
# ============================================================================

# @TODO redraw PS1 properly
# TRAPWINCH() {
#   zle && zle -R
# }

# ============================================================================
# components
# ============================================================================

__kz_prompt_left_colors=()
__kz_prompt_left_parts=()
if [[ "$USER" = 'root' ]]
then __kz_prompt_left_colors+=('%F{red}')
else __kz_prompt_left_colors+=('%F{green}')
fi
__kz_prompt_left_parts+=('%n')  # User
__kz_prompt_left_colors+=('%F{blue}')
__kz_prompt_left_parts+=('@')
if [[ -n "$SSH_CONNECTION" ]]
then __kz_prompt_left_colors+=('%F{red}')
else __kz_prompt_left_colors+=('%F{green}')
fi
__kz_prompt_left_parts+=('%m')
__kz_prompt_left_colors+=('%F{blue}')
__kz_prompt_left_parts+=(':')
__kz_prompt_left_colors+=('%F{yellow}')
__kz_prompt_left_parts+=('%~')

__kz_prompt_right_colors=()
__kz_prompt_right_parts=()

# ============================================================================
# precmd - set field values before promptline
# ============================================================================

__kz_prompt::precmd::state() {
  local left_raw="${(%j::)__kz_prompt_left_parts} "
  local left_len=${#left_raw}
  local right_raw=" ${(ej::)__kz_prompt_right_parts}"
  local right_len=${#right_raw}

  local cols
  cols=${COLUMNS:-$(tput cols 2>/dev/null)}
  cols=${cols:-80}

  local left=''
  # colorize
  for (( i = 1; i <= ${#__kz_prompt_left_parts}; i++ )) do
    left="${left}${(%)__kz_prompt_left_colors[i]}${(%)__kz_prompt_left_parts[i]}"
  done
  left="${left} "
  local result="${left}"

  # Right side if has room
  local spaces=$(( $cols - $left_len - $right_len ))
  if (( spaces > 4 )); then
    local right=' '
    # colorize
    for (( i = 1; i <= ${#__kz_prompt_right_parts}; i++ )) do
      right="${right}${(%)__kz_prompt_right_colors[i]}${(e)__kz_prompt_right_parts[i]}"
    done
    result="${result}%F{black}${(l:spaces-1::═:)}%F{blue}${(e)right}%F{blue}"
  fi

  # <C-c> to just output a prompt without the statusline above it
  if (( ${KZ_PROMPT_IS_TRAPPED:-0} == 1 )); then
    export KZ_PROMPT_IS_TRAPPED=0
  else
    print -P "$result"
  fi
}
add-zsh-hook precmd __kz_prompt::precmd::state

# ============================================================================
# prompt main
# ============================================================================

# Actual prompt (single line prompt)
__kz_prompt() {
  PS1=''

  # Time
  #PS1+='%f'

  # VI mode
  PS1+='${KZ_PROMPT_VIMODE}'

  PS1+='%{$reset_color%} '

  # VCS
  PS1+='${vcs_info_msg_0_}'

  # Continuation mode
  PS2="$PS1"
  PS2+='%F{green}.%f '

  # Symbol on PS1 only - NOT on PS2 though
  PS1+='%F{yellow}%#%f %{$reset_color%}'

  # Exit code if non-zero
  RPROMPT='%F{red}%(?..[%?])'
}

__kz_prompt

# zsh/prompt-f3.zsh
#
# f3 context

export KZ_SOURCE="${KZ_SOURCE} -> prompt-f3.zsh"

__kz_prompt::f3::get_expiry_time() {
  __kz_has "f3" || return 1

  auth_info=$(f3 auth info --json 2>/dev/null)
  if [[ $? -ne 0 ]]; then
    return 1
  fi

  echo ${auth_info} | jq -Rr 'fromjson? | .expiry' 2>/dev/null
}

__kz_prompt::f3::get_time_remaining() {
  __kz_has "f3" || return 1

  local now
  local expiry

  now=$(date +%s)
  expiry=$(__kz_prompt::f3::get_expiry_time)

  if [[ $? -ne 0 ]]; then
    return 1
  fi

  if [[ $expiry -lt $now ]]; then
    return 1
  fi

  date -u -r $(expr ${expiry} - ${now}) +"%Hh%Mm%Ss"
}

__kz_prompt::f3::auth::color() {
  __kz_prompt::f3::get_time_remaining > /dev/null 2>&1
  if [[ $? -ne 0 ]]
  then print "%F{red}"
  else print "%F{green}"
  fi
}

__kz_prompt::f3::auth::time_remaining() {
  local time_remaining
  time_remaining=$(__kz_prompt::f3::get_time_remaining)
  if [[ $? -ne 0 ]]
  then print "(f3)"
  else print "(f3:$(__kz_prompt::f3::get_time_remaining))"
  fi
}

__kz_prompt::f3::auth() {
  __kz_has "f3" || return 1

  __kz_prompt_right_colors+='$(__kz_prompt::f3::auth::color)'
  __kz_prompt_right_parts+='$(__kz_prompt::f3::auth::time_remaining)'
}

kz_prompt::f3::init() {
  # __kz_prompt::f3::auth
}

# shell/ruby.sh

export KZ_SOURCE="${KZ_SOURCE} -> shell/ruby.sh {"

__kz_has 'rbenv' && {
  eval "$(rbenv init - --no-rehash zsh)"
}

KZ_SOURCE="${KZ_SOURCE} }"

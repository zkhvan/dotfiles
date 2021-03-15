#!/usr/bin/env bash

__load() {
  readonly tmux_version="$(tmux -V | cut -c 6- | sed 's/[^0-9\.]//g')"

  if (( $(echo "$tmux_version >= 2.9" | bc) == 1 )); then
    tmux source-file "${DOTFILES}/tmux/t2.9.conf"
  fi
}

__load

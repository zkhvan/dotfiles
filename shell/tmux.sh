# shell/tmux.sh

export KZ_SOURCE="${KZ_SOURCE} -> shell/tmux.sh {"

# ============================================================================

# ----------------------------------------------------------------------------
# tmux sessions
# ----------------------------------------------------------------------------
tmux-default() {
  tmux new-session -d -s dotfiles -c ~/.dotfiles/
  tmux \
    new-session -d -s notes -c ~/Projects/notes/app/@notes \; \
    split-window -c ~/Projects/notes -t notes:1 \; \
    send-keys -t notes:1.1 "e" Enter \; \
    send-keys -t notes:1.2 "pnpm dev" Enter \; \
    resize-pane -Z -t notes:1.1
}

# ----------------------------------------------------------------------------
# tmux layout helpers
# ----------------------------------------------------------------------------

tmux-layout() {
  tmux split-window -t 1                -v -p 80 -d
  tmux split-window -t "{top}"          -h -p 50 -d
  tmux split-window -t "{bottom}"       -h -p 90
  tmux split-window -t "{bottom-right}" -h -p 33 -d
  tmux split-window -t "{bottom}"       -v -p 20 -d
}

tmux-select-layout5() {
  tmux select-layout "84fa,478x86,0,0[478x17,0,0{239x17,0,0,174,238x17,240,0,181},478x68,0,18{47x68,0,18,176,288x68,48,18,177,141x68,337,18,180}]"
}

tmux-select-layout6() {
  tmux select-layout "6eb8,478x86,0,0[478x17,0,0{239x17,0,0,174,238x17,240,0,181},478x68,0,18{47x68,0,18,176,288x68,48,18[288x54,48,18,177,288x13,48,73,185],141x68,337,18,180}]"
}

# ============================================================================

KZ_SOURCE="${KZ_SOURCE} }"

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

tmux-layout-half-1() {
  tmux split-window -t 1                -v -p 80 -d
  tmux split-window -t "{top}"          -h -p 50 -d
  tmux split-window -t "{bottom}"       -v -p 20 -d
}

tmux-layout-wide-1() {
  tmux split-window -t 1                -v -p 80 -d
  tmux split-window -t "{top}"          -h -p 50 -d
  tmux split-window -t "{bottom}"       -h -p 33 -d
  tmux split-window -t "{bottom-left}"  -v -p 20 -d
}

tmux-select-layout-half-1() {
  tmux select-layout "dd9a,238x81,0,0[238x16,0,0{118x16,0,0,27,119x16,119,0,29},238x51,0,17,28,238x12,0,69,37]"
}

tmux-select-layout-wide-1() {
  tmux select-layout "ab31,478x81,0,0[478x16,0,0{238x16,0,0,38,239x16,239,0,40},478x64,0,17{320x64,0,17[320x51,0,17,39,320x12,0,69,42],157x64,321,17,41}]"
}

# ============================================================================

KZ_SOURCE="${KZ_SOURCE} }"

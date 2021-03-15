# shell/aliases-darwin.sh

export KZ_SOURCE="${KZ_SOURCE} -> shell/aliases-darwin.sh"

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

alias b='TERM=xterm-256color \brew'
alias brew='b'

alias bi='b install'
alias bs='b search'
alias blfn='b ls --full-name'

alias bsvc='b services'
alias bsvr='b services restart'

alias bwhy='b uses --installed --recursive'

alias cask='brc'
alias ci='brc install'

# ----------------------------------------------------------------------------
# Apps
# ----------------------------------------------------------------------------

alias chrome='open -a "Google Chrome.app"'
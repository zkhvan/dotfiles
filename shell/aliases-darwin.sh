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

# ----------------------------------------------------------------------------
# Networking
# ----------------------------------------------------------------------------

alias localhost-alias='echo 127.0.{1,2}.{1..8} | xargs -n 1 -I{} sudo ifconfig lo0 alias {} 255.255.255.0'
alias proxy='export HTTP_PROXY=127.0.0.1:8888; export HTTPS_PROXY=127.0.0.1:8888'
alias noproxy='unset HTTP_PROXY; unset HTTPS_PROXY'
alias runproxy='mitmproxy -p 8888'

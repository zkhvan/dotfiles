# shell/aliases.sh
# Not run by loader
# Sourced by both .zshrc and .bashrc, so keep it POSIX compatible

export KZ_SOURCE="${KZ_SOURCE} -> shell/aliases.sh"

# ----------------------------------------------------------------------------
# safeguarding
# @see {@link https://github.com/sindresorhus/guides/blob/master/how-not-to-rm-yourself.md#safeguard-rm}
# ----------------------------------------------------------------------------

alias rm='rm -i'

# ----------------------------------------------------------------------------
# paths and dirs
# ----------------------------------------------------------------------------

alias ..='cd -- ..'
alias ....='cd -- ../..'
alias cd-='cd -- -'
alias cd..='cd -- ..'
alias cdd='cd -- "${DOTFILES}"'
alias cdv='cd -- "${VDOTDIR}"'
alias dirs='dirs -v' # default to vert, use -l for list
alias down='cd -- "${XDG_DOWNLOAD_DIR}"'
alias tree='tree -CF'

# ----------------------------------------------------------------------------
# ansible
# ----------------------------------------------------------------------------

alias a=ansible
alias ap=ansible-playbook

# --------------------------------------------------------------------------
# bw
# --------------------------------------------------------------------------
# Workaround to disable punycode deprecation logging to stderr
# https://github.com/bitwarden/clients/issues/6689
alias bw='NODE_OPTIONS="--no-deprecation" bw'

# ----------------------------------------------------------------------------
# editors
# ----------------------------------------------------------------------------

alias ehosts='se /etc/hosts'
alias evr='e "${VDOTDIR}/vimrc"'
alias evp='e "${VDOTDIR}/autoload/kzplug/plugins.vim"'
alias eze='e "${ZDOTDIR}/dot.zshenv"'
alias ezl='e "${LDOTDIR}/zshrc"'
alias ezp='e "${ZDOTDIR}/zplugin.zsh"'
alias ezr='e "${ZDOTDIR}/.zshrc"'
alias esa='e "${DOTFILES}/shell/aliases.sh"'
alias ega='e "${DOTFILES}/git/aliases.gitconfig"'
alias egl='e "${LDOTDIR}/gitconfig"'

# ----------------------------------------------------------------------------
# git
# ----------------------------------------------------------------------------

alias g='git'
alias gs='g status'

# ----------------------------------------------------------------------------
# go
# ----------------------------------------------------------------------------

alias got='gotestsum -- -count=1 -v ./...'

# ----------------------------------------------------------------------------
# greppers
# ----------------------------------------------------------------------------

alias grep='grep --color=auto'

# ----------------------------------------------------------------------------
# Kubernetes
# ----------------------------------------------------------------------------

alias k='kubectl'
alias kcx='kubectl ctx'
alias kcn='kubectl ns'

# short alias to set/show context/namespace (only works for bash and bash-compatible shells, current context to be set before using kn to set namespace)
# alias kx='f() { [ "$1" ] && kubectl config use-context $1 || kubectl config current-context ; } ; f'
# alias kn='f() { [ "$1" ] && kubectl config set-context --current --namespace $1 || kubectl config view --minify | grep namespace | cut -d" " -f6 ; } ; f'

# ----------------------------------------------------------------------------
# ssh
# ----------------------------------------------------------------------------

# @see {@link https://blog.g3rt.nl/upgrade-your-ssh-keys.html}
# Keep this up to date with latest security best practices
alias sshkeygen='ssh-keygen -o -a 100 -t ed25519'

# ----------------------------------------------------------------------------
# sudo ops
# ----------------------------------------------------------------------------

alias mine='sudo chown -R "$USER"'
alias root='sudo -s'
alias se='sudo -e'

# ----------------------------------------------------------------------------
# terraform
# ----------------------------------------------------------------------------

alias tf='terraform'

# ----------------------------------------------------------------------------
# tmux
# ----------------------------------------------------------------------------

alias ta='tmux attach'
alias tp='tmuxp'
alias tpl='tmuxp load'

# ----------------------------------------------------------------------------
# rest of bins
# ----------------------------------------------------------------------------

alias ln='ln -v'
alias o='kz-open'
alias t="tree -a --noreport --dirsfirst -I '.git|node_modules|bower_components|.DS_Store'"
alias today='date +%Y-%m-%d'
alias tpr='tput reset' # really clear the scrollback

# ============================================================================

__alias_ls() {
  __almost_all='-A' # switched from --almost-all for old bash support
  __classify='-F'   # switched from --classify for old bash support
  __colorized='--color=auto'
  __groupdirs='--group-directories-first'
  __literal=''
  __long='-l'
  __single_column='-1'
  __timestyle=''

  if [ "$DOTFILES_OS" = 'Darwin' ]; then
    #__almost_all='-A'
    #__classify='-F'
    __colorized='-G'
    __groupdirs=''
  elif [ "$DOTFILES_OS" = 'Linux' ] \
    && [ "$DOTFILES_DISTRO" != 'busybox' ]; then
    __literal='-N'
    __timestyle='--time-style="+%Y%m%d"'
  fi

  # shellcheck disable=SC2139
  alias ls="ls $__colorized $__literal $__classify $__groupdirs $__timestyle"
  # shellcheck disable=SC2139
  alias la="ls $__almost_all"
  # shellcheck disable=SC2139
  alias l="ls $__single_column $__almost_all"
  # shellcheck disable=SC2139
  alias ll="l $__long"
  # reverse chronological
  alias lr="ll -tUr"
}
__alias_ls

# shell/vars.sh

# Some things from env are here since macOS/OS X doesn't start new env for each
# term and we may need to reset the values

export KZ_SOURCE="${KZ_SOURCE} -> shell/vars.sh"

# dot.bash_profile did this early
DOTFILES_OS="${DOTFILES_OS:-$(uname)}"
export DOTFILES_OS

# ============================================================================
# Locale
# ============================================================================

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# ============================================================================
# Dotfile paths
# ============================================================================

export DOTFILES="${HOME}/.dotfiles"
export BDOTDIR="${DOTFILES}/bash"
export LDOTDIR="${DOTFILES}/local"
export VDOTDIR="${DOTFILES}/vim"
export ZDOTDIR="${DOTFILES}/zsh"

# ============================================================================
# XDG
# ============================================================================

# pretty much the defaults, but explicitly provide for my own use
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"

# ----------------------------------------------------------------------------
# XDG: user-dirs
# ----------------------------------------------------------------------------

# user-dirs.dirs doesn't exist on macOS/OS X so check first.
# Exporting is fine since the file is generated via xdg-user-dirs-update
# and should have those vars. I am just using the defaults but want them
# explicitly defined.
# shellcheck source=/dev/null
[[ -f "${XDG_CONFIG_HOME}/user-dirs.dirs" ]] &&
  source "${XDG_CONFIG_HOME}/user-dirs.dirs" &&
  export \
    XDG_DESKTOP_DIR \
    XDG_DOWNLOAD_DIR \
    XDG_TEMPLATES_DIR \
    XDG_PUBLICSHARE_DIR \
    XDG_DOCUMENTS_DIR \
    XDG_MUSIC_DIR \
    XDG_PICTURES_DIR \
    XDG_VIDEOS_DIR &&
  KZ_SOURCE="${KZ_SOURCE} -> ${XDG_CONFIG_HOME}/user-dirs.dirs"

# ----------------------------------------------------------------------------
# Defaults if not set in user-dirs
# ----------------------------------------------------------------------------

export XDG_DOWNLOAD_DIR="${XDG_DOWNLOAD_DIR:-${HOME}/Downloads}"

# ============================================================================
# History -- except HISTFILE location is set by shell rc file
# ============================================================================

export HISTSIZE=50000
export HISTFILESIZE=$HISTSIZE
export SAVEHIST=$HISTSIZE
export HISTCONTROL=ignoredups
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# ============================================================================
# program settings
# ============================================================================

# ----------------------------------------------------------------------------
# for rsync and cvs
# ----------------------------------------------------------------------------

export CVSIGNORE="${DOTFILES}/git/.gitignore"

# ----------------------------------------------------------------------------
# editor
# ----------------------------------------------------------------------------

export EDITOR='vim'
export VISUAL="$EDITOR"

# ----------------------------------------------------------------------------
# pager
# ----------------------------------------------------------------------------

export PAGER='less'

# ----------------------------------------------------------------------------
# others
# ----------------------------------------------------------------------------

# docker
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"

# less
# -F quit if one screen (default)
# -N line numbers
# -R raw control chars (default)
# -X don't clear screen on quit
# -e LESS option to quit at EOF
export LESS="-eFRX"
# disable less history
export LESSHISTFILE=-

# custom LS_COLORS for deb, might not want on all machines
# @TODO
export LS_COLORS="no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;32:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:"

# man
export MANWIDTH=88
export MANPAGER="$PAGER"

# neovim
export NVIM_PYTHON_LOG_FILE="${DOTFILES}/logs/nvim_python.log"
export NVIM_LISTEN_ADDRESS=localhost:90210

# yarn cache
export YARN_CACHE_FOLDER="${XDG_CACHE_HOME}/yarn"

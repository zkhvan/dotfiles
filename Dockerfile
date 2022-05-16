FROM ubuntu:22.04

ARG TERM=xterm-256color

WORKDIR /root

RUN rm .profile
RUN DEBIAN_FRONTEND=NONINTERACTIVE \
  apt-get update && \
  apt-get install -y \
    coreutils curl git libuser rsync sudo zsh \
    autoconf bash libncurses-dev file unzip bzip2 \
    neovim

COPY . .dotfiles

WORKDIR /root/.dotfiles

RUN bootstrap/symlink
RUN zsh -is "source zsh/.zshrc"

WORKDIR /root

CMD ["zsh"]

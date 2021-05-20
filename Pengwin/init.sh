#!/bin/bash

# ### Before running ###
#
# # Generate .ssh files
# # And register the public keys in GitLab and GitHub.
# $ ssh-keygen -t ed25519
#
#
# ### Then run this script ###
# $ curl -sSL -o ./init.sh https://gitlab.com/mmyoji/dotfiles/raw/master/Pengwin/init.sh
# $ GIT_VERSION=v2.30.2 bash init.sh
#
#
# ### After running script ###
#
# # Edit files for WSL env
# $ cp ~/dev/dotfiles/Pengwin/.profile ~/.profile # or `ln -s`
# $ cp ~/dev/dotfiles/Pengwin/.bashrc  ~/.bashrc  # or `ln -s`
#
# $ ~/.fzf/install
#

set -eux

## Install apt packages ##
sudo apt update -y && sudo apt install -y \
  build-essential \
  curl \
  direnv \
  file \
  git \
  hugo \
  jq \
  libssl-dev \
  make \
  ripgrep \
  tmux \
  tree \
  unzip \
  vim

# For current workplace
sudo apt install -y \
  default-libmysqlclient-dev \
  imagemagick \
  libreadline-dev \
  libsqlite3-dev


# dotfiles #
if [ ! -d "$HOME/dev/dotfiles" ]; then
  git clone git@gitlab.com:mmyoji/dotfiles.git       $HOME/dev/dotfiles
fi

# anyenv #
if [ ! -d "$HOME/.anyenv" ]; then
  git clone https://github.com/anyenv/anyenv         $HOME/.anyenv
  git clone https://github.com/znz/anyenv-update.git $HOME/.anyenv/plugins/anyenv-update
fi

# fzf #
if [ ! -d ~/.fzf ]; then
  git clone https://github.com/junegunn/fzf.git      $HOME/.fzf
fi

# git-completion #
if [ ! -e ~/git-completion.bash ]; then
  curl -sSL -o ~/git-completion.bash \
    https://raw.githubusercontent.com/git/git/$GIT_VERSION/contrib/completion/git-completion.bash
fi

# git-prompt #
if [ ! -e $HOME/git-prompt.sh ]; then
  curl -sSL -o ~/git-prompt.sh \
    https://raw.githubusercontent.com/git/git/$GIT_VERSION/contrib/completion/git-prompt.sh
fi

# Enable git diff-highlight
if [ ! -e /usr/local/bin/diff-highlight ]; then
  current_path=$(pwd)
  cd /usr/share/doc/git/contrib/diff-highlight/
  sudo make
  sudo ln -s /usr/share/doc/git/contrib/diff-highlight/diff-highlight /usr/local/bin/diff-highlight
  cd $current_path
fi

# Apply my custom dotfiles
[ -e ~/.commit_template ] || ln -s $HOME/dev/dotfiles/.commit_template  ~/
[ -e ~/.gemrc ]           || ln -s $HOME/dev/dotfiles/.gemrc            ~/
[ -e ~/.gitconfig ]       || ln -s $HOME/dev/dotfiles/.gitconfig        ~/
[ -e ~/.tmux.conf ]       || ln -s $HOME/dev/dotfiles/.tmux.conf        ~/

cp $HOME/dev/dotfiles/.vimrc  ~/.vimrc

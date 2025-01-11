#!/usr/bin/env bash

DOWNLOAD_DIR=/tmp/nvim
DOWNLOAD_LOCATION=$DOWNLOAD_DIR/nvim.tar.gz
INSTALL_DIR=~/bin
INSTALL_LOCATION=$INSTALL_DIR/nvim

yes | rm -rf $DOWNLOAD_DIR
mkdir -p $DOWNLOAD_DIR

OS_NAME=$(uname)
if [[ $OS_NAME == 'Darwin' ]]; then
  ARCHIVE_NAME=nvim-macos-arm64.tar.gz
else
  ARCHIVE_NAME=nvim-linux64.tar.gz
fi

curl -L https://github.com/neovim/neovim/releases/latest/download/$ARCHIVE_NAME -o $DOWNLOAD_LOCATION
pushd $DOWNLOAD_DIR
tar -xzvf $DOWNLOAD_LOCATION
yes | rm -rf $INSTALL_LOCATION
mkdir -p $INSTALL_DIR
mv $(basename $ARCHIVE_NAME .tar.gz) $INSTALL_LOCATION
popd

sudo ln -fs $INSTALL_LOCATION/bin/nvim /usr/local/bin/nvim

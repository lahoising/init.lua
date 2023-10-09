#!/bin/bash

DOWNLOAD_DIR=/tmp/nvim
DOWNLOAD_LOCATION=$DOWNLOAD_DIR/nvim.tar.gz
INSTALL_DIR=~/bin
INSTALL_LOCATION=$INSTALL_DIR/nvim

yes | rm -rf $DOWNLOAD_DIR
mkdir -p $DOWNLOAD_DIR

curl -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz -o $DOWNLOAD_LOCATION
pushd $DOWNLOAD_DIR
tar -xzvf $DOWNLOAD_LOCATION
yes | rm -rf $INSTALL_LOCATION
mkdir -p $INSTALL_DIR
mv nvim-linux64 $INSTALL_LOCATION
popd

sudo ln -fs -T $INSTALL_LOCATION/bin/nvim /usr/local/bin/nvim

#!/usr/bin/env bash

install_tar() {
  URL="$1"
  TAR_DEST="$2"
  INSTALL_COMMAND="$3"

  TAR_PARENT_DIR="$(dirname $TAR_DEST)"
  TAR_FILENAME="$(basename $TAR_DEST)"
  EXTRACTED_FILENAME="${TAR_FILENAME%.tar.gz}"

  yes | rm -rf $TAR_PARENT_DIR
  mkdir -p $TAR_PARENT_DIR

  curl -R $URL -o $TAR_DEST
  pushd $TAR_PARENT_DIR

  tar -zxvf $TAR_DEST
  pushd $EXTRACTED_FILENAME

  $INSTALL_COMMAND

  popd
  popd
}

# ===== INSTALL REQUIREMENTS =====
sudo apt -y install cmake git curl wget unzip tar gzip build-essential libreadline-dev

# ===== PACKAGE MANAEGERS =====

# install rust/cargo
INSTALL_RUST_SCRIPT=/tmp/install-rust.sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o $INSTALL_RUST_SCRIPT
sh $INSTALL_RUST_SCRIPT --profile default -y
rm $INSTALL_RUST_SCRIPT

# install luarocks
# need to install lua first
LUA_VERSION='5.3.5'
LUA_TAR_NAME="lua-$LUA_VERSION.tar.gz"
LUA_URL="http://www.lua.org/ftp/$LUA_TAR_NAME"
LUA_TAR_DEST="/tmp/lua/$LUA_TAR_NAME"
install_lua() {
  make linux test
  sudo make install
}
install_tar "$LUA_URL" "$LUA_TAR_DEST" 'install_lua'

LUAROCKS_VERSION='3.9.2'
LUAROCKS_TAR_NAME="luarocks-$LUAROCKS_VERSION.tar.gz"
LUAROCKS_URL="http://luarocks.github.io/luarocks/releases/$LUAROCKS_TAR_NAME"
LUAROCKS_TAR_DEST="/tmp/luarocks/$LUAROCKS_TAR_NAME"
install_luarocks() {
  ./configure --with-lua-include=/usr/local/include
  make
  sudo make install
}
install_tar "$LUAROCKS_URL" "$LUAROCKS_TAR_DEST" 'install_luarocks'

# ===== TOOLS ====
cargo install ripgrep

#!/bin/bash

# ===== PACKAGE MANAEGERS =====

# install rust/cargo
INSTALL_RUST_SCRIPT=/tmp/install-rust.sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o $INSTALL_RUST_SCRIPT
sh $INSTALL_RUST_SCRIPT --profile default -y
rm $INSTALL_RUST_SCRIPT

# ===== TOOLS ====
sudo apt -y install cmake
cargo install ripgrep

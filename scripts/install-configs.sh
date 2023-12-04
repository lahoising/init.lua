#!/bin/bash

CONFIG_HOME=~/.config/nvim

mkdir -p $CONFIG_HOME

ln -fs $(pwd)/src/init.lua $CONFIG_HOME/init.lua
ln -fs $(pwd)/src/lua $CONFIG_HOME/lua

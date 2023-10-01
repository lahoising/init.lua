#!/bin/bash

CONFIG_HOME=~/.config/nvim

mkdir -p $CONFIG_HOME

ln -fs -T $(pwd)/src/init.lua $CONFIG_HOME/init.lua
ln -rfs -T $(pwd)/src/lua $CONFIG_HOME/lua

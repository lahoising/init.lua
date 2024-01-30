#!/usr/bin/env bash

FONT_URL='https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/CodeNewRoman.zip'
DESTINATION="/tmp/$HOME/.local/share/fonts"
TEMP_ZIP='/tmp/nerd_font.zip'
EXCLUDED_FILES='license.txt README.md'

mkdir -p $DESTINATION
curl -L $FONT_URL -o "$TEMP_ZIP"
unzip $TEMP_ZIP -x $EXCLUDED_FILES -d $DESTINATION

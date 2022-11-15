#! /bin/sh
#  _____ ______
# |  __ \___  /	Matteo 'DaruZero' Danelon
# | |  | | / / 	
# | |  | |/ /  	https://matteodanelon.com
# | |__| / /__ 	https://github.com/DaruZero
# |_____/_____|
#
# yadm submodules init

log='[00-init-submoduels.sh]:'
echo "$log start script"

cd "$HOME"

echo "$log update submodules"
yadm submodule update --recursive --init

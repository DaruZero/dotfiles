#! /bin/sh
#  _____ ______
# |  __ \___  /	Matteo 'DaruZero' Danelon
# | |  | | / / 	
# | |  | |/ /  	https://matteodanelon.com
# | |__| / /__ 	https://github.com/DaruZero
# |_____/_____|
#
# yadm submodules init

log(){
    local script='[00-init-submoduels.sh]:'
    echo "\033[0;36m$script $1\033[0m"
}
log "start script"

cd "$HOME"

log "update submodules"
yadm submodule update --recursive --init

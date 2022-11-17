#! /bin/sh
#  _____ ______
# |  __ \___  /	Matteo 'DaruZero' Danelon
# | |  | | / / 	
# | |  | |/ /  	https://matteodanelon.com
# | |__| / /__ 	https://github.com/DaruZero
# |_____/_____|
#
# Install zsh and make it default

log(){
    local script='[10-zsh.sh]:'
    echo "\033[0;36m$script $1\033[0m"
}
log "start script"

log "determine distribution family"
DISTRO_FAMILY=$(awk '/ID_LIKE/' /etc/os-release | sed 's/ID_LIKE=//g')

# define package manager to use depending on distribution family
log "determine which package manager to use"
if [[ $DISTRO_FAMILY == 'arch' ]]; then
    log "$pacman"
    package_manager="sudo pacman -S"
elif [[ $DISTRO_FAMILY == 'debian' ]]; then
    log "found apt-get"
    package_manager="sudo apt-get install"
else
    log "distro family not recognized"
    exit 1
fi

# install zsh if not already installed
log "install zsh"
! [[ -x "$(command -v zsh)" ]] && 
    command $package_manager zsh

log "change default shell"
chsh -s $(which zsh)
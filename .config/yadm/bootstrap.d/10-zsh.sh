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
DISTRO_FAMILY=$(grep -e '^ID=' /etc/os-release | sed 's/ID=//g')

# define package manager to use depending on distribution family
log "determine which package manager to use"
case $DISTRO_FAMILY in
    "arch") 
        log "found pacman"
        package_manager="sudo pacman -S --noconfirm";;
    "debian") 
        log "found apt-get"
        package_manager="sudo apt-get -y install";;
    "ubuntu") 
        log "found apt-get"
        package_manager="sudo apt-get -y install";;
    *)
    log "distro family not recognized"
    exit 1;;
esac

# install zsh if not already installed
shell="zsh"
if [ "${shell#$0}" != "$0" ]
then
    log "install zsh"
    command $package_manager zsh
else
    log "zsh already installed"
fi

log "change default shell"
chsh -s $(which zsh)

log "\033[0;32mdone"

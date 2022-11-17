#! /bin/sh
#  _____ ______
# |  __ \___  /	Matteo 'DaruZero' Danelon
# | |  | | / / 	
# | |  | |/ /  	https://matteodanelon.com
# | |__| / /__ 	https://github.com/DaruZero
# |_____/_____|
#
# Install oh-my-zsh

log(){
    local script='[11-install-oh-my-zsh]:'
    echo "\033[0;36m$script $1\033[0m"
}
log "start script"

# if not existing execute install script and restore original .zshrc
if [ ! -d $HOME/.oh-my-zsh ]; then
    log "downloading and running install script"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    log "restoring .zshrc"
    command mv $HOME/.zshrc.pre-oh-my-zsh $HOME.zshrc
fi

log "\033[0;32mdone"

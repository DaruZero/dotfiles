#! /bin/sh
#  _____ ______
# |  __ \___  /	Matteo 'DaruZero' Danelon
# | |  | | / / 	
# | |  | |/ /  	https://matteodanelon.com
# | |__| / /__ 	https://github.com/DaruZero
# |_____/_____|
#
# Install oh-my-zsh

# if not existing execute install script and restore original .zshrc
if [ ! -d $HOME/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    command mv $HOME/.zshrc.pre-oh-my-zsh $HOME.zshrc
fi

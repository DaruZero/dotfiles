#! /bin/sh
#  _____ ______
# |  __ \___  /	Matteo 'DaruZero' Danelon
# | |  | | / / 	
# | |  | |/ /  	https://matteodanelon.com
# | |__| / /__ 	https://github.com/DaruZero
# |_____/_____|
#
# Install oh-my-zsh

if ! [[ -d $HOME/.oh-my-zsh ]];
        then sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

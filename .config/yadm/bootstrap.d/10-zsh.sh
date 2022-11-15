#  _____ ______
# |  __ \___  /	Matteo 'DaruZero' Danelon
# | |  | | / / 	
# | |  | |/ /  	https://matteodanelon.com
# | |__| / /__ 	https://github.com/DaruZero
# |_____/_____|
#
# Install zsh and make it default

# define package manager to use depending on distribution family
if [[ $DISTRO_FAMILY == 'arch' ]]; then
    package_manager="sudo pacman -S"
elif [[ $DISTRO_FAMILY == 'debian' ]]; then
    package_manager="sudo apt-get install"
else
    echo "distro family not recognized"
    exit 1
fi

# install zsh if not already installed
! [[ -x "$(command -v zsh)" ]] && 
    command $package_manager zsh

chsh -s $(which zsh)
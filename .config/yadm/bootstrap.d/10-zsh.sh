#  _____ ______
# |  __ \___  /	Matteo 'DaruZero' Danelon
# | |  | | / / 	
# | |  | |/ /  	https://matteodanelon.com
# | |__| / /__ 	https://github.com/DaruZero
# |_____/_____|
#
# Install zsh and make it default

log='[10-zsh.sh]:'
echo "$log start script"

# define package manager to use depending on distribution family
echo "$log determine which package manager to use"
if [[ $DISTRO_FAMILY == 'arch' ]]; then
    echo "$log found pacman"
    package_manager="sudo pacman -S"
elif [[ $DISTRO_FAMILY == 'debian' ]]; then
    echo "$log found apt-get"
    package_manager="sudo apt-get install"
else
    echo "distro family not recognized"
    exit 1
fi

# install zsh if not already installed
echo "$log install zsh"
! [[ -x "$(command -v zsh)" ]] && 
    command $package_manager zsh

echo "$log change default shell"
chsh -s $(which zsh)
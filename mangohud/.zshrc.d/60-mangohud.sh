#  _____ ______
# |  __ \___  / Matteo 'DaruZero' Danelon
# | |  | | / /
# | |  | |/ /   https://matteodanelon.com
# | |__| / /__  https://github.com/DaruZero
# |_____/_____|
#
# Configure the shell to use with MangoHud

# silently exit if not installed
[[ command -v mangohud --version >/dev/null ]] && exit 0

export MANGOHUD=1 # enable mangohud overlay in games

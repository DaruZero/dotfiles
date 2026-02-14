#  _____ ______
# |  __ \___  / Matteo 'DaruZero' Danelon
# | |  | | / /
# | |  | |/ /   https://matteodanelon.com
# | |__| / /__  https://github.com/DaruZero
# |_____/_____|
#
# Configure the shell to use with go

# silently exit if not installed
[[ command -v go version >/dev/null ]] && exit 0

PATH="$PATH:$HOME/go/bin"

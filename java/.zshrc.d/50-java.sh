#  _____ ______
# |  __ \___  / Matteo 'DaruZero' Danelon
# | |  | | / /
# | |  | |/ /   https://matteodanelon.com
# | |__| / /__  https://github.com/DaruZero
# |_____/_____|
#
# Configure the shell to use with java

# silently exit if not installed
[[ command -v java version >/dev/null ]] && exit 0

[ -s "$HOME/.jabba/jabba.sh" ] && source "$HOME/.jabba/jabba.sh"

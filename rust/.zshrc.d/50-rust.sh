#  _____ ______
# |  __ \___  / Matteo 'DaruZero' Danelon
# | |  | | / /
# | |  | |/ /   https://matteodanelon.com
# | |__| / /__  https://github.com/DaruZero
# |_____/_____|
#
# Configure the shell to use with rust

# silently exit if not installed
[[ command -v rustc --version >/dev/null ]] && exit 0

source "$HOME/.cargo/env"

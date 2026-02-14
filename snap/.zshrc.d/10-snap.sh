#  _____ ______
# |  __ \___  / Matteo 'DaruZero' Danelon
# | |  | | / /
# | |  | |/ /   https://matteodanelon.com
# | |__| / /__  https://github.com/DaruZero
# |_____/_____|
#
# Configure the shell to use with snap

# silently exit if not installed
[[ command -v snap  --version >/dev/null ]] && exit 0

export PATH="/snap/bin:$PATH"

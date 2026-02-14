#  _____ ______
# |  __ \___  / Matteo 'DaruZero' Danelon
# | |  | | / /
# | |  | |/ /   https://matteodanelon.com
# | |__| / /__  https://github.com/DaruZero
# |_____/_____|
#
# Sets environment variables for every shell invocation

# xdg
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# user scripts
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.bin/ascii-art:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# history
export HISTCONTROL=ignoreboth:erasedups
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history| cd -| cd ..)"
export HISTSIZE=5000
export HISTFILESIZE=5000

# terminal
export TERM='xterm-256color'

# gpg
export GPG_TTY="$(tty)"

# other
export PAGER='less'
[ -n "$DISPLAY" ] &&
  export BROWSER=brave ||
  export BROWSER=lynx

# misc
if grep -q ID_LIKE /etc/os-release; then
  export DISTRO_FAMILY=$(awk '/ID_LIKE/' /etc/os-release | sed 's/ID_LIKE=//g')
else
  export DISTRO_FAMILY=$(awk '/^ID/' /etc/os-release | sed 's/ID=//g')
fi

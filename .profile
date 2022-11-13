#  _____ ______
# |  __ \___  /	Matteo 'DaruZero' Danelon
# | |  | | / /
# | |  | |/ /  	https://matteodanelon.com
# | |__| / /__ 	https://github.com/DaruZero
# |_____/_____|
#
# Generic shell config


# user scripts
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.bin/ascii-art:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# history
export HISTCONTROL=ignoreboth:erasedups
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history| cd -| cd ..)"

# terminal 
export TERMINAL='alacritty'
export TERM='xterm-256color'

# editor
export VISUAL='nvim'
export EDITOR='vim'

# gpg
export GPG_TTY="$(tty)"

# misc
export DISTRO_FAMILY=$(awk '/ID_LIKE/' /etc/os-release | sed 's/ID_LIKE=//g')
export PAGER='less'

# rust
. "$HOME/.cargo/env"

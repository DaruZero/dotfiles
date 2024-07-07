#  _____ ______
# |  __ \___  / Matteo 'DaruZero' Danelon
# | |  | | / /
# | |  | |/ /   https://matteodanelon.com
# | |__| / /__  https://github.com/DaruZero
# |_____/_____|
#
# Common profile. Contains env vars, options,
# scripts and anything else useful for all shells

###############
#  VARIABLES  #
###############

# user scripts
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.bin/ascii-art:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# xdg
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# history
export HISTCONTROL=ignoreboth:erasedups
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history| cd -| cd ..)"
export HISTSIZE=5000
export HISTFILESIZE=5000

# terminal
export TERMINAL='alacritty'
export TERM='xterm-256color'

# editor
export VISUAL='nvim'
export EDITOR='vim'

# gpg
export GPG_TTY="$(tty)"

# other
export PAGER='less'
[ -n "$DISPLAY" ] &&
  export BROWSER=brave ||
  export BROWSER=lynx

###############
#  RESOURCES  #
###############

# aliases
if [[ -d "$XDG_CONFIG_HOME/shell-common/alias.d" ]]; then
  for f in $XDG_CONFIG_HOME/shell-common//alias.d; do
    . $f
  done
fi

# functions
if [[ -d "$XDG_CONFIG_HOME/shell-common/function.d" ]]; then
  for f in $XDG_CONFIG_HOME/shell-common//function.d; do
    . $f
  done
fi

# misc
export DISTRO=$(get_distribution | grep -e '^DISTRO=' | cut -d'=' -f2)
export DISTRO_FAMILY=$(get_distribution | grep -e '^DISTRO_LIKE=' | cut -d'=' -f2)

###############
#  OPTIONALS  #
###############

# rust
[[ -x "$(command -v rustc --version)" ]] &&
  . "$HOME/.cargo/env"

# snap
[[ -x "$(command -v snap)" ]] &&
  export PATH="/snap/bin:$PATH"

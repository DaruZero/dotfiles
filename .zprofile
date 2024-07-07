#  _____ ______
# |  __ \___  / Matteo 'DaruZero' Danelon
# | |  | | / /
# | |  | |/ /   https://matteodanelon.com
# | |__| / /__  https://github.com/DaruZero
# |_____/_____|
#
# Zsh profile

# also source common profile
[[ -f $HOME/.profile ]] &&
  source $HOME/.profile

# zsh config dirs
export ZSH_CONFIG_DIR="$XDG_CONFIG_HOME/.config/zsh"
export ZSH_COMPLETIONS_DIR="$ZSH_CONFIG_DIR/completions"
export ZSH_PLUGINS_DIR="$ZSH_CONFIG_DIR/plugins"
export ZSH_THEMES_DIR="$ZSH_CONFIG_DIR/themes"

export SAVEHIST=$HISTFILESIZE
export HISTFILE=~/.zsh_history

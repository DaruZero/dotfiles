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

# snap
[[ -x "$(command -v snap)" ]] &&
  export PATH="/snap/bin:$PATH"

# krew - kubectl plugin manager
[[ -d $HOME/.krew ]] &&
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# rust
. "$HOME/.cargo/env"

# go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

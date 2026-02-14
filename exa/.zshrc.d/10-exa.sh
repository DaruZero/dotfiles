#  _____ ______
# |  __ \___  / Matteo 'DaruZero' Danelon
# | |  | | / /
# | |  | |/ /   https://matteodanelon.com
# | |__| / /__  https://github.com/DaruZero
# |_____/_____|
#
# Configure the shell to use with exa

if command -v eza --version >/dev/null; then
  alias ls='eza -alh --icons --color=always --group-directories-first'
  alias ld='eza -lDh'
  alias lt='eza -aTh --level=2 --icons --color=always --group-directories-first'
  alias l.="eza -ah | grep -E '^\.'"
elif command -v exa --version >/dev/null; then
  alias ls='exa -alh --icons --color=always --group-directories-first'
  alias ld='exa -lDh'
  alias lt='exa -aTh --level=2 --icons --color=always --group-directories-first'
  alias l.="exa -ah | grep -E '^\.'"
fi

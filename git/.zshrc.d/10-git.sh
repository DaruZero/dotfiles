#  _____ ______
# |  __ \___  / Matteo 'DaruZero' Danelon
# | |  | | / /
# | |  | |/ /   https://matteodanelon.com
# | |__| / /__  https://github.com/DaruZero
# |_____/_____|
#
# Configure the shell to use with git

# silently exit if not installed
[[ command -v git --version >/dev/null ]] && exit 0

alias gad='git add'    # add files
alias gaa='git add .'    # add all
alias gbm='git switch main'  # switch to main branch
alias gb='git branch'    # branch
alias gco='git checkout'  # checkout
alias gcl='git clone'     # clone
alias gcm='git commit -m'  # commit with message
alias gcma='git commit -am'  # commit add with message
alias gf='git fetch'    # fetch
alias gpl='git pull'    # pull
alias gps='git push'    # push
alias gst='git status'    # status
alias gt='git tag'    # tag
alias gts='git tag -s'    # signed tag

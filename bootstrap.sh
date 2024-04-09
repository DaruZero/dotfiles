#! /usr/bin/env sh
#  _____ ______
# |  __ \___  /	Matteo 'DaruZero' Danelon
# | |  | | / /
# | |  | |/ /  	https://matteodanelon.com
# | |__| / /__ 	https://github.com/DaruZero
# |_____/_____|
#
# Bootstrap script for my dotfiles repository.

DEV_DIR="$HOME/dev/DaruZero"
DISTRO=""
PKG_MGR=""

info() {
  file_name=$(basename "$0")
  printf "\r  [ \033[00;34mINFO\033[0m ] %s: %s\n" "$file_name" "$1"
}
warn() {
  file_name=$(basename "$0")
  printf "\r  [ \033[0;33mWARN\033[0m ] %s: %s\n" "$file_name" "$1"
}
error() {
  file_name=$(basename "$0")
  printf "\r  [ \033[0;31mERROR\033[0m ] %s: %s\n" "$file_name" "$1"
}
fatal() {
  file_name=$(basename "$0")
  printf "\r  [ \033[0;31mFATAL\033[0m ] %s: %s\n" "$file_name" "$1"
  exit 1
}

checkdeps() {
  deps="$1"
  for dep in $deps; do
    if ! command -v "$dep" >/dev/null 2>&1; then
      error "$dep is required but it's not installed. Aborting."
      exit 1
    fi
  done
}

installdeps() {
  deps="$1"
  for dep in $deps; do
    if ! command -v "$dep" >/dev/null 2>&1; then
      info "\t └ Installing $dep..."
      $PKG_MGR "$dep"
    fi
  done
}


determine_distro() {
  if [ -f /etc/os-release ]; then
    DISTRO=$(grep -e '^ID=' /etc/os-release | sed 's/ID=//g')
    info "  > Detected distribution family: $DISTRO"
  else
    fatal "Cannot determine distribution family. Aborting."
  fi

  case $DISTRO in
    "arch")
      PKG_MGR="sudo pacman -S --noconfirm"
      ;;
    "debian")
      PKG_MGR="sudo apt-get -y install"
      ;;
    "ubuntu")
      PKG_MGR="sudo apt-get -y install"
      ;;
    "fedora")
      PKG_MGR="sudo dnf -y install"
      ;;
    "alpine")
      PKG_MGR="sudo apk add"
      ;;
    *)
      fatal "Distribution family $DISTRO not supported. Aborting."
      ;;
  esac
}

# Ask for the administrator password upfront
# sudo -v

info "Starting script"

info "Checking dependencies"
checkdeps "git"

info "Checking dotfiles repository"
if [ ! -d "$DEV_DIR/dotfiles" ]; then
  info "Dotfiles repository does not exist"
  info "Cloning..."

  git clone --recurse-submodules https://github.com/DaruZero/dotfiles.git "$DEV_DIR/dotfiles" >/dev/null
else
  info "Dotfiles repository already exists"
  info "Updating..."

  cd "$DEV_DIR/dotfiles" || exit

  ## Try to checkout main branch and pull changes. If it fails, or there are uncommitted changes, error out.
  if ! (git checkout main >/dev/null); then
    fatal "Failed to update dotfiles repository. Aborting."
  fi
  if ! (git pull >/dev/null); then
    fatal "Failed to update dotfiles repository. Aborting."
  fi
fi

info "Detecting distribution family"
determine_distro

info "Installing dependencies"
installdeps "bash zsh"

info "Changing default shell to zsh"
if [ "$SHELL" != "$(which zsh)" ]; then
  info "Changing default shell to zsh"
  sudo chsh -s "$(which zsh)" "$USER"
else
  info "Default shell is already zsh"
fi

info "Installing oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Downloading and running install script"
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  info "Restoring .zshrc"
  command mv "$HOME/.zshrc.pre-oh-my-zsh" "$HOME/.zshrc"
else
  info "oh-my-zsh already installed"
fi
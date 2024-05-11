#! /usr/bin/env bash
#  _____ ______
# |  __ \___  /	Matteo 'DaruZero' Danelon
# | |  | | / /
# | |  | |/ /  	https://matteodanelon.com
# | |__| / /__ 	https://github.com/DaruZero
# |_____/_____|
#
# Bootstrap script for my dotfiles repository.

################################################################################
# VARIABLES
################################################################################

DEV_DIR="$HOME/dev/DaruZero"
OPT_DIR="$HOME/.local/opt"
DISTRO=""
DISTRO_LIKE=""
PKG_INSTALL=""
PKG_UPDATE=""
FILES=(
  ".zshrc"
  ".zprofile"
  ".profile"
  ".config/zsh/*"
  ".config/shell-common/*"
)

################################################################################
# UTILITIES
################################################################################

function info() {
  printf "\r  [ \033[00;34mINFO\033[0m ] %s\n" "$1"
}
function warn() {
  printf "\r  [ \033[0;33mWARN\033[0m ] %s\n" "$1"
}
function error() {
  printf "\r  [ \033[0;31mERROR\033[0m ] %s\n" "$1"
}
function fatal() {
  printf "\r  [ \033[0;31mFATAL\033[0m ] %s\n" "$1"
  exit 1
}

################################################################################
# FUNCTIONS
################################################################################

function refresh_pkg_cache() {
  $PKG_UPDATE >/dev/null || fatal "Failed to refresh package database. Aborting."
}

function installdeps() {
  local deps="$1"
  for dep in $deps; do
    if ! command -v "$dep" >/dev/null 2>&1; then
      info "  Installing $dep..."
      $PKG_INSTALL "$dep" >/dev/null || fatal "Failed to install $dep. Aborting."
    fi
  done
}

function installdeps_aur() {
  local deps="$1"
  for dep in $deps; do
    if ! command -v "$dep" >/dev/null 2>&1; then
      info "  Installing $dep..."
      paru -S "$dep" >/dev/null || fatal "Failed to install $dep. Aborting."
    fi
  done
}

function installarchdeps() {
  # in arcolinux, paru and yay are in the arcolinux_repo_3party repository
  if [ "$DISTRO" = "arcolinux" ]; then
    installdeps "paru yay"
  else
    if ! command -v yay >/dev/null 2>&1; then
      info "  Installing yay"
      git clone https://aur.archlinux.org/yay.git "$OPT_DIR/yay" &>/dev/null || fatal "Failed to clone yay repository. Aborting."
      cd "$OPT_DIR/yay" || fatal "Failed to change directory to $OPT_DIR/yay. Aborting."
      makepkg -si --noconfirm >/dev/null || fatal "Failed to install yay. Aborting."
    fi

    if ! command -v paru >/dev/null 2>&1; then
      info "  Installing paru"
      git clone https://aur.archlinux.org/paru.git "$OPT_DIR/paru" &>/dev/null || fatal "Failed to clone paru repository. Aborting."
      cd "$OPT_DIR/paru" || fatal "Failed to change directory to $OPT_DIR/paru. Aborting."
      makepkg -si --noconfirm >/dev/null || fatal "Failed to install paru. Aborting."
    fi
  fi
}

function detect_distro() {
  # exit early if /etc/os-release doesn't exist
  if [ ! -f /etc/os-release ]; then
    fatal "Cannot determine distribution. Aborting."
  fi

  # check the standard ID and return if matches
  DISTRO=$(grep -e "^ID=" /etc/os-release | cut -d'=' -f2-)
  if [ -z "$DISTRO" ]; then
    fatal "Cannot determine distribution. Aborting."
  fi
  info "Detected distribution: $DISTRO"
  case $DISTRO in
  "arch")
    PKG_INSTALL="sudo pacman -S --noconfirm"
    PKG_UPDATE="sudo pacman -Syu --noconfirm"
    return
    ;;
  "debian" | "ubuntu")
    PKG_INSTALL="sudo apt-get -y install"
    PKG_UPDATE="sudo apt-get update"
    return
    ;;
  "fedora")
    PKG_INSTALL="sudo dnf -y install"
    PKG_UPDATE="sudo dnf check-update"
    return
    ;;
  "alpine")
    PKG_INSTALL="sudo apk add"
    PKG_UPDATE="sudo apk update"
    return
    ;;
  esac

  warn "Distribution not recognized. Checking distribution family"

  # check ID_LIKE for distribution based on other distributions
  DISTRO_LIKE=$(grep -e "^ID_LIKE=" /etc/os-release | cut -d'=' -f2-)
  if [ -z "$DISTRO_LIKE" ]; then
    fatal "Cannot determine distribution family. Aborting."
  fi
  info "Detected distribution family: $DISTRO_LIKE"
  case $DISTRO_LIKE in
  *arch*)
    PKG_INSTALL="sudo pacman -S --noconfirm"
    PKG_UPDATE="Updatesudo dnf check-update"
    ;;
  *debian* | *ubuntu*)
    PKG_INSTALL="sudo apt-get -y install"
    PKG_UPDATE=""
    ;;
  *fedora*)
    PKG_INSTALL="sudo dnf -y install"
    PKG_UPDATE="sudo dnf check-update"
    ;;
  *alpine*)
    PKG_INSTALL="sudo apk add"
    PKG_UPDATE="sudo apk update"
    ;;
  *)
    fatal "Distribution family $DISTRO_LIKE not supported"
    ;;
  esac
}

function create_symlinks() {
  local file

  for file in "${FILES[@]}"; do
    local destination="$HOME/${file}"
    local dirname
    dirname="$(dirname "$destination")"

    # Create directories if they don't exist
    mkdir -p "$dirname" || fatal "Failed to create directory $dirname"

    # Expand wildcards (if any)
    if [[ "$file" == *"*"* ]]; then
      for source_file in $file; do
        info "Creating symlink for $source_file"
        ln -sb "$(realpath "$source_file")" "$destination" || fatal "Failed to create symlink for $source_file"
      done
    else
      info "Creating symlink for $file"
      ln -sb "$(realpath "$file")" "$destination" || fatal "Failed to create symlink for $file"
    fi
  done
}

################################################################################
# MAIN
################################################################################

# Ask for the administrator password upfront
sudo -v

info "Starting script"

info "Detecting distribution family"
detect_distro "ID"

info "Installing dependencies"
refresh_pkg_cache
installdeps "base-devel git zsh"

if [ "$DISTRO" = "arch" ] || [ "$DISTRO_LIKE" = "arch" ]; then
  info "Installing arch-specific dependencies"
  installarchdeps
fi

info "Changing default shell to zsh"
if [ "$SHELL" != "$(which zsh)" ]; then
  info "Changing default shell to zsh"
  sudo chsh -s "$(which zsh)" "$USER" || fatal "Failed to change default shell to zsh. Aborting."
else
  info "Default shell is already zsh"
fi

info "Installing oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  if [ "$DISTRO" = "arcolinux" ]; then
    installdeps "oh-my-zsh-git"
  else
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || fatal "Failed to install oh-my-zsh. Aborting."
    mv "$HOME/.zshrc.pre-oh-my-zsh" "$HOME/.zshrc" || warn "No .zshrc.pre-oh-my-zsh file found. Skipping."
  fi
else
  info "oh-my-zsh already installed"
fi

info "Checking dotfiles repository"
if [ ! -d "$DEV_DIR/dotfiles" ]; then
  info "Dotfiles repository does not exist"
  info "Cloning..."
  git clone --recurse-submodules https://github.com/DaruZero/dotfiles.git "$DEV_DIR/dotfiles" &>/dev/null || fatal "Failed to clone dotfiles repository. Aborting."
else
  info "Dotfiles repository already exists"
  info "Updating..."

  cd "$DEV_DIR/dotfiles" || exit

  git checkout main &>/dev/null || fatal "Failed to update dotfiles repository. Aborting."
  git pull &>/dev/null || fatal "Failed to update dotfiles repository. Aborting."
fi

info "Creating symlinks"
create_symlinks

info "Done"

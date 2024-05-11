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
DISTRO_FAMILY=""
PKG_MGR=""
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

function install_aurhelper() {
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

# Function to get distribution name
get_distribution() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
    if [ -n "$ID_LIKE" ]; then
      DISTRO_FAMILY=$ID_LIKE
    else
      DISTRO_FAMILY=$ID
    fi
  elif type lsb_release >/dev/null 2>&1; then
    DISTRO=$(lsb_release -si)
    DISTRO_FAMILY=$(lsb_release -sc)
  elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    DISTRO=$DISTRIB_ID
    DISTRO_FAMILY=$DISTRIB_ID
  elif [ -f /etc/debian_version ]; then
    DISTRO="debian"
    DISTRO_FAMILY="debian"
  elif [ -f /etc/arch-release ]; then
    DISTRO="arch"
    DISTRO_FAMILY="arch"
  elif [ -f /etc/fedora-release ]; then
    DISTRO="fedora"
    DISTRO_FAMILY="fedora"
  elif [ -f /etc/alpine-release ]; then
    DISTRO="alpine"
    DISTRO_FAMILY="alpine"
  else
    DISTRO=$(uname -s)
    DISTRO_FAMILY=$(uname -s)
  fi

  if [ -z "$DISTRO" ]; then
    fatal "Failed to detect distribution"
  fi

  info "Detected distribution: $DISTRO"

  set_package_manager
}

# Function to set package manager based on distribution
set_package_manager() {
  case "$DISTRO_FAMILY" in
  debian | ubuntu)
    PKG_MGR="apt-get"
    PKG_INSTALL="sudo $PKG_MGR install -y"
    PKG_UPDATE="sudo $PKG_MGR update"
    ;;
  arch)
    PKG_MGR="pacman"
    PKG_INSTALL="sudo $PKG_MGR -S --noconfirm"
    PKG_UPDATE="sudo $PKG_MGR -Sy"
    ;;
  fedora)
    PKG_MGR="dnf"
    PKG_INSTALL="sudo $PKG_MGR install -y"
    PKG_UPDATE="sudo $PKG_MGR check-update"
    ;;
  alpine)
    PKG_MGR="apk"
    PKG_INSTALL="sudo $PKG_MGR add"
    PKG_UPDATE="sudo $PKG_MGR update"
    ;;
  *)
    fatal "Unsupported distribution family: $DISTRO_FAMILY"
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

info "Detecting distribution"
get_distribution

info "Installing dependencies"
refresh_pkg_cache
installdeps "base-devel git zsh"

if [ "$DISTRO_FAMILY" = "arch" ]; then
  info "Installing arch-specific dependencies"
  install_aurhelper
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

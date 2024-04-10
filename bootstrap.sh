#! /usr/bin/env bash
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
FILES=(
  ".zshrc"
  ".zprofile"
  ".profile"
  ".config/zsh/*"
  ".config/shell-common/*"
)

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

# TODO: add function to check if a command was successful

refresh_pkg_cache() {
  case $DISTRO in
  "arch" | "arcolinux")
    sudo pacman -Syy --noconfirm
    ;;
  "debian" | "ubuntu")
    sudo apt-get update
    ;;
  "fedora")
    sudo dnf check-update
    ;;
  "alpine")
    sudo apk update
    ;;
  *)
    fatal "Distribution family $DISTRO not supported"
    ;;
  esac
}

installdeps() {
  local deps="$1"
  for dep in $deps; do
    if ! command -v "$dep" >/dev/null 2>&1; then
      info "Installing $dep..."
      $PKG_MGR "$dep" || fatal "Failed to install $dep. Aborting."
    fi
  done
}

installdeps_aur() {
  local deps="$1"
  for dep in $deps; do
    if ! command -v "$dep" >/dev/null 2>&1; then
      info "Installing $dep..."
      paru -S "$dep" || fatal "Failed to install $dep. Aborting."
    fi
  done
}

detect_distro() {
  # exit early if /etc/os-release doesn't exist
  if [ ! -f /etc/os-release ]; then
    fatal "Cannot determine distribution family. Aborting."
  fi

  DISTRO=$(grep -e "^ID=" /etc/os-release | cut -d'=' -f2-)
  if [ -z "$DISTRO" ]; then
    fatal "Cannot determine distribution family. Aborting."
  fi
  info "Detected distribution family: $DISTRO"
  case $DISTRO in
  "arch" | "arcolinux")
    PKG_MGR="sudo pacman -S --noconfirm"
    ;;
  "debian" | "ubuntu")
    PKG_MGR="sudo apt-get -y install"
    ;;
  "fedora")
    PKG_MGR="sudo dnf -y install"
    ;;
  "alpine")
    PKG_MGR="sudo apk add"
    ;;
  *)
    fatal "Distribution family $DISTRO not supported"
    ;;
  esac
}

create_symlinks() {
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

# TODO: move logic to functions

# Ask for the administrator password upfront
sudo -v

info "Starting script"

info "Detecting distribution family"
detect_distro "ID"

info "Installing dependencies"
refresh_pkg_cache
installdeps "base-devel git zsh"

# TODO: fix this step. arcolinux repo doesn't work
# shellcheck disable=SC2154
if [ "$DISTRO" = "arch" ]; then
  info "Installing arch-specific dependencies"

  # in arcolinux, paru and yay are in the arcolinux_repo_3party repository
  if [ "$DISTRO" = "arcolinux" ]; then
    installdeps "paru yay"
  else
    if ! command -v yay >/dev/null 2>&1; then
      info "Installing yay"
      sudo git clone https://aur.archlinux.org/yay.git "/opt/yay" >/dev/null || fatal "Failed to clone yay repository. Aborting."
      cd "/opt/yay" || fatal "Failed to change directory to /opt/yay. Aborting."
      sudo makepkg -si --noconfirm >/dev/null || fatal "Failed to install yay. Aborting."
    fi

    if ! command -v paru >/dev/null 2>&1; then
      info "Installing paru"
      sudo git clone https://aur.archlinux.org/paru.git "/opt/paru" >/dev/null || fatal "Failed to clone paru repository. Aborting."
      cd "/opt/paru" || fatal "Failed to change directory to /opt/paru. Aborting."
      sudo makepkg -si --noconfirm >/dev/null || fatal "Failed to install paru. Aborting."
    fi
  fi
fi

info "Checking dotfiles repository"
if [ ! -d "$DEV_DIR/dotfiles" ]; then
  info "Dotfiles repository does not exist"
  info "Cloning..."
  git clone --recurse-submodules https://github.com/DaruZero/dotfiles.git "$DEV_DIR/dotfiles" >/dev/null || fatal "Failed to clone dotfiles repository. Aborting."
else
  info "Dotfiles repository already exists"
  info "Updating..."

  cd "$DEV_DIR/dotfiles" || exit

  ## Try to checkout main branch and pull changes. If it fails, or there are uncommitted changes, error out.
  git checkout main >/dev/null || fatal "Failed to update dotfiles repository. Aborting."
  git pull >/dev/null || fatal "Failed to update dotfiles repository. Aborting."
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

info "Creating symlinks"
create_symlinks

info "Done"

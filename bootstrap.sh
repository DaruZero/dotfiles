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

installdeps() {
  local deps="$1"
  for dep in $deps; do
    if ! command -v "$dep" >/dev/null 2>&1; then
      info "Installing $dep..."
      $PKG_MGR "$dep"
    fi
  done
}

installdeps_aur() {
  local deps="$1"
  for dep in $deps; do
    if ! command -v "$dep" >/dev/null 2>&1; then
      info "Installing $dep..."
      paru -S "$dep"
    fi
  done
}

detect_distro() {
  local distro_var="$1"
  if [ -f /etc/os-release ]; then
    DISTRO=$(grep -e "^$distro_var=" /etc/os-release | cut -d'=' -f2-)
    if [ -n "$DISTRO" ]; then
      info "Detected distribution family: $DISTRO"
      case $DISTRO in
      "arch")
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
        error "Distribution family $DISTRO not supported"
        return 1
        ;;
      esac
      return 0
    fi
    warn "Cannot determine distribution family from $distro_var in /etc/os-release"
    return 1
  fi

  fatal "Cannot determine distribution family. Aborting."
}

create_symlinks() {
  local file

  for file in "${FILES[@]}"; do
    local destination="$HOME/${file}"
    local dirname
    dirname="$(dirname "$destination")"

    # Create directories if they don't exist
    mkdir -p "$dirname"

    # Expand wildcards (if any)
    if [[ "$file" == *"*"* ]]; then
      for source_file in $file; do
        info "Creating symlink for $source_file"
        ln -sb "$(realpath "$source_file")" "$destination"
      done
    else
      info "Creating symlink for $file"
      ln -sb "$(realpath "$file")" "$destination"
    fi
  done
}

# TODO: move logic to functions

# Ask for the administrator password upfront
sudo -v

info "Starting script"

info "Detecting distribution family"
detect_distro "ID" || {
  # arcolinux uses ID_LIKE instead of ID
  detect_distro "ID_LIKE" || {
    fatal "Failed to determine distribution family."
  }
}

info "Installing dependencies"
installdeps "git zsh"

# TODO: fix this step. arcolinux repo doesn't work
# shellcheck disable=SC2154
if [ "$DISTRO" = "arch" ]; then
  info "Installing arch-specific dependencies"

  # add arcolinux_repo_3party to pacman.conf
  if ! grep -q "arcolinux_repo_3party" /etc/pacman.conf; then
    info "Adding arcolinux_repo_3party to pacman.conf"
    sudo tee -a /etc/pacman.conf <<EOF
[arcolinux_repo_3party]
SigLevel = PackageRequired DatabaseNever
Server = https://arcolinux.github.io/arcolinux_repo_3party/$arch
EOF

    sudo pacman -Syy
  fi

  installdeps "paru yay"
fi

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

info "Changing default shell to zsh"
if [ "$SHELL" != "$(which zsh)" ]; then
  info "Changing default shell to zsh"
  sudo chsh -s "$(which zsh)" "$USER"
else
  info "Default shell is already zsh"
fi

info "Installing oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  if [ "$DISTRO" = "arch" ]; then
    installdeps "oh-my-zsh-git"
  else
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    if [ -f "$HOME/.zshrc.pre-oh-my-zsh" ]; then
      mv "$HOME/.zshrc.pre-oh-my-zsh" "$HOME/.zshrc"
    fi
  fi
else
  info "oh-my-zsh already installed"
fi

info "Creating symlinks"
create_symlinks

info "Done"

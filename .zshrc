###########
#  ZSHRC  #
###########

export ZSH="$HOME/.oh-my-zsh"
export ZSH_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export ZSH_CUSTOM="$ZSH_CONFIG/custom"
export ZSH_CACHE_DIR="$ZSH/cache"
export ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"

#ZSH_THEME="theunraveler"
ZSH_THEME="daru"

# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# HIST_STAMPS="mm/dd/yyyy"
HISTFILE=~/.zsh_history
HISTSIZE=50000

setopt AUTO_CD			# automatically use cd when the command is the name of a directory
setopt NO_CASE_GLOB		# globbing case insensitive
setopt CORRECT			# try to correct spelling of commands
setopt CORRECT_ALL		# try to correct spelling of arguments
setopt GLOB_DOTS		# do not requre a leading '.' in a filename to be matched explicitly
setopt HIST_EXPIRE_DUPS_FIRST	# trim dublicate commands first from history
setopt HIST_FIND_NO_DUPS	# remove duplicate commands when searhing the history
setopt HIST_IGNORE_DUPS		# don't save duplicate commands in history
setopt HIST_REDUCE_BLANKS	# remove superfluous blanks from commands in history
setopt NO_SHARE_HISTORY		# don't share history between sessions

bindkey -e

#############
#  PROFILE  #
#############

[[ -f "$HOME/.zprofile" ]] && source "$HOME/.zprofile"


#############
#  PLUGINS  #
#############

plugins=(
	colored-man-pages
	command-not-found
	copyfile
	dircycle
	docker
	git
	git-prompt
  helm
	kubectl
	terraform
	web-search
	zsh-autosuggestions
)

# Completions
[[ -f $ZSH_CONFIG/completion.zsh ]] && source $ZSH_CONFIG/completion.zsh

## kubectx completions
[[ -f $ZSH/custom/completions/_kubectx.zsh ]] && [[ -f $ZSH/custom/completions/_kubens.zsh ]] &&
	fpath+=($ZSH/custom/completions)

## Terraform
complete -o nospace -C $(which terraform) terraform

## Packer
complete -o nospace -C $(which packer) packer

## Minikube
[[ -f $ZSH_CONFIG/completion-minikube.zsh ]] && source $ZSH_CONFIG/completion-minikube.zsh

# ## Helm
# [[ -f $ZSH_CONFIG/completion-helm.zsh ]] && [[ ! $fpath[(Ie)"$ZSH_CONFIG/completion-helm.zsh"] ]] &&
#   fpath+=($ZSH_CONFIG/completion-helm.zsh)

# Oh-My-Zsh
[[ -f $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh

# zsh-syntax-highlighting
[[ -f "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


###################
#  USER SETTINGS  #
###################

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
[[ -f "$XDG_CONFIG_HOME/shell-common/.aliasrc" ]] && . $XDG_CONFIG_HOME/shell-common/.aliasrc

# Common functions
[[ -f "$XDG_CONFIG_HOME/shell-common/.functionrc" ]] && . $XDG_CONFIG_HOME/shell-common/.functionrc

# Shortcuts
[[ -f "$XDG_CONFIG_HOME/shell-common/.shortcuts" ]] && . $XDG_CONFIG_HOME/shell-common/.shortcuts

# Fetch 
# neofetch

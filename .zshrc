#  _____ ______
# |  __ \___  / Matteo 'DaruZero' Danelon
# | |  | | / /
# | |  | |/ /   https://matteodanelon.com
# | |__| / /__  https://github.com/DaruZero
# |_____/_____|
#
# Zsh configuration

#############
#  PROFILE  #
#############

# source the zprofile if not in a login shell
[[ -o login_shell ]] && [[ -f $HOME/.zprofile ]] &&
  source $HOME/.zprofile

#############
#  OPTIONS  #
#############

setopt   AUTO_CD                # automatically use cd when the command is the name of a directory
unsetopt CASE_GLOB              # globbing case insensitive
setopt   CORRECT_ALL            # try to correct spelling of arguments
setopt   CORRECT                # try to correct spelling of commands
setopt   GLOB_DOTS              # do not requre a leading '.' in a filename to be matched explicitly
setopt   HIST_EXPIRE_DUPS_FIRST # trim dublicate commands first from history
setopt   HIST_FIND_NO_DUPS      # remove duplicate commands when searhing the history
setopt   HIST_IGNORE_DUPS       # don't save duplicate commands in history
setopt   HIST_REDUCE_BLANKS     # remove superfluous blanks from commands in history
unsetopt SHARE_HISTORY          # don't share history between sessions

# completion options
setopt   ALWAYS_TO_END          # Move cursor to the end of a completed word
setopt   AUTO_LIST              # Automatically list choices on ambiguous completion
setopt   AUTO_MENU              # Show completion menu on a succesive tab press
setopt   AUTO_PARAM_SLASH       # If completed parameter is a directory, add a trailing slash
setopt   AUTO_REMOVE_SLASH      # Remove trailing slashes
setopt   COMPLETE_IN_WORD       # Complete from both ends of a word
unsetopt FLOW_CONTROL           # Disable start/stop characters in shell editor
setopt   GLOB_COMPLETE          # Show completions for glob instead of expanding
unsetopt MENU_COMPLETE          # Do not autoselect the first completion entry
setopt   PATH_DIRS              # Perform path search even on command names with slashes

#############
#  PLUGINS  #
#############

export ZSH_PLUGINS=(
  colored-man-pages
  command-not-found
  copyfile
	dircycle
	docker
	git
	web-search
)

for plugin in "${ZSH_PLUGINS[@]}"; do
  plugin_file="${ZSH_PLUGINS_DIR}/${plugin}.plugin.zsh"
  if [[ -f "$plugin_file" ]]; then
    source "$plugin_file"
  else
    echo "Plugin $plugin not found in $ZSH_PLUGINS_DIR"
  fi
done

# https://github.com/zsh-users/zsh-autosuggestions
# https://github.com/zsh-users/zsh-syntax-highlighting
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/jump
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/rand-quote
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/thefuck
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/themes
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/zsh-interactive-cd

# plugins cache
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"

plugins=(
	colored-man-pages
	command-not-found
	copyfile
	dircycle
	docker
  "functions"
	git
	web-search
	zsh-autosuggestions
)

# Completions
[[ -f $ZSH_CONFIG/completion.zsh ]] && source $ZSH_CONFIG/completion.zsh
# completions cache
export ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"
# https://github.com/zsh-users/zsh-completions
# docker https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

# zsh-syntax-highlighting
[[ -f "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

###########
#  THEME  #
###########

ZSH_THEME="theunraveler"

##############
#  KEYBINDS  #
##############

# use emacs bindings
bindkey -e

# [PageUp] - Up a line of history
if [[ -n "${terminfo[kpp]}" ]]; then
  bindkey -M emacs "${terminfo[kpp]}" up-line-or-history
  bindkey -M viins "${terminfo[kpp]}" up-line-or-history
  bindkey -M vicmd "${terminfo[kpp]}" up-line-or-history
fi
# [PageDown] - Down a line of history
if [[ -n "${terminfo[knp]}" ]]; then
  bindkey -M emacs "${terminfo[knp]}" down-line-or-history
  bindkey -M viins "${terminfo[knp]}" down-line-or-history
  bindkey -M vicmd "${terminfo[knp]}" down-line-or-history
fi

# Start typing + [Up-Arrow] - fuzzy find history forward
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search

bindkey -M emacs "^[[A" up-line-or-beginning-search
bindkey -M viins "^[[A" up-line-or-beginning-search
bindkey -M vicmd "^[[A" up-line-or-beginning-search
if [[ -n "${terminfo[kcuu1]}" ]]; then
  bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
fi

# Start typing + [Down-Arrow] - fuzzy find history backward
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -M emacs "^[[B" down-line-or-beginning-search
bindkey -M viins "^[[B" down-line-or-beginning-search
bindkey -M vicmd "^[[B" down-line-or-beginning-search
if [[ -n "${terminfo[kcud1]}" ]]; then
  bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# [Home] - Go to beginning of line
if [[ -n "${terminfo[khome]}" ]]; then
  bindkey -M emacs "${terminfo[khome]}" beginning-of-line
  bindkey -M viins "${terminfo[khome]}" beginning-of-line
  bindkey -M vicmd "${terminfo[khome]}" beginning-of-line
fi
# [End] - Go to end of line
if [[ -n "${terminfo[kend]}" ]]; then
  bindkey -M emacs "${terminfo[kend]}"  end-of-line
  bindkey -M viins "${terminfo[kend]}"  end-of-line
  bindkey -M vicmd "${terminfo[kend]}"  end-of-line
fi

# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then
  bindkey -M emacs "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
fi

# [Backspace] - delete backward
bindkey -M emacs '^?' backward-delete-char
bindkey -M viins '^?' backward-delete-char
bindkey -M vicmd '^?' backward-delete-char
# [Delete] - delete forward
if [[ -n "${terminfo[kdch1]}" ]]; then
  bindkey -M emacs "${terminfo[kdch1]}" delete-char
  bindkey -M viins "${terminfo[kdch1]}" delete-char
  bindkey -M vicmd "${terminfo[kdch1]}" delete-char
else
  bindkey -M emacs "^[[3~" delete-char
  bindkey -M viins "^[[3~" delete-char
  bindkey -M vicmd "^[[3~" delete-char

  bindkey -M emacs "^[3;5~" delete-char
  bindkey -M viins "^[3;5~" delete-char
  bindkey -M vicmd "^[3;5~" delete-char
fi

# [Ctrl-Delete] - delete whole forward-word
bindkey -M emacs '^[[3;5~' kill-word
bindkey -M viins '^[[3;5~' kill-word
bindkey -M vicmd '^[[3;5~' kill-word

# [Ctrl-RightArrow] - move forward one word
bindkey -M emacs '^[[1;5C' forward-word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5C' forward-word
# [Ctrl-LeftArrow] - move backward one word
bindkey -M emacs '^[[1;5D' backward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M vicmd '^[[1;5D' backward-word


bindkey '\ew' kill-region                             # [Esc-w] - Kill from the cursor to the mark
bindkey -s '\el' 'ls\n'                               # [Esc-l] - run command: ls
bindkey '^r' history-incremental-search-backward      # [Ctrl-r] - Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.
bindkey ' ' magic-space                               # [Space] - don't do history expansion


# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# file rename magick
bindkey "^[m" copy-prev-shell-word

# Fetch 
# neofetch

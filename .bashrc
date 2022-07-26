# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# --------------------------------- ALIASES -----------------------------------

alias ..='cd ..'
alias q='exit'
alias c='clear'
alias cp='cp -v'
alias rm='rm -I'
alias mv='mv -iv'
alias ln='ln -sriv'

### Colorize commands
command -v exa > /dev/null && \
	alias ls='exa'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'=

### LS & TREE
TREE_IGNORE="cache|log|logs|node_modules|vendor"

alias ll='ls -lGah'
alias la='ls -a'
alias lt='ls --tree -I ${TREE_IGNORE}'
alias lt1='ls --tree -L 1 -I ${TREE_IGNORE}'
alias lt2='ls --tree -L 2 -I ${TREE_IGNORE}'

# TOP

alias top='gtop'


# --------------------------------- SETTINGS ----------------------------------

shopt -s checkwinsize
shopt -s globstar

# HISTORY
shopt -s histappend

HISTCONTROL=ignoreboth
HISTSIZE=5000
HISTFILESIZE=5000
HISTFILE=~/.bash_history

# BASH COMPLETION
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ----------------------------------- MISC -----------------------------------

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='code'
fi

# colorize ls
[ -x /usr/bin/dircolors ] && eval "$(dircolors -b)"

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
	PS1="\[\e]0;\u@\h: \w\a\]$PS1"
	;;
esac

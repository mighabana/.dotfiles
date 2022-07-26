# oh-my-zsh configuration

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# ZSH plugins
plugins=(git asdf)

source $ZSH/oh-my-zsh.sh

# User configuration

# --------------------------------- ALIASES -----------------------------------

alias q='exit'
alias c='clear'
alias cp='cp -v'
alias mv='mv -iv'
alias ln='ln -siv'

### Colorize commands
command -v exa > /dev/null && \
	alias ls='exa'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'

### LS & TREE
TREE_IGNORE="cache|log|logs|node_modules|vendor"

alias ll='ls -lGah'
alias la='ls -a'
alias lt='ls --tree -I ${TREE_IGNORE}'
alias lt1='ls --tree -L 1 -I ${TREE_IGNORE}'
alias lt2='ls --tree -L 2 -I ${TREE_IGNORE}'

# TOP

alias top='btop'

# --------------------------------- SETTINGS ----------------------------------

# reference: https://zsh.sourceforge.io/Doc/Release/Options.html

### Changing Directories
setopt AUTO_CD

### Expansion and Globbing
setopt MAGIC_EQUAL_SUBST
setopt NO_NOMATCH
setopt NUMERIC_GLOB_SORT

### History
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000


### Zle
setopt BEEP


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

### POWERLEVEL

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### direnv
eval "$(direnv hook bash)"

### Auto-load Python Virtualsdfasdf
python_venv() {
  MY_VENV=./venv
  if [[ -z "$VIRTUAL_ENV" ]]; then
    if [[ -d $MY_VENV ]]; then
      source ${MY_VENV}/bin/activate
    fi
  else
    parentdir="$(dirname "$VIRTUAL_ENV")"
    if [[ "$PWD"/ != ${parentdir}/* ]]; then
      deactivate
    fi
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd python_venv
python_venv
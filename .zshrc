# --- oh-my-zsh configuration
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
plugins=(git)
[[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]] && plugins+=('zsh-autosuggestions')

source $ZSH/oh-my-zsh.sh
[[ -f $HOME/.asdf/asdf.sh ]] && . $HOME/.asdf/asdf.sh

# User configuration

# --------------------------------- ALIASES -----------------------------------

alias q='exit'
alias c='clear'
alias cp='cp -iv'
alias mv='mv -iv'

### Colorize commands
alias ls='eza --color=always --git --icons=always'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'

### LS & TREE
TREE_IGNORE=".cache .git logs node_modules"

alias ll='ls -lGah'
alias la='ls -a'
alias lt='ls --tree -L 1 -I "${TREE_IGNORE}"'
alias lt2='ls --tree -L 2 -I "${TREE_IGNORE}"'
alias lt3='ls --tree -L 3 -I "${TREE_IGNORE}"'

# TOP

command -v btop &>/dev/null && alias top='btop'

# --------------------------------- SETTINGS ----------------------------------

# reference: https://zsh.sourceforge.io/Doc/Release/Options.html

### Changing Directories
setopt AUTO_CD

### Expansion and Globbing
setopt MAGIC_EQUAL_SUBST
setopt NO_NOMATCH
setopt NUMERIC_GLOB_SORT

### History
HISTFILE=${HOME}/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

setopt HIST_FIND_NO_DUPS HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS INC_APPEND_HISTORY

### Zle
setopt BEEP


# ----------------------------------- MISC -----------------------------------

# print envrc content like the env command
envrc() {
  if [[ -f ".envrc" && -r ".envrc" ]]; then
    cat .envrc
  else
    echo "no readable .envrc file found"
  fi
}

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vi'
else
  export EDITOR='hx'
fi

# colorize ls
[ -x /usr/bin/dircolors ] && eval "$(dircolors -b)"

# --- FZF

# setup fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# use fd instead of fzf

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# use fd for listing path candidates
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

### POWERLEVEL

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### direnv
eval "$(direnv hook zsh)"

### Auto-load Python Virtual Environment
python_venv() {
    local venv_dirs=("./venv" "./.venv")
    for dir in "${venv_dirs[@]}"; do
        if [[ -z "$VIRTUAL_ENV" && -d $dir ]]; then
            source "$dir/bin/activate"
            return
        fi
    done
    if [[ -n "$VIRTUAL_ENV" ]]; then
        parentdir=$(dirname "$VIRTUAL_ENV")
        if [[ "$PWD"/ != "$parentdir"/* ]]; then
            deactivate
        fi
    fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd python_venv
python_venv

[[ ":$PATH:" != *":/opt/homebrew/opt/curl/bin:"* ]] && export PATH="/opt/homebrew/opt/curl/bin:$PATH"
[[ ":$PATH:" != *":/usr/local/opt/tcl-tk/bin:"* ]] && export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
[[ ":$PATH:" != *":$HOME/.dotfiles/scripts/bin:"* ]] && export PATH="$HOME/.dotfiles/scripts/bin:$PATH"

export HELIX_RUNTIME="$HOME/src/helix/runtime"


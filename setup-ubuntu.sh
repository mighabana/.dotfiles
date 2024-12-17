#!/bin/bash

set -e # Exit immediately if any command exitss with a non-zero status
set -u # treat unset variables as an error
set -o pipefail # return exit status of the last command in a pipeline that failed

log() { echo -e "\033[1;32m[INFO]\033[0m $1"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $1"; exit 1; }

# ----------------------------------- SETUP -----------------------------------

# --- apt setup
sudo apt update && sudo apt upgrade -y

### install package dependencies

missing_packages=()

while IFS= read -r pkg; do
    # Remove inline comments and trim whitespace
    pkg=$(echo "$pkg" | sed 's/#.*//' | xargs)

    # Skip empty lines (including those left empty after comment removal)
    [[ -z "$pkg" ]] && continue

    # Check if the package is NOT installed
    if ! dpkg -s "$pkg" &>/dev/null; then
        missing_packages+=("$pkg")
    fi
done < apt.pkg

# Check if there are missing packages
if [ "${#missing_packages[@]}" -gt 0 ]; then
    log "Installing missing packages: ${missing_packages[@]}"
    sudo apt install -y "${missing_packages[@]}"
else
    log "All package dependencies are already installed."
fi

# --- ZSH setup

### install OhMyZSH!
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    log "Oh-My-Zsh already installed, skipping."
else
    log "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || error "Failed to install Oh-My-Zsh."
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

install_zsh_plugin() {
    plugin_url=$1
    plugin_dir=$2
    if [[ -d "$plugin_dir" ]]; then
        log "Plugin already exists: $plugin_dir, skipping."
    else
        git clone --depth=1 "$plugin_url" "$plugin_dir" && log "Installed plugin: $plugin_dir"
    fi
}

### install powerlevel10k
install_zsh_plugin "https://github.com/romkatv/powerlevel10k.git" "$ZSH_CUSTOM/themes/powerlevel10k"

### install zsh-autosuggestions
install_zsh_plugin "https://github.com/zsh-users/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# --- install nerd fonts
FONT_DIR="${HOME}/.fonts
mkdir -p "$FONT_DIR"
cp -R "$PWD/fonts/Mononoki Nerd/" "$FONT_DIR"
sudo fc-cache -f -v

# --- install asdf
if [[ ! -d "$HOME/.asdf" ]]; then
    log "Installing asdf..."
    git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.14.1 || error "Failed to install asdf."
else
    log "asdf already installed, skipping."
fi

# ----------------------------------- CONFIGS -----------------------------------

create_symlink() {
    src=$1
    dest=$2
    ln -sf "$src" "$dest" && log "Created symlink: $src -> $dest"
}

# --- setup symlinks to config files

mkdir ${HOME}/.config/helix/themes/

create_symlink $PWD/.bashrc ${HOME}
create_symlink $PWD/.zshrc ${HOME}
create_symlink $PWD/.gitconfig ${HOME}
create_symlink $PWD/.p10k.zsh ${HOME}
create_symlink $PWD/helix/config.toml ${HOME}/.config/helix/
create_symlink $PWD/helix/themes/night_owl.toml ${HOME}/.config/helix/themes/
create_symlink $PWD/tilda/config_0 ${HOME}/.config/tilda/

# ----------------------------------- INSTALLATION -----------------------------------

# --- install asdf plugins and tools

declare -A tools=(
    [python]=3.12.8
    [terraform]=1.10.2
    [gcloud]=503.0.0
    [nodejs]=v22.12.0
    [rust]=1.83.0
)

for tool in "${!tools[@]}"; do
    asdf plugin-list | grep -q "$tool" || asdf plugin-add "$tool"
    asdf install "$tool" "${tools[$tool]}"
    asdf global "$tool" "${tools[$tool]}"
done

# --- install helix language servers

### python
command -v pip >/dev/null || error "pip is not installed. Please install Python first."

pip install "python-lsp-server[all]"

### typescript
command -v npm >/dev/null || error "NPM is not installed. Please install Node.js first."

log "Installing TypeScript language server..."
npm install -g typescript-language-server || error "Failed to install TypeScript language server."


# --- install dev utils
command -v cargo >/dev/null || error "Cargo is not installed. Please install Rust first."

log "Installing development utilities via cargo..."
cargo install eza du-dust fd-find || error "Cargo utility installation failed."

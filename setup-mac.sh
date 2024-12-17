#!/bin/bash

set -e # Exit immediately if any command exitss with a non-zero status
set -u # treat unset variables as an error
set -o pipefail # return exit status of the last command in a pipeline that failed

log() { echo -e "\033[1;32m[INFO]\033[0m $1"; }
error() { echo -e "\033[1;31m[ERROR]\033[0m $1"; exit 1; }

# ----------------------------------- SETUP -----------------------------------

# --- homebrew setup

### install Homebrew
if ! command -v brew &>/dev/null; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" || error "Homebrew installation failed."
else
    log "Homebrew already installed, skipping."
fi

# add Homebrew to my PATH
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ${HOME}/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

### install package dependencies
if [[ -f "brew.pkg" ]]; then
    log "Installing CLI utilities from brew.pkg..."
    brew install $(<brew.pkg) || error "Failed to install Homebrew packages."
else
    error "brew.pkg file not found."
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

# install nerd fonts
log "Installing Nerd Fonts..."
brew tap homebrew/cask-fonts
brew install --cask font-mononoki-nerd-font

# --- install asdf
if [[ ! -d "$HOME/.asdf" ]]; then
    log "Installing asdf..."
    git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.14.1 || error "Failed to install asdf."
else
    log "asdf already installed, skipping."
fi

# install SOPS
curl -LO https://github.com/getsops/sops/releases/download/v3.9.1/sops-v3.9.1.darwin.arm64
sudo mv sops-v3.9.1.darwin.arm64 /usr/local/bin/sops
sudo chmod +x /usr/local/bin/sops

# ----------------------------------- CONFIGS -----------------------------------

create_symlink() {
    src=$1
    dest=$2
    ln -sf "$src" "$dest" && log "Created symlink: $src -> $dest"
}

# --- setup symlinks to config files

if ! [[ -d ${HOME}/.config/helix/themes ]]; then
    mkdir ${HOME}/.config/helix/themes
fi

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
    [postgres]=17.2
)

# Function to add and install asdf plugins/tools
install_tool() {
    local tool=$1
    local version=$2

    # Check if plugin exists
    if asdf plugin-list | grep -q "^${tool}$"; then
        log "Plugin '${tool}' already exists. Skipping plugin addition."
    else
        log "Adding plugin '${tool}'..."
        asdf plugin-add "$tool" || error "Failed to add plugin '${tool}'."
    fi

    # Install tool version
    if asdf list "$tool" | grep -q "$version"; then
        log "Tool '${tool}' version '${version}' is already installed."
    else
        log "Installing '${tool}' version '${version}'..."
        asdf install "$tool" "$version" || error "Failed to install '${tool}' version '${version}'."
    fi

    # Set tool version globally
    log "Setting '${tool}' version '${version}' globally."
    asdf global "$tool" "$version" || error "Failed to set '${tool}' version globally."
}

# Install all tools
for tool in "${!tools[@]}"; do
    install_tool "$tool" "${tools[$tool]}"
done

log "All tools have been successfully installed and configured."

# --- install helix language servers

### Python LSP installation ---
if command -v pip >/dev/null; then
    if pip show python-lsp-server >/dev/null 2>&1; then
        log "Python language server (pylsp) is already installed. Skipping."
    else
        log "Installing Python language server (pylsp)..."
        pip install "python-lsp-server[all]" || error "Failed to install Python language server."
        log "Python language server installed successfully."
    fi
else
    error "pip is not installed. Please install Python first."
fi

### TypeScript LSP installation ---
if command -v npm >/dev/null; then
    if npm list -g typescript-language-server >/dev/null 2>&1; then
        log "TypeScript language server is already installed. Skipping."
    else
        log "Installing TypeScript language server..."
        npm install -g typescript-language-server || error "Failed to install TypeScript language server."
        log "TypeScript language server installed successfully."
    fi
else
    error "NPM is not installed. Please install Node.js first."
fi

# --- install dev utils

# Ensure Cargo is available
if ! command -v cargo >/dev/null; then
    error "Cargo is not installed. Please install Rust first."
fi

# Function to check if a cargo package is already installed
cargo_package_installed() {
    local package_name=$1
    cargo install --list 2>/dev/null | grep -E "^${package_name} v[0-9.]+:" >/dev/null
}

# List of development utilities to install via Cargo
DEV_UTILS=("eza" "du-dust" "fd-find")

log "Installing development utilities via Cargo..."

for util in "${DEV_UTILS[@]}"; do
    if cargo_package_installed "$util"; then
        log "'$util' is already installed. Skipping."
    else
        log "Installing '$util'..."
        if cargo install "$util"; then
            log "'$util' installed successfully."
        else
            warn "Failed to install '$util'."
        fi
    fi
done

log "Development utilities setup complete."

# ----------------------------------- TERMINATION -----------------------------------

log "Setup complete!"

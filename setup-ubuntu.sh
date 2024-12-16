#!/bin/bash

set -e # Exit on any error

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
    echo "Installing missing packages: ${missing_packages[@]}"
    sudo apt install -y "${missing_packages[@]}"
else
    echo "All package dependencies are already installed."
fi


# --- ZSH setup

### install OhMyZSH!
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

### install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

### install zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# --- install nerd fonts
FONT_DIR="${HOME}/.fonts
mkdir -p "$FONT_DIR"
cp -R "$PWD/fonts/Mononoki Nerd/" "$FONT_DIR"
sudo fc-cache -f -v

# --- install asdf
if [[ ! -d "$HOME/.asdf" ]]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
fi

# ----------------------------------- CONFIGS -----------------------------------

# --- setup symlinks to config files

mkdir ${HOME}/.config/helix/themes/

ln -sf $PWD/.bashrc ${HOME}
ln -sf $PWD/.zshrc ${HOME}
ln -sf $PWD/.gitconfig ${HOME}
ln -sf $PWD/.p10k.zsh ${HOME}
ln -sf $PWD/helix/config.toml ${HOME}/.config/helix/
ln -sf $PWD/helix/themes/night_owl.toml ${HOME}/.config/helix/themes/
ln -sf $PWD/tilda/config_0 ${HOME}/.config/tilda/

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
pip install "python-lsp-server[all]"

### typescript
npm install -g typescript-language-server

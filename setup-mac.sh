#!/bin/bash

# ----------------------------------- INSTALLATION -----------------------------------

# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

### add Homebrew to my PATH
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ${HOME}/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# install CLI utilities
brew install $(<brew.pkg)

# install OhMyZSH!
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

### install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

### install zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions

# install nerd fonts
cp -R $PWD/fonts/Mononoki\ Nerd/ ~/Library/Fonts/

# install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0

### configure asdf packages and global versions
asdf plugin-add python
asdf install python 3.12.5
asdf global python 3.12.5

asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git
asdf install terraform 1.9.5
asdf global terraform 1.9.5

asdf plugin add gcloud https://github.com/jthegedus/asdf-gcloud
asdf install gcloud 491.0.0
asdf global gcloud 491.0.0

asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs v20.17.0
asdf global nodejs v20.17.0

asdf plugin-add rust https://github.com/asdf-community/asdf-rust.git
asdf install rust 1.80.1
asdf global rust 1.80.1

### setup helix language servers
pip install "python-lsp-server[all]"
npm install -g typescript-language-server

# install SOPS
curl -LO https://github.com/getsops/sops/releases/download/v3.9.1/sops-v3.9.1.darwin.arm64
sudo mv sops-v3.9.1.darwin.arm64 /usr/local/bin/sops
sudo chmod +x /usr/local/bin/sops

# ----------------------------------- CONFIGS -----------------------------------

# setup symlinks to config files
ln -siv $PWD/.bashrc ${HOME}:
ln -siv $PWD/.zshrc ${HOME}
ln -siv $PWD/.gitconfig ${HOME}
ln -siv $PWD/.gitconfig.personal ${HOME}
ln -siv $PWD/.gitconfig.fgi ${HOME}
ln -siv $PWD/.p10k.zsh ${HOME}

ln -siv $PWD/helix/config.toml ${HOME}/.config/helix/
mkdir ${HOME}/.config/helix/themes/
ln -siv $PWD/helix/themes/night_owl.toml ${HOME}/.config/helix/themes/

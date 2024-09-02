# install CLI utilities
brew install btop direnv dust exa fd hx

# install OhMyZSH!
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# setup symlinks to config files
ln -siv $(PWD)/.bashrc $(HOME)
ln -siv $(PWD)/.zshrc $(HOME)
ln -siv $(PWD)/.gitconfig $(HOME)
ln -siv $(PWD)/.gitconfig.personal $(HOME)
ln -siv $(PWD)/.gitconfig.fgi $(HOME)
ln -siv $(PWD)/.p10k.zsh $(HOME)
ln -siv $(PWD)/helix/config.toml $(HOME)/.config/helix/
ln -siv $(PWD)/helix/themes/night_owl.toml $(HOME)/.config/helix/themes/

# install nerd fonts
cp -R $(PWD)/fonts/Mononoki\ Nerd/ ~/Library/Fonts/


# install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0

asdf plugin-add python
asdf install python 3.10.12

asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git
asdf install terraform 1.5.5

asdf plugin add gcloud https://github.com/jthegedus/asdf-gcloud
asdf install gcloud 443.0.0

asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs 18.17.1

# setup helix language servers

pip isntall "python-lsp-server[all]"
npm isntall -g typescript-language-server
brew install hashicorp/tap/terraform-ls
OS := $(shell uname)

deps:
	@if [ $(OS) = "Linux" ]; then\
			command -v exa > /dev/null && \
			command -v btop > /dev/null && \
			command -v git > /dev/null && \
			command -v zsh > /dev/null && \
			[-d ~/.oh-my-zsh ] && \
			[ -d ~/.oh-my-zsh/custom/themes/powerlevel10k/ ] \
	elif [ $(OS) = "Darwin" ]; then\
			echo "$(OS): Missing dependencies"; \
			exit 1
	fi

build:
	@ln -siv $(PWD)/.bashrc $(HOME)
	@ln -siv $(PWD)/.zshrc $(HOME)
	@ln -siv $(PWD)/.gitconfig $(HOME)
	@ln -siv $(PWD)/.p10k.zsh $(HOME)
	@if [ -d $(HOME)/.config/tilda ]; then\
		ln -siv $(PWD)/tilda/config_0 $(HOME)/.config/tilda; \
	fi

install:
	@if [ $(OS) = "Linux" ]; then \

		sudo apt install exa direnv tilda git zsh build-essential; \
		sudo snap install btop; \
		sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; 
	fi

asdf_setup:

	sudo apt update &&
		sudo apt install curl git

	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2

	sudo apt install -y \
		zlib1g-dev \
		libbz2-dev \
		libffi-dev \
		libreadline-dev \
		libncursesw5 \
		libssl-dev \
		libsqlite3-dev \
		tk-dev \
		liblzma-dev 

	asdf install python 3.10.6

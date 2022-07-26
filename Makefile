OS := $(shell uname)

deps:
	@if [ $(OS) = "Linux" ]; then\
			command -v exa > /dev/null; \
			command -v gtop > /dev/null; \
			command -v git > /dev/null; \
			command -v zsh > /dev/null; \
			[ -d ~/.oh-my-zsh ]; \
			[ -d ~/.oh-my-zsh/custom/themes/powerlevel10k/ ]; \
	elif [ $(OS) = "Darwin" ]; then\
		echo "asd" \
	else \
			echo "$(OS): Missing dependencies"; \
			exit 1; \
	fi

build: deps
	@ln -siv $(PWD)/.bashrc $(HOME)
	@ln -siv $(PWD)/.zshrc $(HOME)
	@ln -siv $(PWD)/.gitconfig $(HOME)
	@ln -siv $(PWD)/.p10k.zsh $(HOME)
	@if [ -d $(HOME)/.config/tilda ]; then\
		ln -siv $(PWD)/tilda/config_0 $(HOME)/.config/tilda; \
	fi

install: deps
	@if [ $(OS) = "Linux"]; then \

		sudo apt install exa direnv tilda; \
		sudo snap install btop
	fi
		 
	
 


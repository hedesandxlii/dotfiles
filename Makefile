TMUX_PATH := /usr/bin/tmux
BIN_DIR := ./bin


STOW_PATH := /usr/bin/stow
STOW ?= stow -v -t ${HOME}

.PHONY: bashrc

all: $(TARGETS)

bashrc:
	echo '#### Load dotfiles'                                 >> ~/.bashrc
	echo "my_bashrc_path=$(realpath ./bashrc/my_bashrc.bash)" >> ~/.bashrc
	echo "dotfiles_bin_path=$(realpath $(BIN_DIR))"           >> ~/.bashrc
	echo '[ -f "$$my_bashrc_path" ] \'                        >> ~/.bashrc
	echo '    && source "$$my_bashrc_path" \'                 >> ~/.bashrc
	echo '    || echo No file "$$my_bashrc_path"'             >> ~/.bashrc
	echo '[ -d "$$dotfiles_bin_path" ] \'                     >> ~/.bashrc
	echo '    && export PATH="$$dotfiles_bin_path:$$PATH" \'  >> ~/.bashrc
	echo '    || echo No directory "$$dotfiles_bin_path"'     >> ~/.bashrc
	echo '#### Load dotfiles'                                 >> ~/.bashrc

# TODO: cargo dependency
$(BIN_DIR)/hx: $(STOW_PATH) .git/modules/submodules/helix/HEAD
	cargo install \
		--path submodules/helix/helix-term \
		--locked \
		--root ./ \
		--bin hx \
		--force

	$(STOW) helix

# TODO: fzf git dependency?? (or mby it's fixed in 25.04?)
tmux: apt-tmux apt-fzf $(STOW_PATH)
	$(STOW) tmux

$(STOW_PATH): apt-stow

apt-%:
	sudo apt install -y $*

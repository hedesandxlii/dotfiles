STOW_CMD ?= stow -v -t ${HOME}

BIN_DIR := ./bin

TARGETS := bashrc helix tmux

.PHONY: $(TARGETS) _cargo_from_apt_rustup _submodules
all: $(TARGETS)

bashrc: git-fzf
	@echo '#### Load dotfiles'                                 >> ~/.bashrc
	@echo "my_bashrc_path=$(realpath ./bashrc/my_bashrc.bash)" >> ~/.bashrc
	@echo "dotfiles_bin_path=$(realpath $(BIN_DIR))"           >> ~/.bashrc
	@echo '[ -d "$$dotfiles_bin_path" ] \'                     >> ~/.bashrc
	@echo '    && export PATH="$$dotfiles_bin_path:$$PATH" \'  >> ~/.bashrc
	@echo '    || echo No directory "$$dotfiles_bin_path"'     >> ~/.bashrc
	@echo '[ -f "$$my_bashrc_path" ] \'                        >> ~/.bashrc
	@echo '    && source "$$my_bashrc_path" \'                 >> ~/.bashrc
	@echo '    || echo No file "$$my_bashrc_path"'             >> ~/.bashrc
	@echo '#### Load dotfiles'                                 >> ~/.bashrc
	@echo '[INFO] Appended load-dotfile block to .bashrc'

helix: _cargo_from_apt_rustup _submodules
	cargo install \
		--path submodules/helix/helix-term \
		--locked \
		--root ./ \
		--bin hx \
		--force
	$(STOW_CMD) helix

tmux: apt/tmux git-fzf lazygit
	$(STOW_CMD) tmux

git-fzf: _submodules
	make -C ./submodules/fzf
	cp -f ./submodules/fzf/target/fzf-linux_amd64 ./bin/fzf

lazygit: apt/golang-go
	GOPATH=$(PWD) go install github.com/jesseduffield/lazygit@latest

_cargo_from_apt_rustup: apt/rustup
	rustup install stable

_submodules:
	git submodule update --init --recursive

apt/%:
	sudo apt install -y $*

$(wildcard *): apt/stow  # Makes everything dependant on stow

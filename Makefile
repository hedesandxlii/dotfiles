STOW ?= stow -v -t ${HOME}
TARGETS := helix bashrc tmux pipx python-lsps scripts


.PHONY: $(TARGETS)

all: $(TARGETS)


/usr/bin/stow:
	sudo apt install stow

/snap/bin/hx:
	sudo snap install --classic helix

/usr/bin/tmux:
	sudo snap install --classic helix

/snap/bin/cargo:
	sudo snap install rustup

/usr/bin/fzf:
	sudo apt install fzf

pipx:
	sudo apt install pipx

python-lsps:
	pipx install python-lsp-server
	pipx inject python-lsp-server pylsp-mypy python-lsp-ruff

scripts: /usr/bin/stow
	$(STOW) scripts

bashrc: /usr/bin/stow
	$(STOW) --ignore='.*include_snippet' bashrc
	cat bashrc/include_snippet >> ~/.bashrc

helix: /usr/bin/stow /snap/bin/hx
	$(STOW) helix

tmux: /usr/bin/tmux /usr/bin/fzf
	$(STOW) tmux


clean:
	$(STOW) --delete $(TARGETS)

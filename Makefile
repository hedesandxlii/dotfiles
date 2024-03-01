STOW ?= stow -v -t ${HOME}
TARGETS := helix bashrc tmux pipx python-lsp-server scripts


.PHONY: $(TARGETS)

all: $(TARGETS)

apt-%:
	sudo apt install -y $*

snap-%:
	sudo snap install --classic $*

python-lsp-server: apt-pipx
	pipx install python-lsp-server
	pipx inject python-lsp-server pylsp-mypy python-lsp-ruff

scripts: apt-stow
	$(STOW) scripts

bashrc: apt-stow
	$(STOW) --ignore='.*include_snippet' bashrc
	cat bashrc/include_snippet >> ~/.bashrc

helix: apt-stow snap-helix
	$(STOW) helix

tmux: apt-stow apt-tmux apt-fzf
	$(STOW) tmux


clean: apt-stow
	$(STOW) --delete $(TARGETS)

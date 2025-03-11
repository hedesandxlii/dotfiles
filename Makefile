STOW ?= stow -v -t ${HOME}
TARGETS := helix bashrc tmux scripts fzf


.PHONY: $(TARGETS)

all: $(TARGETS)

apt-%:
	sudo apt install -y $*

snap-%:
	sudo snap install --classic $*

scripts: apt-stow
	$(STOW) scripts

bashrc: apt-stow
	$(STOW) --ignore='.*include_snippet' bashrc
	cat bashrc/include_snippet >> ~/.bashrc

helix: apt-stow snap-helix
	$(STOW) helix

tmux: apt-stow apt-tmux fzf
	$(STOW) tmux

fzf:
	- git clone --depth 1 https://github.com/junegunn/fzf.git ~/repos/fzf
	~/repos/fzf/install --completion --key-bindings --no-zsh --no-fish

clean: apt-stow
	$(STOW) --delete $(TARGETS)

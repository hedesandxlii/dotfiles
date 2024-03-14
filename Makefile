STOW ?= stow -v -t ${HOME}
TARGETS := helix bashrc tmux scripts


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

tmux: apt-stow apt-tmux apt-fzf
	$(STOW) tmux


clean: apt-stow
	$(STOW) --delete $(TARGETS)

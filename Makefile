STOW ?= stow -v -t ${HOME}
TARGETS := helix bashrc tmux


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

bashrc: /usr/bin/stow
	$(STOW) --ignore='.*include_snippet' bashrc
	cat bashrc/include_snippet >> ~/.bashrc

helix: /usr/bin/stow /snap/bin/hx
	$(STOW) helix

tmux: /usr/bin/tmux
	$(STOW) tmux


clean:
	$(STOW) --delete $(TARGETS)

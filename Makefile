STOW ?= stow -v -t ${HOME}

.PHONY: bashrc

all: bashrc

/usr/bin/stow:
	sudo apt install stow

bashrc: /usr/bin/stow
	$(STOW) --ignore='.*include_snippet' bashrc
	cat bashrc/include_snippet >> ~/.bashrc

clean:
	$(STOW) --delete bashrc

STOW ?= stow -v -t ${HOME}
TARGETS := helix bashrc


.PHONY: $(TARGETS)

all: $(TARGETS)


/usr/bin/stow:
	sudo apt install stow

/snap/bin/hx:
	sudo snap install --classic helix

bashrc: /usr/bin/stow
	$(STOW) --ignore='.*include_snippet' bashrc
	cat bashrc/include_snippet >> ~/.bashrc

helix: /usr/bin/stow /snap/bin/hx
	$(STOW) helix

clean:
	$(STOW) --delete $(TARGETS)

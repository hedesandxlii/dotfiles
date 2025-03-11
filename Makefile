STOW ?= stow -v -t ${HOME}
TARGETS := helix bashrc tmux scripts

$(wildcard *): apt-stow  # Makes everything dependant on stow

.PHONY: $(TARGETS)

all: $(TARGETS)

apt-%:
	sudo apt install -y $*

scripts:
	$(STOW) scripts

bashrc: apt-fzf
	$(STOW) --ignore='.*include_snippet' bashrc
	cat bashrc/include_snippet >> ~/.bashrc

helix:
	cargo install --path submodules/helix/helix-term --locked
	$(STOW) helix

tmux: apt-tmux apt-fzf
	$(STOW) tmux

clean:
	$(STOW) --delete $(TARGETS)

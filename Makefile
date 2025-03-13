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
	echo "[ -f $(realpath bashrc/.my_bashrc) ] \\" >> ~/.bashrc
	echo "    && source $(realpath bashrc/.my_bashrc) \\" >> ~/.bashrc
	echo "    || echo No file $(realpath bashrc/.my_bashrc)" >> ~/.bashrc

helix:
	cargo install --path submodules/helix/helix-term --locked
	$(STOW) helix

tmux: apt-tmux apt-fzf
	$(STOW) tmux

clean:
	$(STOW) --delete $(TARGETS)

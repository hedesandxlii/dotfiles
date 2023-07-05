#
# Make-based bootstrap
#

yay:
	sudo pacman -S --needed git base-devel
	git clone https://aur.archlinux.org/yay.git
	(cd yay && makepkg -si)

bash:
	which bash

	# Appends an include snippet to ~/.bashrc
	# which includes ~/.my_bashrc (which is also symlinked)
	cat ${PWD}/bashrc/include_snippet >> ${HOME}/.bashrc
	ln -vsf ${PWD}/bashrc/my_bashrc ${HOME}/.my_bashrc

tmux:
	sudo pacman -Sy tmux

	rm -rf ~/.tmux/plugins/tpm
	git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm

	ln -vsf ${PWD}/tmux/tmux.conf ${HOME}/.tmux.conf

helix: yay
	yay -Sy helix-git

	mkdir -pv ${HOME}/.config/helix

	ln -vsf ${PWD}/helix/config.toml ${HOME}/.config/helix/config.toml
	ln -vsf ${PWD}/helix/languages.toml ${HOME}/.config/helix/languages.toml

xlayoutdisplay: yay
	yay -Sy  xlayoutdisplay

	sudo echo "ACTION==\"change\", SUBSYSTEM==\"drm\", ENV{HOME}=\"$HOME\", ENV{DISPLAY}=\":0\", ENV{XAUTHORITY}=\"$env{HOME}/.Xauthority\", RUN+=\"/bin/sh -c 'xlayoutdisplay -w 5 >> /tmp/xlayoutdisplay.udev.log 2>&1'\"" > /etc/udev/rules.d/99-xlayoutdisplay.ruls

fira-code:
	sudo pacman -Sy ttf-fira-code


kitty:
	sudo pacman -Sy kitty

	mkdir -pv ${HOME}/.config/kitty
	
	ln -vsf ${PWD}/kitty/kitty.conf ${HOME}/.config/kitty/kitty.conf

node:
	sudo pacman -Sy nodejs npm

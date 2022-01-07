# Dotfiles

This is a collection of my dotfiles, mainly being for neovim and bash.

# Quickstart

```sh
$ ./bootstrap --install
```

will install NeoVim and Doom-nvim. These are installed into `./.deps` and then
installed or symlinked to work as if they where installed manually.


To uninstall, simply run

```sh
$ ./bootstrap --uninstall
```

which cleans up the steps from `bootstrap --install`, i.e.
isolates the dependencies to `./.deps` (which can later be removed).


# TODO

* Automatic install of FiraCode font ([Ad Hoc curl install](https://github.com/ryanoasis/nerd-fonts#option-6-ad-hoc-curl-download) or apt package `fonts-firacode`)
* Automatic install of NeoVim [build prerequisites](https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites).
* Set-up Doom-nvim to my specs :) (config, `pynvim`, ...)
* Fix symlink issue where relative paths turn into broken links.
* Automagically install `node/npm`. Used for lsps in nvim (See [here](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-20-04))

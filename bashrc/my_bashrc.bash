_prepend_path ()    { export PATH="$1:$PATH"; }  # extend PATH with $1
prepend_path ()     { [ -d "$1" ] && _prepend_path "$1" || echo "$1 does not exist"; }
mby_prepend_path () { [ -d "$1" ] && _prepend_path "$1"; }
mby_run_file ()     { [ -f "$1" ] && "$1" || echo "$1 does not exist"; }
mby_source_file ()  {
  # shellcheck source=/dev/null
  [ -f "$1" ] && source "$1";
}

mby_source_file "/etc/skel/.bashrc"             # ubuntu bash defaults
mby_source_file "$HOME/.bash_hostspecific"      # hostspecific aliases and env.vars

mby_prepend_path "$HOME/.local/bin"
mby_prepend_path "$HOME/.cargo/bin"       # cargo (rust)
mby_prepend_path "$HOME/.npm-global/bin"  # "npm -g" bins
mby_prepend_path "$HOME/go/bin"           # go packages
mby_prepend_path "$HOME/.local/bin/flutter/bin"

get_helix_runtime_value () {
  bash_source="${BASH_SOURCE[0]}"
  my_bashrc_path="$(realpath "$bash_source")"
  dotfiles_root="$(dirname "$(dirname "$my_bashrc_path")")"
  echo "${dotfiles_root}/submodules/helix/runtime"
}

# Environment variables
helix_runtime_value=$(get_helix_runtime_value)
export HELIX_RUNTIME="$helix_runtime_value"
export EDITOR=hx
export BROWSER=chromium

# Handy aliases
alias rm='rm --interactive=once'
alias p="python3"
alias pm="python3 -m"
alias tmux="tmux -2"

# git aliases
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.st 'status --short --branch'
git config --global alias.br branch
git config --global alias.cp cherry-pick
git config --global alias.rb rebase
git config --global alias.rbc 'rebase --continue'
git config --global alias.d diff
git config --global alias.ds 'diff --staged'
git config --global alias.unstage 'reset HEAD --'
git config --global alias.unmodify 'checkout --'
git config --global alias.lg 'log --oneline -n10'
git config --global alias.lgg 'log --graph --oneline --branches -n 20 HEAD'
git config --global alias.detach 'checkout --detach'
git config --global alias.cleen 'clean -df'
git config --global alias.ups 'commit -a --amend --no-edit'
git config --global alias.ui  '!lazygit || echo "could not launch lazygit :("'

# gerrit pushing
git config --global alias.magic '!git push origin HEAD:refs/for/master'
git config --global alias.blackmagic 'push --no-verify origin HEAD:refs/for/master'

# history sharing (t.y.: https://unix.stackexchange.com/a/48113)
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=$HISTSIZE
shopt -s histappend
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Generated with https://bash-prompt-generator.org/
export PS1='\[\e[35m\]\w\[\e[0m\] [$?] \\$ '

eval "$(fzf --bash)"

## Utility functions

# Returns the unmerged file names
conflicts () {
  git diff --name-only --diff-filter=U
}

# Returns the files modified in previous commit
changed () {
  git diff HEAD~1 --name-only
}



# grep + sed based symbol renamer
#
# $1 is the old name
# $2 is the new name
# $3 is the working directory (or "." if ommited)
rename-symbol () {
  if [ $# -lt 2 ]; then
    echo "not enough arguments"
    return 1
  fi

  root=${3:-.}

  git grep -lr -1 "$1" "$root" | xargs -I % sed -i "s|$1|$2|g" %

  echo "Changed all occurences under \"$root\" from"
  echo "\"$1\""
  echo "to"
  echo "\"$2\""
}

# applies diff of 'source' file between 'git refs' to 'destination file'
#
# $1 source file
# $2 destination file
# $3 git refs (optional)
apply-diff () {
  local tmp_file="/tmp/ah-get-diff.patch"
  local src="$1"
  local dst="$2"
  local git_refs="${3:-HEAD^}"

  git diff "$git_refs" -- "$src" > "$tmp_file"
  patch --merge=diff3 "$dst" "$tmp_file"
}

# handy clipboard copy.
#
# Example:
#    cat my_file.txt | ahclip
ahclip () {
	cat - | xclip -selection clipboard
}

# handy clipboard paste.
#
# Example:
#    cat my_file.txt | ahclip
ahpaste () {
	xclip -o -selection clipboard
}

ahclipcmd () {
  history | cut -d' ' -f4- | tail -n2 | head -n1 | ahclip
}


create-venv () {
  echo "Creating virtualenv with uv"
  uv venv
}
echo-venvs () { find . -mindepth 3 -maxdepth 3 -name activate | grep venv; }

v () {
  [ -z "$(echo-venvs)" ] && create-venv "$1"

  # shellcheck disable=SC1090
  source "$(echo-venvs | fzf --select-1 --exit-0)"

  echo ">>> Installing python-lsp-server, pylsp-mypy & pylsp-rope"
  uv pip install python-lsp-server pylsp-mypy pylsp-rope
}

# $1 is a git ref (default HEAD)
# $2 is an file filter command (default "cat", i.e. ignore nothing)
suggest-reviewers () {
  commit=${1:-HEAD}
  filter_cmd=${2:-"cat"}

  echo "Suggested reviewers for $(git log "$commit" --oneline -n1)"
  file-owner "$commit" "$(git diff "$commit"~1 "$commit" --name-only | $filter_cmd )"
}

cdp () {
  echo-child-dirs () { find "$1" -mindepth 1 -maxdepth 1 -type d; }

  project-dirs() {
      echo-child-dirs ~/projects;
      echo-child-dirs ~/repos;
      echo-child-dirs ~/work;

      [ -d ~/dotfiles ] && echo ~/dotfiles;
  }

  selected=$(project-dirs | fzf)
  [ -d "$selected" ] && cd "$selected" || echo "'$selected' is not a directory."
}

naut () {
  nautilus "${1:-.}" 2>/dev/null &
}

open () {
  xdg-open "$1" &>/dev/null
}

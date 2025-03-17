_prepend_path ()    { export PATH="$1:$PATH"; }  # extend PATH with $1
prepend_path ()     { [ -d "$1" ] && _prepend_path "$1" || echo "$1 does not exist"; }
mby_prepend_path () { [ -d "$1" ] && _prepend_path "$1"; }
mby_run_file ()     { [ -f "$1" ] && "$1" || echo "$1 does not exist"; }
silent ()           { "$1" &> /dev/null; return $?; } # run commands silently
mby_source_file ()  {
  # shellcheck source=/dev/null
  [ -f "$1" ] && source "$1";
}

mby_source_file "/etc/skel/.bashrc"             # ubuntu bash defaults
mby_source_file "/usr/share/git/git-prompt.sh"  # git PS1
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

# sets prompt (t.y.: https://stackoverflow.com/a/30963255)
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWDIRTYSTATE=1

txt_reset="$(tput sgr0)"
txt_bold="$(tput bold)"
txt_standout="$(tput smso)"
txt_dim="$(tput dim)"
txt_uline_start="$(tput smul)"
txt_uline_end="$(tput rmul)"
txt_red="$(tput setaf 1)"
txt_purple="$(tput setaf 5)"
export __TXT_RESET="$txt_reset"
export __TXT_BOLD="$txt_bold"
export __TXT_STANDOUT="$txt_standout"
export __TXT_DIM="$txt_dim"
export __TXT_ULINE_START="$txt_uline_start"
export __TXT_ULINE_END="$txt_uline_end"
export __TXT_RED="$txt_red"
export __TXT_PURPLE="$txt_purple"

get_ps1()
{
  # shellcheck disable=SC2016
  local exit_code='$(ec=$?; [ "$ec" -eq "0" ] && echo $ec || echo ${__TXT_RED}${__TXT_BOLD}$ec${__TXT_RESET})'

  local current_wd="${__TXT_PURPLE}\w${__TXT_RESET}"

  # git branch
  # shellcheck disable=SC2016
  local git_head='$(__git_ps1 "%s")'
  local commit_title="${__TXT_DIM}\$(git log -n1 --format=\"format:%s\" 2>/dev/null | cut -c1-50)${__TXT_RESET}"

  # good old prompt, $ for user, # for root
  echo -e "$current_wd [$exit_code] [ $git_head | $commit_title ]\n\\$ "
}
ps1=$(get_ps1)
export PS1="$ps1"

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

# Returns & prints error if any command in $@ does not exists
require () {
  for cmd in "$@"; do
    if ! silent "command -v $cmd"; then
	    echo "$cmd does not exist"
	    return 1
  	fi
  done
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


# handy clipboard copy.
#
# Example:
#    cat my_file.txt | ahclip
ahclip () {
	require "xclip" || return 1

	cat - | xclip -selection clipboard
}

# handy clipboard paste.
#
# Example:
#    cat my_file.txt | ahclip
ahpaste () {
	require "xclip" || return 1

	xclip -o -selection clipboard
}

ahclipcmd () {
  require "xclip" || return 1

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

RELATIVE_PATH_VIMRC=./vimrc/my_vimrc
RELATIVE_PATH_I3=./i3/config
RELATIVE_PATH_BASHRC=./bashrc/my_bashrc
RELATIVE_PATH_TMUX_CONF=./tmux/tmux.conf

print_help_and_exit() {
    echo -e "Usage:    $0 [-novim -noi3 -nobash]\n"
    echo -e "This script helps you set up my dotfiles and environment via hardlinks.\
\nContains my .vimrc, .bashrc, and config for i3 and i3status.\nAlso offers to\
install curl, i3 and rofi." | fmt -t
    exit
}

# Creates the folders needed for a file
# $1 the file
create_folder() {
    if ! [ -d $(dirname $1) ]; then
        mkdir -p $(dirname $1)
    fi
}

# Creates a link from source to destination
# $1 source
# $2 destination
create_proxy_file() {
    # creates parentfolders if needed
    create_folder $2
    if [ -f $2 ]; then
        echo "There is already a file at $2. Please remove or back it up!"
    else
        echo source $(realpath $1) > $2
    fi
}

# Creates a link from source to destination
# $1 target
# $2 link name
create_symlink() {
    create_folder $2
    if ln -sv $1 $2 >/dev/null; then
        echo "Symlink created: $2 -> $1"
    else
        read -p "Do you want to replace $2 (y/n)?" answer
        case ${answer:0:1} in
            y|Y )
                rm $2
        create_symlink $1 $2
            ;;
            * )
                echo Suit yourself.
            ;;
        esac
    fi
}

LINKS=(
"create_symlink $(realpath $RELATIVE_PATH_VIMRC)     $HOME/.vimrc"
"create_symlink $(realpath $RELATIVE_PATH_I3)        $HOME/.config/i3/config"
"create_symlink $(realpath $RELATIVE_PATH_BASHRC)    $HOME/.bashrc"
"create_symlink $(realpath $RELATIVE_PATH_TMUX_CONF) $HOME/.tmux.conf"
)

# Remove installs according to options
for i in "$@"; do
    case $i in
        help)
            print_help_and_exit
        ;;
        -novim)
            unset LINKS[0]
            ;;
        -noi3)
            unset LINKS[1]
            ;;
        -nobash)
            unset LINKS[2]
            ;;
    esac
done

# Execute whatever is left in LINKS
for i in "${!LINKS[@]}"; do
    ${LINKS[$i]}
done

read -p "Do you want to install packages using apt?" answer
case ${answer:0:1} in
    y|Y )
        sudo apt install curl i3 rofi volumeicon tmux
    ;;
    * )
        echo Suit yourself.
    ;;
esac

unset create_symlink
unset print_help_and_exit
unset create_proxy_file

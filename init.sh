RELATIVE_PATH_VIMRC=./vimrc/my_vimrc
RELATIVE_PATH_I3=./i3
RELATIVE_PATH_I3STATUS=./i3status
RELATIVE_PATH_BASHRC=./bashrc/my_bashrc

# Creates a link from source to destination
# $1 source
# $2 destination
create_link() {
    if ln -s $1 $2; then
        echo "Link success: $1 to $2"
    else
        echo "Link failiure $1 to $2"
        read -p "Do you want to remove $2 and try linking again?" -n 1 -r
        echo   
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm $2
            create_link $1 $2
        fi
    fi
}

LINKS=(
"create_link $RELATIVE_PATH_VIMRC $HOME/.vimrc"
"create_link $RELATIVE_PATH_I3 $HOME/.config/i3"
"create_link $RELATIVE_PATH_I3STATUS $HOME/.config/i3status"
"create_link $RELATIVE_PATH_BASHRC $HOME/.bashrc"
)

# Remove installs according to options
for i in "$@"; do
    case $i in
        -novim)
            unset LINKS[0]
            ;;
        -noi3)
            unset LINKS[1]
            unset LINKS[2]
            ;;
        -nobash)
            unset LINKS[3]
            ;;
    esac
done

# Execute whatever is left in LINKS
for i in "${!LINKS[@]}"; do
    ${LINKS[$i]}
done


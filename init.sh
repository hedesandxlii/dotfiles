RELATIVE_PATH_VIMRC=./vimrc/my_vimrc
RELATIVE_PATH_I3=./i3
RELATIVE_PATH_I3STATUS=./i3status

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
            ln $1 $2
        fi
    fi
}

create_link $RELATIVE_PATH_VIMRC ~/.vimrc && echo Success!
create_link $RELATIVE_PATH_I3 ~/.config/i3
create_link $RELATIVE_PATH_I3STATUS ~/.config/i3status

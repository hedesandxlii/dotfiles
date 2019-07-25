RELATIVE_PATH_VIMRC=./vimrc/my_vimrc
RELATIVE_PATH_I3=./i3/config
RELATIVE_PATH_I3STATUS=./i3status/config
RELATIVE_PATH_BASHRC=./bashrc/my_bashrc

if [ $1 == "help" ]; then
    echo -e "Usage:    $0 [-novim -noi3 -nobash]\n"
    echo -e "This script helps you set up my dotfiles and environment via hardlinks.\
\nContains my .vimrc, .bashrc, and config for i3 and i3status.\nAlso offers to\
install curl, i3 and rofi." | fmt -t
    exit
fi

# Creates a link from source to destination
# $1 source
# $2 destination
create_link() {
    # creates parentfolders if needed
    if ! [ -d $(dirname $2) ]; then
        mkdir -p $(dirname $2)
    fi
    if ln $1 $2; then
        echo "Link success: $1 to $2"
        echo # newline to not make the output so crammed.
    else
        echo "Link failiure $1 to $2"
        read -p "Do you want to remove $2 and try linking again?" answer
        case ${answer:0:1} in
            y|Y )
                if [ -d $2 ]; then
                    rm -rf $2
                else
                    rm $2
                    create_link $1 $2
                fi
            ;;
            * )
                echo Suit yourself.
                echo # newline to not make the output so crammed.
            ;;
        esac
    fi
}

LINKS=(
"create_link $RELATIVE_PATH_VIMRC       $HOME/.vimrc"
"create_link $RELATIVE_PATH_I3          $HOME/.config/i3/config"
"create_link $RELATIVE_PATH_I3STATUS    $HOME/.config/i3status/config"
"create_link $RELATIVE_PATH_BASHRC      $HOME/.bashrc"
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

read -p "Do you want to install packages using apt? (curl, i3, rofi, ...)" answer
case ${answer:0:1} in
    y|Y )
        sudo apt install curl i3 rofi
    ;;
    * )
        echo Suit yourself.
    ;;
esac

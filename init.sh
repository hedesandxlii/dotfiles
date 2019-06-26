echo Downloading Plug...
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo Trying to hard-link $(realpath ./my_vimrc) to ~/.vimrc
ln ./my_vimrc ~/.vimrc && 
	echo Success! &&
	exit
echo
read -p "Do you want to remove your existing ~/.vimrc and (force) link to this one?" -n 1 -r
echo   
if [[ $REPLY =~ ^[Yy]$ ]]
then
ln -f ./my_vimrc ~/.vimrc && 
	echo Success!
fi 

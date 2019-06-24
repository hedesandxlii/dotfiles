
echo Trying to hard-link $(realpath ./my_vimrc) to ~/.vimrc
ln ./my_vimrc ~/.vimrc && 
	echo Success! &&
	exit
echo

read -p "Do you want to remove your existing ~/.vimrc and (force) link to this one?[y/n]" -n 1 -r
echo   
if [[ $REPLY =~ ^[Yy]$ ]]
then
ln -f ./my_vimrc ~/.vimrc && echo Success!
fi 

read -p "Do you want to set MYVIMRC_HOME env. variable to the current folder? (uses ~/.profile)[y/n]" -n 1 -r
echo   
if [[ $REPLY =~ ^[Yy]$ ]]
then
echo "export MYVIMRC_HOME=$PWD" >> ~/.profile && echo Success!
fi 

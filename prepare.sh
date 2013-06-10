#!/bin/bash

function usage {
    echo "Usage: $0 [email | -d]"
    echo -e "\t-d will use the default email, $default_email"
    exit
}

script=`readlink -f $0`
here=`dirname $script`

default_email='Vytautas.Shaltenis@gmail.com'

user_name=`whoami`
user_record=`getent passwd $user_name`
user_gecos_field=`echo "$user_record" | cut -d ':' -f 5`
user_full_name=`echo "$user_gecos_field" | cut -d ',' -f 1`

if [ $# -eq 0 ]; then
    usage
else
    if [ $1 == "-d" ]; then
        user_email=$default_email
    else
        user_email=$1
    fi

    echo "VCSes will be set to use name $user_full_name and email <$user_email>..."
fi

#================
# SourceCodePro font
#================
if ! [ -f ~/.fonts/SourceCodePro-Regular.ttf] ; then
    wget -O /tmp/SourceCodePro.zip https://github.com/downloads/adobe/Source-Code-Pro/SourceCodePro_FontsOnly-1.010.zip
    unzip -o -x /tmp/SourceCodePro.zip -d /tmp/SourceCodePro
    mkdir -p ~/.fonts
    chmod +w /tmp/SourceCodePro/*/TTF/*.ttf
    cp /tmp/SourceCodePro/*/TTF/*.ttf ~/.fonts
    fc-cache
fi

#================
# Vim
#================
ln -s $here/vimrc ~/.vimrc
mkdir -p ~/.vim/spell

# I should be doing this:
#wget -O ~/.vim/spell/lt.utf-8.spl http://ftp.vim.org/vim/runtime/spell/lt.utf-8.spl
# but for some reason, I get a file that is one byte short from there and Vim
# barks at me with some error. I don't know what's going on, but I have a
# workaround:
cp lt.utf-8.spl ~/.vim/spell/lt.utf-8.spl

# Handle plugins:
# Fugitive: http://www.vim.org/scripts/script.php?script_id=2975
wget -O /tmp/fugitive.zip http://www.vim.org/scripts/download_script.php?src_id=15542
unzip -o -x /tmp/fugitive.zip -d ~/.vim

# Unimpaired: http://www.vim.org/scripts/script.php?script_id=1590
wget -O /tmp/unimpaired.zip http://www.vim.org/scripts/download_script.php?src_id=12570
unzip -o -x /tmp/unimpaired.zip -d ~/.vim

# Bufexplorer: http://www.vim.org/scripts/script.php?script_id=42
wget -O /tmp/bufexplorer.zip http://www.vim.org/scripts/download_script.php?src_id=14208
unzip -o -x /tmp/bufexplorer.zip -d ~/.vim

# Matchit
wget -O /tmp/matchit.zip http://www.vim.org/scripts/download_script.php?src_id=8196
unzip -o -x /tmp/matchit.zip -d ~/.vim

# Supertab: http://www.vim.org/scripts/script.php?script_id=1643
wget -O /tmp/supertab.vmb http://www.vim.org/scripts/download_script.php?src_id=18075
vim -c 'so %' -c 'q' /tmp/supertab.vmb

# CtrlP: http://kien.github.com/ctrlp.vim/
ctrlp="$HOME/.vim/bundle/ctrlp.vim"

if [ -d $crlp ]; then
    rm -rf $ctrlp
fi

git clone https://github.com/kien/ctrlp.vim.git $ctrlp
vim -c 'helptags ~/.vim/bundle/ctrlp.vim/doc' -c 'q'

# Go stuff: git://github.com/jnwhiteh/vim-golang.git
vim_golang=/tmp/vim-golang

if [ -d $vim_golang ]; then
    rm -rf $vim_golang
fi

git clone git://github.com/jnwhiteh/vim-golang.git $vim_golang
rm -rf $vim_golang/.git
cp -r $vim_golang/* $HOME/.vim

# ftplugin for .po files
mkdir -p ~/.vim/ftplugin
ln -s $here/vim/ftplugin/po.vim ~/.vim/ftplugin

# ftplugin and syntax for hg commits
ln -s $here/vim/ftdetect/hgcommit.vim ~/.vim/ftdetect/hgcommit.vim
ln -s $here/vim/ftplugin/hgcommit.vim ~/.vim/ftplugin/hgcommit.vim
ln -s $here/vim/syntax/hgcommit.vim ~/.vim/syntax/hgcommit.vim

#================
# Git
#================
if [ -f ~/.gitconfig ] ; then
    mv ~/.gitconfig ~/.gitconfig~
fi

cat gitconfig \
    | sed s/USERNAME/"$user_full_name"/ \
    | sed s/USEREMAIL/"$user_email"/ \
    > ~/.gitconfig

#================
# Hg
#================
cat hgrc \
    | sed s/USERSPEC/"$user_full_name <$user_email>"/ \
    > ~/.hgrc

#================
# bash
#================
if [ -f ~/.bashrc ] ; then
    mv ~/.bashrc ~/.bashrc~
fi

ln -s $here/bashrc ~/.bashrc

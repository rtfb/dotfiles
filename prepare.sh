#!/bin/sh

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
cp vimrc ~/.vimrc
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

# Supertab: http://www.vim.org/scripts/script.php?script_id=1643
wget -O /tmp/supertab.vmb http://www.vim.org/scripts/download_script.php?src_id=18075
vim -c 'so %' -c 'q' supertab.vmb

# CtrlP: http://kien.github.com/ctrlp.vim/
git clone https://github.com/kien/ctrlp.vim.git ~/.vim/bundle/ctrlp.vim
vim -c 'helptags ~/.vim/bundle/ctrlp.vim/doc' -c 'q'

#================
# Git
#================
cp gitconfig ~/.gitconfig

#================
# bash
#================
if [ -f ~/.bashrc ] ; then
    mv ~/.bashrc ~/.bashrc~
fi

cp bashrc ~/.bashrc

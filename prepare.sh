#!/bin/sh

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

#================
# Git
#================
cp gitconfig ~/.gitconfig

#================
# bash
#================
cp bashrc ~/.bashrc

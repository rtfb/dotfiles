#!/bin/bash

function usage {
    echo "Usage: $0 [-f] [-d]"
    echo -e "\t-d will copy the default VCS settings (like .gitconfig.local)"
    echo -e "\t-f will enable full install, including downloads"
    echo -e "\t-h displays this help"
    exit
}

function backup {
    if [ -f $1 ]; then
        mv $1 $1~
    fi
}

platform="unknown"
unamestr=$(uname)

case "$unamestr" in
    "Linux")
        platform="linux"
        ;;
    "Darwin")
        platform="osx"
        ;;
    *)
        echo "Unknown platform uname '$unamestr', exiting..."
        exit
        ;;
esac

realpath() {
  OURPWD=$PWD
  cd "$(dirname "$1")"
  LINK=$(readlink "$(basename "$1")")
  while [ "$LINK" ]; do
    cd "$(dirname "$LINK")"
    LINK=$(readlink "$(basename "$1")")
  done
  REALPATH="$PWD/$(basename "$1")"
  cd "$OURPWD"
  echo "$REALPATH"
}

if [[ $platform == 'linux' ]]; then
    script=`readlink -f $0`
    here=`dirname $script`
elif [[ $platform == 'osx' ]]; then
    here=$(dirname $(realpath "$0"))
fi

default_email='vytas@rtfb.lt'

user_name=`whoami`
user_record=`getent passwd $user_name`
user_gecos_field=`echo "$user_record" | cut -d ':' -f 5`
user_full_name=`echo "$user_gecos_field" | cut -d ',' -f 1`
full_install=0

if [ $# -gt 0 ]; then
    if [ $1 == "-h" ]; then
        usage
        exit
    fi
    if [ $1 == "-f" ]; then
        full_install=1
        shift
    fi
    if [ $1 == "-d" ]; then
        backup ~/.hgrc.local
        backup ~/.gitconfig.local
        echo -e "[user]\n" \
                "\tname = $user_full_name\n" \
                "\temail = $default_email\n" \
            > ~/.gitconfig.local
        echo -e "[ui]\nusername = $user_full_name <$default_email>\n" \
            > ~/.hgrc.local
        shift
    fi
fi

#================
# SourceCodePro font
#================
function get_priv_fonts_dir {
    case $platform in
        'linux')
            return $HOME/.fonts
            ;;
        'osx')
            return $HOME/Library/Fonts
            ;;
        *)
            echo 'Font installation not implemented on platform $(platform)!'
            exit
            ;;
    esac
}

function install_font {
    private_fonts=get_priv_fonts_dir()
    if ! [ -f $private_fonts/SourceCodePro-Regular.ttf] ; then
        wget -O /tmp/SourceCodePro.zip https://github.com/downloads/adobe/Source-Code-Pro/SourceCodePro_FontsOnly-1.010.zip
        unzip -o -x /tmp/SourceCodePro.zip -d /tmp/SourceCodePro
        mkdir -p $private_fonts
        chmod +w /tmp/SourceCodePro/*/TTF/*.ttf
        cp /tmp/SourceCodePro/*/TTF/*.ttf $private_fonts
        if [[ $platform == 'linux' ]]; then
            fc-cache
        fi
    fi
}

function install_vim_plugins {
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
}

function symlink {
    if [ -h $2 ]; then
        return
    fi
    ln -s $1 $2
}

if [ $full_install -eq 1 ]; then
    install_font
    install_vim_plugins
fi

if ! [ -d $HOME/bin ]; then
    mkdir $HOME/bin
fi

#================
# Vim
#================
symlink $here/vimrc ~/.vimrc
mkdir -p ~/.vim/ftdetect
mkdir -p ~/.vim/ftplugin
mkdir -p ~/.vim/syntax
mkdir -p ~/.vim/spell

# I should be doing this:
#wget -O ~/.vim/spell/lt.utf-8.spl http://ftp.vim.org/vim/runtime/spell/lt.utf-8.spl
# but for some reason, I get a file that is one byte short from there and Vim
# barks at me with some error. I don't know what's going on, but I have a
# workaround:
cp lt.utf-8.spl ~/.vim/spell/lt.utf-8.spl

# ftplugin for .po files
symlink $here/vim/ftplugin/po.vim ~/.vim/ftplugin/po.vim

# ftplugin and syntax for hg commits
symlink $here/vim/ftdetect/hgcommit.vim ~/.vim/ftdetect/hgcommit.vim
symlink $here/vim/ftplugin/hgcommit.vim ~/.vim/ftplugin/hgcommit.vim
symlink $here/vim/syntax/hgcommit.vim ~/.vim/syntax/hgcommit.vim

#================
# Git
#================
backup ~/.gitconfig
symlink $here/gitconfig ~/.gitconfig

#================
# Hg
#================
backup ~/.hgrc
symlink $here/hgrc ~/.hgrc

#================
# bash
#================
if [[ $platform == 'linux' ]]; then
    backup ~/.bashrc
    symlink $here/bashrc ~/.bashrc
elif [[ $platform == 'osx' ]]; then
    backup ~/.bash_profile
    symlink $here/bashrc ~/.bash_profile
fi

#================
# i3
#================
backup ~/.i3/config
symlink $here/i3-config ~/.i3/config
symlink $here/autostart ~/.i3/autostart
backup ~/.i3status.conf
symlink $here/i3status.conf ~/.i3status.conf
cp $here/lang.sh ~/bin/

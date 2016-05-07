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

if [[ $# -gt 0 ]]; then
    if [[ $1 == "-h" ]]; then
        usage
        exit
    fi
    if [[ $1 == "-f" ]]; then
        full_install=1
        shift
    fi
    if [[ $1 == "-d" ]]; then
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
            echo $HOME/.fonts
            ;;
        'osx')
            echo $HOME/Library/Fonts
            ;;
        *)
            echo 'Font installation not implemented on platform $(platform)!'
            exit
            ;;
    esac
}

function install_font {
    private_fonts=$(get_priv_fonts_dir)
    if ! [[ -f $private_fonts/SourceCodePro-Regular.ttf ]] ; then
        curl -o /tmp/SourceCodePro.zip https://cloud.github.com/downloads/adobe-fonts/source-code-pro/SourceCodePro_FontsOnly-1.010.zip
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
    # Unimpaired: http://www.vim.org/scripts/script.php?script_id=1590
    curl -o /tmp/unimpaired.zip http://www.vim.org/scripts/download_script.php?src_id=12570
    unzip -o -x /tmp/unimpaired.zip -d ~/.vim

    # Bufexplorer: http://www.vim.org/scripts/script.php?script_id=42
    curl -o /tmp/bufexplorer.zip http://www.vim.org/scripts/download_script.php?src_id=14208
    unzip -o -x /tmp/bufexplorer.zip -d ~/.vim

    # Matchit
    curl -o /tmp/matchit.zip http://www.vim.org/scripts/download_script.php?src_id=8196
    unzip -o -x /tmp/matchit.zip -d ~/.vim

    # Supertab: http://www.vim.org/scripts/script.php?script_id=1643
    curl -o /tmp/supertab.vmb http://www.vim.org/scripts/download_script.php?src_id=18075
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

    git clone git://github.com/rtfb/vim-golang.git $vim_golang
    rm -rf $vim_golang/.git
    cp -r $vim_golang/* $HOME/.vim
}

function symlink {
    # If it is a regular file, move it out of the way:
    if [ -f $2 ]; then
        mv $2 $2~
    fi
    # If it exists (or is a valid symlink), do nothing:
    if [ -e $2 ]; then
        return
    fi
    # If it is a symlink, unlink it:
    if [ -L $2 ]; then
        rm $2
    fi
    # Now establish a new link:
    ln -s $1 $2
}

if [ $full_install -eq 1 ]; then
    install_font
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
#curl -o ~/.vim/spell/lt.utf-8.spl http://ftp.vim.org/vim/runtime/spell/lt.utf-8.spl
# but for some reason, I get a file that is one byte short from there and Vim
# barks at me with some error. I don't know what's going on, but I have a
# workaround:
#cp lt.utf-8.spl ~/.vim/spell/lt.utf-8.spl

# The above is no longer true under Ubuntu 14.04, so revert to downloading. But
# I leave the hack around just in case I'll need it on some older version.
# Would be best to figure out how can this be detected and do the right thing
# in the right circumstances
if [[ $full_install -eq 1 ]]; then
    curl -o ~/.vim/spell/lt.utf-8.spl http://ftp.vim.org/vim/runtime/spell/lt.utf-8.spl
fi

if [[ $full_install -eq 1 ]]; then
    if ! [[ -f ~/.vim/bundle/Vundle.vim ]]; then
        git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    fi
    vim +PluginInstall +qall
fi

#if [ $full_install -eq 1 ]; then
#    install_vim_plugins
#fi

# ftplugin for .po files
symlink $here/vim/ftplugin/po.vim ~/.vim/ftplugin/po.vim

# ftplugin and syntax for hg commits
symlink $here/vim/ftplugin/hgcommit.vim ~/.vim/ftplugin/hgcommit.vim
symlink $here/vim/syntax/hgcommit.vim ~/.vim/syntax/hgcommit.vim

#================
# Git
#================
symlink $here/gitconfig ~/.gitconfig

#================
# Hg
#================
symlink $here/hgrc ~/.hgrc

#================
# bash
#================
if [[ $platform == 'linux' ]]; then
    symlink $here/bashrc ~/.bashrc
elif [[ $platform == 'osx' ]]; then
    symlink $here/bashrc ~/.bash_profile
fi

symlink $here/bash_aliases ~/.bash_aliases
symlink $here/profile ~/.profile

#================
# i3
#================
mkdir -p ~/.i3
symlink $here/i3-config ~/.i3/config
symlink $here/autostart ~/.i3/autostart
symlink $here/i3status.conf ~/.i3status.conf
cp $here/lang.sh ~/bin/

#================
# gdb
#================
symlink $here/gdbinit ~/.gdbinit

#================
# misc
#================
symlink $here/ekto.py ~/bin/ekto.py

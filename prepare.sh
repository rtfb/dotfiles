#!/bin/bash

function usage {
    echo "Usage: $0 [-f] [-d] [-u]"
    echo -e "\t-d will copy the default VCS settings (like .gitconfig.local)"
    echo -e "\t-f will enable full install, including downloads"
    echo -e "\t-u will force setup even on non-whitelisted hostname"
    echo -e "\t-h displays this help"
    exit
}

function backup {
    if [ -f $1 ]; then
        mv $1 $1~
    fi
}

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
default_vcs_settings=0
full_install=0
force_unknown_hosts=0

while getopts "h?dfu" opt; do
    case "$opt" in
        h|\?)
            usage
            exit 0
            ;;
        d)  default_vcs_settings=1
            ;;
        f)  full_install=1
            ;;
        u)  force_unknown_hosts=1
            ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

# echo "default_vcs_settings=$default_vcs_settings, full_install=$full_install, force_unknown_hosts=$force_unknown_hosts, Leftovers: $@"
# exit

platform="unknown"
unamestr=$(uname)
hostname=$(hostname)
here="."

case "$unamestr" in
    "Linux")
        platform="linux"
        script=`readlink -f $0`
        here=`dirname $script`
        ;;
    "Darwin")
        platform="osx"
        here=$(dirname $(realpath "$0"))
        ;;
    *)
        echo "Unknown platform uname '$unamestr', exiting..."
        exit
        ;;
esac

if [ -f $here/i3/$hostname-status.conf ]; then
    echo "This is a whitelisted host, proceeding..."
else
    echo "Unknown hostname, some things might not work."
    if [ ! $force_unknown_hosts -eq 1 ]; then
        echo "Use '-u' to force proceed."
        exit
    else
        echo "Proceeding due to '-u'."
    fi
fi

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

default_email='vytas@rtfb.lt'

user_name=`whoami`
user_record=`getent passwd $user_name`
user_gecos_field=`echo "$user_record" | cut -d ':' -f 5`
user_full_name=`echo "$user_gecos_field" | cut -d ',' -f 1`

if [ $default_vcs_settings -eq 1 ]; then
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
        curl -sS -L -o /tmp/SourceCodePro.zip https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.zip
        unzip -o -x /tmp/SourceCodePro.zip -d /tmp/SourceCodePro
        mkdir -p $private_fonts
        chmod +w /tmp/SourceCodePro/*/TTF/*.ttf
        cp /tmp/SourceCodePro/*/TTF/*.ttf $private_fonts
        if [[ $platform == 'linux' ]]; then
            fc-cache
        fi
    fi
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
    curl -sS -o ~/.vim/spell/lt.utf-8.spl https://ftp.nluug.nl/pub/vim/runtime/spell/lt.utf-8.spl
fi

if [[ $full_install -eq 1 ]]; then
    if ! [[ -f ~/.vim/bundle/Vundle.vim ]]; then
        git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    fi
    vim +PluginInstall +qall
fi

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
symlink $here/bash/rc ~/.bashrc

if [[ $platform == 'osx' ]]; then
    symlink $here/bash/bash_profile ~/.bash_profile
fi

if [[ $platform == 'osx' ]]; then
    if ! [ -f ~/bin/git-completion.bash ]; then
        curl -sS -o ~/bin/git-completion.bash \
            https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
        chmod +x ~/bin/git-completion.bash
    fi

    symlink $here/bash/bash_profile ~/.bash_profile
fi

symlink $here/bash/aliases ~/.bash_aliases
symlink $here/bash/profile ~/.profile

#================
# i3
#================
mkdir -p ~/.i3
symlink $here/i3-config ~/.i3/config
symlink $here/autostart ~/.i3/autostart

if [ -f $here/i3/$hostname-status.conf ]; then
    symlink $here/i3/$hostname-status.conf ~/.i3status.conf
else
    echo "Non-whitelisted hostname. Defaulting to i3/status-home.conf"
    symlink $here/i3/status-home.conf ~/.i3status.conf
fi

cp $here/bin/lang.sh ~/bin/
cp $here/bin/lock-dpms.sh ~/bin/

#================
# gdb
#================
symlink $here/gdbinit ~/.gdbinit

#================
# misc
#================
symlink $here/bin/ekto.py ~/bin/ekto.py

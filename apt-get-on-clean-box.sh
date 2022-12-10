#!/bin/bash

apt-get update

# regular software, esp. one that I have bindings for:
PKGS=(
    abcde
    ascii
    curl
    flac
    fontconfig
    jq
    make
    ncal
    numlockx
    p7zip-full
    parcellite
    scrot
    silversearcher-ag
    tree
    units
    unzip # needed for prepare.sh
    wget
    xclip

    # GUI things:
    gimp
    vim-gtk3
)

apt-get --yes install ${PKGS[@]}

if ! command -v jump &> /dev/null
then
    echo "jump not found, installing..."
    wget -O /tmp/jump_0.30.1_amd64.deb https://github.com/gsamokovarov/jump/releases/download/v0.30.1/jump_0.30.1_amd64.deb
    dpkg -i /tmp/jump_0.30.1_amd64.deb
fi

if ! command -v glow &> /dev/null
then
    echo "glow not found, installing..."
    wget -O /tmp/glow_1.4.1_linux_amd64.deb https://github.com/charmbracelet/glow/releases/download/v1.4.1/glow_1.4.1_linux_amd64.deb
    dpkg -i /tmp/glow_1.4.1_linux_amd64.deb
fi

if ! [ -d ~/.dropbox-dist ] && [ "$(hostname)" == "dungeon" ]; then
    echo "dropbox not found, installing..."
    cd ~
    su rtfb -c "wget -O - \"https://www.dropbox.com/download?plat=lnx.x86_64\" | tar xzf -"
fi

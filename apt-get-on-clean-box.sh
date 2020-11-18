#!/bin/bash

apt-get update

# regular software, esp. one that I have bindings for:
PKGS=(
    abcde
    curl
    flac
    fontconfig
    libgnome2-bin # gnome-open
    make
    numlockx
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

# install jump:
wget -O /tmp/jump_0.30.1_amd64.deb https://github.com/gsamokovarov/jump/releases/download/v0.30.1/jump_0.30.1_amd64.deb
dpkg -i /tmp/jump_0.30.1_amd64.deb
cd ~
su rtfb -c "wget -O - \"https://www.dropbox.com/download?plat=lnx.x86_64\" | tar xzf -"

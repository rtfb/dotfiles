#!/bin/bash

apt-get update

# regular software, esp. one that I have bindings for:
PKGS=(
    curl
    wget
    scrot
    tree
    abcde
    flac
    xclip
    parcellite
    numlockx
    fontconfig
    silversearcher-ag
    units
    libgnome2-bin # gnome-open
    unzip # needed for prepare.sh

    # GUI things:
    vim-gtk3
    gimp
)

apt-get --yes install ${PKGS[@]}

# install jump:
wget -O /tmp/jump_0.30.1_amd64.deb https://github.com/gsamokovarov/jump/releases/download/v0.30.1/jump_0.30.1_amd64.deb
dpkg -i /tmp/jump_0.30.1_amd64.deb
cd ~
su rtfb -c "wget -O - \"https://www.dropbox.com/download?plat=lnx.x86_64\" | tar xzf -"

#!/bin/sh

apt-get update

# regular software, esp. one that I have bindings for:
apt-get --yes install \
    curl wget scrot tree abcde flac xclip parcellite numlockx fontconfig \
    silversearcher-ag units \
    libgnome2-bin # gnome-open

# GUI things:
apt-get --yes install vim-gtk gimp

# needed for prepare.sh:
apt-get --yes install unzip

# install jump:
wget -O /tmp/jump_0.30.1_amd64.deb https://github.com/gsamokovarov/jump/releases/download/v0.30.1/jump_0.30.1_amd64.deb
dpkg -i /tmp/jump_0.30.1_amd64.deb
cd ~
su rtfb -c "wget -O - \"https://www.dropbox.com/download?plat=lnx.x86_64\" | tar xzf -"

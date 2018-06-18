#!/bin/sh

apt-get update

# regular software, esp. one that I have bindings for:
apt-get --yes install \
    curl wget scrot tree abcde flac xclip parcellite numlockx fontconfig \
    units

# GUI things:
apt-get --yes install vim-gtk gimp

# needed for prepare.sh:
apt-get --yes install unzip

# install jump:
wget -O /tmp/jump_0.8.0_amd64.deb https://github.com/gsamokovarov/jump/releases/download/v0.8.0/jump_0.8.0_amd64.deb
dpkg -i /tmp/jump_0.8.0_amd64.deb
cd ~
su rtfb -c "wget -O - \"https://www.dropbox.com/download?plat=lnx.x86_64\" | tar xzf -"

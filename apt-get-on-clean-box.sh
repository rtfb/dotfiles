#!/bin/sh

# regular software, esp. one that I have bindings for:
apt-get install vim-gtk curl wget scrot gimp tree abcde flac xclip parcellite \
        numlockx -y
# install jump:
curl -o /tmp/jump_0.8.0_amd64.deb https://github.com/gsamokovarov/jump/releases/download/v0.8.0/jump_0.8.0_amd64.deb
dpkg -i jump_0.8.0_amd64.deb
cd ~
su rtfb -c "wget -O - \"https://www.dropbox.com/download?plat=lnx.x86_64\" | tar xzf -"

#!/bin/sh

# regular software, esp. one that I have bindings for:
apt-get install vim-gtk curl wget scrot gimp tree abcde flac xclip parcellite \
        numlockx -y
cd ~
su rtfb -c "wget -O - \"https://www.dropbox.com/download?plat=lnx.x86_64\" | tar xzf -"

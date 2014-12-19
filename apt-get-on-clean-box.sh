#!/bin/sh

# regular software, esp. one that I have bindings for:
apt-get install vim-gtk curl wget scrot gimp tree abcde flac -y

# build deps for i3lock:
apt-get build-dep i3lock -y
apt-get install libxcb-xkb-dev libxkbcommon-x11-dev -y

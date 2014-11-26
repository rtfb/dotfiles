#!/bin/sh

# regular software, esp. one that I have bindings for:
apt-get install curl wget scrot gimp tree abcde flac

# build deps for i3lock:
apt-get build-dep i3lock
apt-get install libxcb-xkb-dev libxkbcommon-x11-dev

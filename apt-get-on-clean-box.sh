#!/bin/bash

apt-get update

# regular software, esp. one that I have bindings for:
PKGS=(
    ascii
    curl
    docker.io
    docker-compose
    flac
    fontconfig
    jq
    make
    libfuse2 # needed to run AppImage binaries
    libglib2.0-bin  # for gsettings in prepare.sh
    ncal
    numlockx
    p7zip-full
    parcellite
    python3
    python-is-python3
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

# Let my user use docker without sudo:
usermod -aG docker $USER

# Let my user access serial without sudo:
usermod -aG dialout $USER

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

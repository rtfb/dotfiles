#!/bin/bash

echo "Hello, tests"

sudo ln -fs /usr/share/zoneinfo/Europe/Vilnius /etc/localtime
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata

sudo ./apt-get-on-clean-box.sh

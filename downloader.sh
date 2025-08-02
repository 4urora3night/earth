#!/bin/bash
mkdir -p earth
mkdir -p earth/lib
mkdir -p earth/lib/distro-lib
cd earth

curl -O https://raw.githubusercontent.com/4urora3night/earth/refs/heads/main/earth.sh
chmod +x earth.sh

cd lib

curl -O https://raw.githubusercontent.com/4urora3night/earth/refs/heads/main/lib/toml-config-installer.sh
curl -O https://raw.githubusercontent.com/4urora3night/earth/refs/heads/main/lib/aur-helper.sh
curl -O https://raw.githubusercontent.com/4urora3night/earth/refs/heads/main/lib/settings.sh
curl -O https://raw.githubusercontent.com/4urora3night/earth/refs/heads/main/lib/terminal-ui.sh
curl -O https://raw.githubusercontent.com/4urora3night/earth/refs/heads/main/lib/tty-ui.sh
curl -O https://raw.githubusercontent.com/4urora3night/earth/refs/heads/main/lib/utils.sh

cd distro-lib

curl -O https://raw.githubusercontent.com/4urora3night/earth/refs/heads/main/lib/distro-lib/arch-linux-utils.sh

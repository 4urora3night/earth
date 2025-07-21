#!/bin/bash
# by 4urora3night

# -- Precautions -- #

set -o errexit
set -o nounset
set -o pipefail

cleanup() {
  [[ -d "${script_dir}/cache" ]] && rm -rf "${script_dir}/cache"
}
trap cleanup EXIT

# -- Variables -- #

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dependencies_apps=("fzf" "gum" "yq" "fd" "bat" "flatpak")
dependencies_files=("app-installer.sh" "aur-helper.sh" "settings.sh" "utils.sh" "distro-lib/arch-linux-utils.sh")
text_box_size=$(($(tput cols) - 4))
config_toml=Null

# -- Dependency Checks -- #

for file in "${dependencies_files[@]}"; do
  [ ! -e "${script_dir}/lib/${file}" ] && echo "FILE NOT FOUND: ${file}" && exit 1
  source "${script_dir}/lib/${file}"
done

if [[ "$(tty)" == "/dev/tty"* ]]; then
  source "${script_dir}/lib/tty-ui.sh"
else
  source "${script_dir}/lib/terminal-ui.sh"
fi

if check_command_available "pacman"; then
  source "${script_dir}/lib/distro-lib/arch-linux-utils.sh"
fi

dependency_app_check

if check_command_available "pacman"; then
  aur_helper_checks
fi
# -- Main Loop -- #

while true; do
  clear
  title
  option_home
done

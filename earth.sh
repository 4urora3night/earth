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
dependencies_apps=("fzf" "gum" "yq" "fd" "bat" "flatpak" "git" "wget")
dependencies_files=("toml-config-installer" "aur-helper" "utils" "dependency-check" "terminal-menu-tui" "tty-menu-tui" "tui")
text_box_size=$(($(tput cols) - 4))
config_toml=Null

# -- Dependency Checks -- #

for file in "${dependencies_files[@]}"; do
  [ ! -e "${script_dir}/lib/${file}.sh" ] && echo "FILE NOT FOUND: ${script_dir}/lib/${file}.sh" && exit 1
  source "${script_dir}/lib/${file}.sh"
done

if [[ "$(tty)" == "/dev/tty"* ]]; then
  source "${script_dir}/lib/tty-menu-tui.sh"
else
  source "${script_dir}/lib/terminal-menu-tui.sh"
fi

if command_available "pacman"; then
  [ ! -e "${script_dir}/lib/${file}.sh" ] && echo "FILE NOT FOUND: ${script_dir}/lib/${file}.sh" && exit 1
  source "${script_dir}/lib/distro-lib/arch-linux-utils.sh"
else
  echo "[ERROR]Missing distro specific functions in earth/lib/distro-lib/"
  exit 1
fi

dependency_app_check

if command_available "pacman"; then
  aur_helper_checks
fi

[ -e "${script_dir}/logs.txt" ] && rm "${script_dir}/logs.txt"
touch "${script_dir}/logs.txt"
log_date
# -- Main Loop -- #

while true; do
  clear
  title
  option_home
done

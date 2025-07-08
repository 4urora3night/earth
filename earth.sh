#!/bin/bash
# by 4urora3night
set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# -Import functions- #

source "${script_dir}/lib/settings.sh"
source "${script_dir}/lib/app-installer.sh"
source "${script_dir}/lib/utils.sh"
source "${script_dir}/lib/aur-helper.sh"

if [[ "$(tty)" == "/dev/tty"* ]]; then
  source "${script_dir}/lib/tty-ui.sh"
else
  source "${script_dir}/lib/terminal-ui.sh"
fi

# --  Functions  -- #
cleanup() {
  [[ -d "${script_dir}/cache" ]] && rm -rf "${script_dir}/cache"
}

install_dependencies() {
  local dependencies=("fzf" "gum" "yq" "fd" "bat" "flatpak") 
  local dependencies_install=()
  local update=1
  for i in "${dependencies[@]}"; do
    if check_app_installed "${i}"; then
      dependencies_install+=("${i}")
      update=0
    fi
  done
  if [[ "${update}" -eq 0 ]]; then
    echo -e "Installing dependencies"
    for i in "${dependencies_install[@]}"; do
      echo " - ${i}"
    done
    sleep 1
    sudo pacman -Sy
    pacman_install "${dependencies_install[@]}"
  fi
}

# --  Variable  -- #
text_box_size=$(($(tput cols) - 4))
config_toml=Null
trap cleanup EXIT

install_dependencies
aur_helper_checks
while true; do
  clear
  title
  option_home 
done

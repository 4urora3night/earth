#!/bin/bash
# by 4urora3night

# -- General Utilites -- #

tput_clean_text_area() {
  tput cup 13 0
  tput ed
}

check_app_installed() {
  if ! pacman -Qs "${1}"; then
    return 0
  else
    return 1
  fi
}

setup_cache() {
  text_log "Creating cache folder for temporary files..."
  mkdir -p "${script_dir}/cache"
}

# --  Output text format  -- #
title() {
  gum style \
    --foreground 4 --border-foreground 2 --border double \
    --align center --width "${text_box_size}" --margin "0 1" --padding "2 0" \
    "███████╗ █████╗ ██████╗ ████████╗██╗  ██╗
██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██║  ██║
█████╗  ███████║██████╔╝   ██║   ███████║
██╔══╝  ██╔══██║██╔══██╗   ██║   ██╔══██║
███████╗██║  ██║██║  ██║   ██║   ██║  ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
                                         "
}
text_box() {
  local text
  text="$(echo -e "$1")"
  gum style \
    --foreground 7 --border-foreground 4 --border normal \
    --align left --width "${text_box_size}" --margin "0 1" --padding "1 1" \
    "${text}"
}
text_box_confirm() {
  local text
  text="$(echo -e "$1")"
  gum style \
    --foreground 7 --border-foreground 1 --border normal \
    --align left --width "${text_box_size}" --margin "0 1" --padding "1 1" \
    "${text}"
}
text_confirm() {
  gum confirm \
    " $1" --prompt.foreground 7 --selected.background 2
}
text_error() {
  local text
  text="$(echo -e "$1")"
  gum style \
    --foreground 1 --border-foreground 1 --border normal \
    --align center --width ${text_box_size} --margin "0 1" \
    "${text}"
}
text_log() {
  local text
  text="$(echo -e "$1")"
  gum style \
    --foreground 3 \
    --align center --width ${text_box_size} --margin "0 1" \
    "${text}"
}

fzf_stylised() {
  fzf --style full \
    --border rounded \
    --margin 0,1 \
    --height 20% \
    --border-label ' Package Finder ' --input-label ' Input ' --header-label ' File Type '
}
fzf_stylised_preview() {
  fzf --style full \
    --border rounded \
    --margin 0,1 \
    --height 20% \
    --border-label ' Toml Finder ' --input-label ' Input ' --header-label ' File Type ' \
    --preview 'bat --style=numbers --color=always {}'
}

#-------------------------------------------
check_app_installed() {
  if ! command -v "$1" &>/dev/null; then
    return 0
  else
    return 1
  fi
}

find_missing_apps() {
  for app in "${dependencies_apps[@]}"; do
    if check_app_installed "${app}"; then
      missing_apps+=("${app}")
    fi
  done
}

dependencies_app_checks() {
  local missing_apps=()
  find_missing_apps 

  if [[ ! "${#missing_apps[@]}" -eq 0 ]]; then
    echo "MISSING APPS -> preformining install of apps:"
    for app in "${missing_apps[@]}"; do
      echo "- ${app}"
    done
    sleep 2

    for app in "${missing_apps[@]}"; do
      pacman_install "${app}"
    done

    local missing_apps=()
    find_missing_apps 

    if [[ ! "${#missing_apps[@]}" -eq 0 ]]; then
      echo "MISSING APPS -> manually preform install of apps or re-run script:"
      for app in "${missing_apps[@]}"; do
        echo "- ${app}"
      done
      exit 1
    fi
  
  fi
}

# -- Application installers -- #

pacman_install() {
  ${AUR_HELPER} -S "${@}" --noconfirm
}
flatpak_install() {
  flatpak install flathub -y "${1}"
}

update_sys() {
  tput_clean_text_area
  text_box_confirm "Begin full Update?"   
  if text_confirm "Confirm"; then
    text_box "Updating system..."
    text_log "Pacman updating..."
    "${AUR_HELPER}" -Syyu --noconfirm
    text_log "flatpak updating..."
    flatpak update -y
  fi
}

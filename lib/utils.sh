#!/bin/bash
# by 4urora3night

# -- Application installers -- #
flatpak_install() {
  flatpak install flathub -y "${1}"
}

update() {
  tput_clean_text_area
  text_box_confirm "Begin full Update?"
  if text_confirm "Confirm"; then
    tput_clean_text_area
    text_box "Updating system..."
    text_log "Pacman updating..."
    update_system
    text_log "flatpak updating..."
    flatpak update -y
    sleep 3
  fi
}

# -- Application utilities -- #
check_command_available() {
  if command -v "${1}" &>/dev/null; then
    return 0
  else
    return 1
  fi
}

find_missing_depedency_apps() {
  for app in "${dependencies_apps[@]}"; do
    if ! app_installed_check "${app}"; then
      missing_apps+=("${app}")
    fi
  done
}

dependency_app_check() {
  local missing_apps=()
  find_missing_depedency_apps

  if [[ ! "${#missing_apps[@]}" -eq 0 ]]; then
    echo "MISSING APPS -> preformining install of apps:"
    for app in "${missing_apps[@]}"; do
      echo "- ${app}"
    done
    sleep 3

    for app in "${missing_apps[@]}"; do
      default_package_installer "${app}"
    done

    local missing_apps=()
    find_missing_depedency_apps

    if [[ ! "${#missing_apps[@]}" -eq 0 ]]; then
      echo "MISSING APPS -> manually preform install of apps or re-run script:"
      for app in "${missing_apps[@]}"; do
        echo "- ${app}"
      done
      exit 1
    fi

  fi
}

# -- file utilities  -- #
setup_cache() {
  text_log "Creating cache folder for temporary files..."
  mkdir -p "${script_dir}/cache"
}

# -- Text utilities  -- #
tput_clean_text_area() {
  tput cup 13 0
  tput ed
}

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

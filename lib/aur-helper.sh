#!/bin/bash
# by 4urora3night

# -- UI -- #
setup_cache() {
  text_log "Creating cache folder for temporary files..."
  mkdir -p "${script_dir}/cache"
}

aur_helper_checks() {
  clear
  local Aur_Helpers=("yay" "paru")
  local installed_counter=1

  for i in "${Aur_Helpers[@]}"; do
    if ! check_app_installed "${i}"; then
      installed_counter=0
      AUR_HELPER="${i}"
      break
    fi
  done

  if [[ ! "${installed_counter}" -eq 0 ]]; then
    title
    while true; do
      tput_clean_text_area
      text_box "To use this script, an AUR helper must be set."
      if text_confirm "Do you have a AUR helper installed?"; then
        while true; do
          AUR_HELPER="$(compgen -c | sort -u | fzf_app_search)"
          tput_clean_text_area
          text_box_confirm "! ${AUR_HELPER} is set as your AUR helper. !"
          option_submenus 'Ok' 'Redo'
          case $choice in
          'Ok') return 0 ;;
          'Redo') break ;;
          esac
        done
      else
        install_helper
      fi
    done
  fi
}

install_helper() {
  tput_clean_text_area
  text_box "This can offer to install a helper for you:\n - yay: prebuilt or to compile\n - paru : to compile\nor you can install one."
  option_submenus 'yay' 'paru'
  case $choice in
  'yay') install_yay ;;
  'paru') install_paru ;;
  esac
}

# -- Automated AUR helper installers -- #

install_yay() {
  if check_app_installed "git"; then
    sudo pacman -S --needed --noconfirm git base-devel
  fi

  setup_cache
  cd "${script_dir}/cache" || return 1

  if text_confirm "Do you want to complie yay?"; then
    text_log "Cloning yay from AUR..."
    git clone https://aur.archlinux.org/yay.git
    text_log "Building and installing yay..."
    cd yay || return 1
    makepkg -si --noconfirm
  else
    text_log "Cloning yay from AUR..."
    git clone https://aur.archlinux.org/yay-bin.git
    text_log "Installing yay..."
    cd yay-bin || return 1
  fi

  makepkg -si --noconfirm
  text_log "Cleaning up..."
  cd "${script_dir}" && rm -rf "${script_dir}/cache"
}

install_paru() {
  if check_app_installed "git"; then
    sudo pacman -S --needed --noconfirm git base-devel
  fi

  setup_cache
  cd "${script_dir}/cache" || return 1

  text_log "Cloning paru from AUR..."
  git clone https://aur.archlinux.org/paru.git
  cd paru || return
  text_log "Building and installing paru..."
  makepkg -si --noconfirm
  text_log "Cleaning up..."
  cd "${script_dir}" && rm -rf "${script_dir}/cache"
}

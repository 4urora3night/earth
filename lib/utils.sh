#!/bin/bash
# by 4urora3night
log_date() {
  local date=$(date +"%r %n %D")
  echo "${date}" >>"${script_dir}/logs.txt"
}

log() {
  echo "[EXEC] ${@}" >>"${script_dir}/logs.txt"
  "$@" 2>&1 | tee -a "${script_dir}/logs.txt"
}

# -- Application -- #
flatpak_install() {
  flatpak install flathub -y "${1}"
}

update() {
  tput_clean_text_area
  text_box_confirm "Begin full Update?"
  if text_confirm "Confirm"; then
    tput_clean_text_area
    text_box "Updating in progress"
    text_log "system packages updating..."
    update_system
    text_log "flatpaks updating..."
    flatpak update -y
    text_log "Complete :)"
    sleep 3
  fi
}

# -- Application utilities -- #
command_available() {
  if command -v "${1}" &>/dev/null; then
    return 0
  else
    return 1
  fi
}

# -- Text utilities  -- #
tput_clean_text_area() {
  tput cup 13 0
  tput ed
}

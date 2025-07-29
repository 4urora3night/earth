#!/bin/bash
# by 4urora3night
default_package_installer() {
  sudo pacman -S "${1}" --noconfirm
}
app_installer() {
  ${AUR_HELPER} -S "${1}" --noconfirm
}

app_installed_check() {
  if pacman -Q "${1}" &>/dev/null; then
    return 0
  else
    return 1
  fi
}
update_system() {
  "${AUR_HELPER}" -Syyu --noconfirm
}

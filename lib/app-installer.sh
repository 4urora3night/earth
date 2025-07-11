#!/bin/bash
# by 4urora3night

# -- UI -- #

aurora_unpac() {
  select_file
}

select_file() {
  tput_clean_text_area
  text_box 'Time to unpack your apps.\nStart by selecting your toml configuration file to unload.'

  cd "$script_dir/.." || return 1
  config_toml=$(fd -H -e toml -x realpath {} | fzf_stylised_preview)
  cd "$script_dir" || return 1

  if [[ -z "$config_toml" || ! -f "$config_toml" ]]; then
    text_box "ERROR No valid TOML file selected. Exiting."
    return 1
  fi

  text_box_confirm "Is ${config_toml} the right file?"
  if text_confirm "Confirm"; then
    local table_names=(".pacman.install" ".flatpak.install")
    table_found_names=()

    for i in "${table_names[@]}"; do
      if tomlq -r "${i} // empty" "$config_toml" | grep -q .; then
        if [[ ${i} == ".pacman.install" ]]; then
          if text_confirm "Confirm to install pacman packages"; then
            table_found_names+=("${i}")
          fi
        fi
        if [[ ${i} == ".flatpak.install" ]]; then
          if text_confirm "Confirm to install flatpak packages"; then
            table_found_names+=("${i}")
          fi
        fi
      fi
    done

    if ((${#table_found_names[@]} > 0)); then
      installer
    else
      text_box "No installation tables confirmed. Skipping installer."
    fi

  else
    if text_confirm "Do you wish to redo?"; then
      select_file
    fi
  fi
}

# -- Installers -- #

installer() {
  tput_clean_text_area
  for i in "${table_found_names[@]}"; do
    case "${i}" in
    ".pacman.install") install_pac_apps ;;
    ".flatpak.install") install_flatpak_apps ;;
    esac
  done
  text_log "Complete :)"
  sleep 3
}

install_pac_apps() {
  tput_clean_text_area
  local packages=()
  mapfile -t packages < <(tomlq -r '.pacman.install[]' "$config_toml")
  for i in "${packages[@]}"; do
    pacman_install "$i"

  done
}

install_flatpak_apps() {
  tput_clean_text_area
  local packages=()
  mapfile -t packages < <(tomlq -r '.flatpak.install[]' "$config_toml")
  for i in "${packages[@]}"; do
    flatpak_install "$i"
  done
}

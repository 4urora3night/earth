#!/bin/bash
# by 4urora3night

# -- UI -- #

aurora_unpac() {
  select_file
}

check_tables_presence() {
  if [[ ${i} == ".pacman.install" ]]; then
    if text_confirm "Confirm to install pacman packages?"; then
      table_found_names+=("${i}")
    fi
  fi
  if [[ ${i} == ".flatpak.install" ]]; then
    if text_confirm "Confirm to install flatpak packages?"; then
      table_found_names+=("${i}")
    fi
  fi
  if [[ ${i} == ".git.clone" ]]; then
    if text_confirm "Confirm to download git repositories?"; then
      table_found_names+=("${i}")
    fi
  fi
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
    local table_names=(".pacman.install" ".flatpak.install" ".git.clone")
    table_found_names=()

    for i in "${table_names[@]}"; do
      if tomlq -r "${i} // empty" "$config_toml" | grep -q .; then
        check_tables_presence
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
    ".git.clone") download_git_repo ;;
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
    app_installer "$i"
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

download_git_repo() {
  tput_clean_text_area
  local repo=()
  mapfile -t repo < <(tomlq -r '.git.clone[]' "$config_toml")
  mapfile -t location < <(tomlq -r '.git.location[]' "$config_toml")
  if [[ "${script_dir}/${location}" -eq "${script_dir}" ]]; then
    mkdir -p "${script_dir}/git_files"
    pushd "${script_dir}/git_files"
  else
    mkdir -p "${script_dir}/${location}"
    pushd "${script_dir}/${location}"
  fi
  for link in "${repo[@]}"; do
    tput_clean_text_area
    text_box "Downloading ${link}"
    git clone "${link}"
  done
  popd
}

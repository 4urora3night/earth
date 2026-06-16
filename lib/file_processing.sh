#!/bin/bash

available_tables=()

process_toml() {
  local file="$1"
  local tables=(".pacman.install" ".flatpak.install" ".git.clone" ".git.location" ".wget.download" ".wget.location")

  for table in "${tables[@]}"; do
    if tomlq -r "${table}" "${file}" | grep -q .; then
      available_tables+=("${table}")
    fi
  done

  if [[ -z "${available_tables[*]}" ]]; then
    log_error "No expected tables found"
    exit 1
  fi

  log_information "Tables found:${available_tables[*]}"
}

conf_installer() {
  for table in "${available_tables[*]}"; do
    case "${table}" in
    ".pacman.install")
      pacman_install
      ;;
    ".flatpak.install")
      flatpak_install
      ;;
    ".git.clone")
      git_download
      ;;
    ".wget.download")
      wget_download
      ;;
    esac
  done
}

pacman_install() {

}

flatpak_install() {

}

git_download() {
  local repo_url=$(tomlq -r '.git.clone' "$1" | tr -d '"')

  if [ -z "$repo_url" ]; then
    log_error "Git location not found in TOML file"
    exit 1
  fi

  git clone $repo_url
}

wget_download() {
  local download_url=$(tomlq -r '.wget.file' "$1" | tr -d '"')

  if [ -z "$download_url" ]; then
    log_error "Wget location not found in TOML file"
    exit 1
  fi

  wget $download_url
}

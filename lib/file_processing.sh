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

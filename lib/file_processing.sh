#!/bin/bash

available_tables=()

process_toml() {
  file="$1"
  local tables=(".pacman.install" ".flatpak.install" ".git.clone" ".git.location" ".wget.download" ".wget.location")

  for table in "${tables[@]}"; do
    if tomlq -r "${table} // empty" "${file}" | grep -q .; then
      available_tables+=("${table}")
    fi
  done

  if [[ -z "${available_tables[*]}" ]]; then
    log_error "No expected tables found"
  fi

  log_information "Tables found:${available_tables[*]}"
  conf_installer
}

conf_installer() {
  local system_command_found=False
  local system_packages_found=False

  for table in "${available_tables[@]}"; do
    case "$table" in
    ".system.install")
      system_packages_found=True
      ;;
    ".system.command")
      system_command_found=True
      ;;
    ".flatpak.install")
      echo "found"
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
  # if [[ $system_command_found && $system_packages_found ]]; then
  #   package_install
  # fi
}

package_install() {
  local install_command=()
  local install_package=()
  mapfile -t install_command < <(tomlq -r '.system.command' "$file")
  mapfile -t install_package < <(tomlq -r '.system.install[]' "$file")

  if [ -z "$install_command" ]; then
    log_error "Installation command missing"
  fi

  if [ -z "$install_package" ]; then
    log_error "package name(s) not found in the table"
  fi

  for package in "${install_package[@]}"; do
    log_command "$install_command" "$package"
  done

}

flatpak_install() {
  local install_flatpak=()
  mapfile -t install_flatpak < <(tomlq -r '.flatpak.install[]' "$file")

  if [ -z "$install_flatpak" ]; then
    log_error "Flatpak package(s) name(s) not found in TOML file"
  fi

  for package in "${install_flatpak[@]}"; do
    log_command flatpak install -y "$package"
  done
}

git_download() {
  local repo_url=()
  local location="$(tomlq -r '.git.location' "$file")"
  mapfile -t repo_url < <(tomlq -r '.git.clone[]' "$file")

  echo "${script_dir}/${location}"

  if [ -z "$repo_url" ]; then
    log_error "Git repository URL not found in TOML file"
  fi

  if [[ "${script_dir}/${location}" -eq "${script_dir}" ]]; then
    mkdir -p "${script_dir}/git_repo_cloned"
    pushd "${script_dir}/git_repo_cloned"
  else
    mkdir -p "${script_dir}/${location}"
    pushd "${script_dir}/${location}/"
  fi

  for url in "${repo_url[@]}"; do
    log_command git clone "${url}"
  done

  popd &>/dev/null

}

wget_download() {
  local file_url=()
  local location="$(tomlq -r '.wget.location' "$file")"
  mapfile -t file_url < <(tomlq -r '.wget.file[]' "$file")

  if [[ "${script_dir}/${location}" -eq "${script_dir}" ]]; then
    mkdir -p "${script_dir}/wget_files"
    pushd "${script_dir}/wget_files"
  else
    mkdir -p "${script_dir}/${location}"
    pushd "${script_dir}/${location}"
  fi
  for url in "${file_url}"; do
    log_command wget "${url}"
  done

  popd &>/dev/null
}

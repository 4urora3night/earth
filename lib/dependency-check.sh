#!/bin/bash
# by 4urora3night

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

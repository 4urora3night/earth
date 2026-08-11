#!/bin/bash

log_error() {
  echo "[ERROR] $1" >>"${log_file}"
  exit 1
}

log_warn() {
  echo "[WARN] $1" >>"${log_file}"
}

log_information() {
  echo "[INFO] $1" | tee -a "${log_file}"
}

log_command() {
  echo "[EXEC] ${@}" >>"${log_file}"
  eval "$@" 2>&1 | tee -a "${log_file}"
  exit_code=${PIPESTATUS[0]}

  if [[ $exit_code -ne 0 ]]; then
    log_warn "$* failed with error code $exit_code"
  fi
}

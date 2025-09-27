#!/bin/bash

log_error() {
  echo "[ERROR] $1" >>"${log_file}"
}

log_information() {
  echo "[INFO] $1" | tee -a "${log_file}"
}

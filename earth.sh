#!/bin/bash
# by 4urora3night

# -- Precautions -- #

set -o nounset

# cleanup() {
#   [[ -d "${script_dir}/cache" ]] && rm -rf "${script_dir}/cache"
# }
# trap cleanup EXIT

# -- Variables -- #

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
log_file="${script_dir}/log.md"
dependencies_files=("log" "file_processing")
toml_file=""
RED="\033[0;31m"
NO_FORMAT="\033[0m"

# -- Initialisation -- #

usage() {
  echo "Usage: $0 -f <file>"
  echo "  -f      Pass file name to program[Expects a relative to script directory]"
}

[[ -e "${log_file}" ]] && rm "${log_file}"
touch "${log_file}"

for file in "${dependencies_files[@]}"; do
  [ ! -e "${script_dir}/lib/${file}.sh" ] && echo "FILE NOT FOUND: ${script_dir}/lib/${file}.sh" && exit 1
  source "${script_dir}/lib/${file}.sh"
done

while getopts ":f:h" opts; do
  case ${opts} in
  f)
    toml_file="${OPTARG}"
    log_information "File successfully received: ${OPTARG}"
    ;;
  h)
    usage
    ;;
  *)
    log_error "Missing arguement -f"
    ;;
  esac
done

if [[ -e "${toml_file}" ]]; then
  log_information "File exists"
else
  log_error "File does not exist: ${toml_file}"
fi

if ! command -v tomlq &>/dev/null; then
  echo -e "${RED}tomlq${NO_FORMAT} NOT INSTALLED"
  echo "Please install tomlq for your linux distribution."
  echo "On Arch Linux install yq via pacman"
  exit
fi

# -- Main -- #
process_toml "${toml_file}"

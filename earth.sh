#!/bin/bash
# by 4urora3night

# -- Precautions -- #

set -o errexit
set -o nounset
set -o pipefail

# cleanup() {
#   [[ -d "${script_dir}/cache" ]] && rm -rf "${script_dir}/cache"
# }
# trap cleanup EXIT

# -- Variables -- #

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
log_file="${script_dir}/log.md"
dependencies_files=("log" "file_processing")
toml_file=""

# -- Initialisation -- #

[[ -e "${log_file}" ]] && rm "${log_file}"
touch "${log_file}"

for file in "${dependencies_files[@]}"; do
  [ ! -e "${script_dir}/lib/${file}.sh" ] && echo "FILE NOT FOUND: ${script_dir}/lib/${file}.sh" && exit 1
  source "${script_dir}/lib/${file}.sh"
done

while getopts ":f:acfw" opts; do
  case ${opts} in
  f)
    toml_file="${OPTARG}"
    log_information "File successfully received: ${OPTARG}"
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

# -- Main -- #
process_toml "${toml_file}"

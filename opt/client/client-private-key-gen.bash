#!/usr/bin/env bash

set -o errexit
set -o nounset

program_name="$(basename "${0}")"

usage() {
  usage_doc=$(
    cat <<EOF

Usage example:
  \$ ${program_name}
EOF
  )

  printf '%s\n' "${usage_doc}"

  return 0
}

type openssl >/dev/null

os_name="$(uname -s | tr '[:upper:]' '[:lower:]')"
xss="$(if [[ "${os_name}" = *linux* ]]; then echo ".XXXXXX"; else echo ""; fi)"

temp_dir=$(mktemp -d -t client.pkey"${xss}")

private_key="${temp_dir}"/client.key

openssl genrsa -out "${private_key}" 4096 # >1024

grep --color=auto ".*" <<<"$(ls "${temp_dir}"/client.key)" | tr -d '\n'

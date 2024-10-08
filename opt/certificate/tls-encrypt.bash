#!/usr/bin/env bash

set -o errtrace

type kubectl >/dev/null
type sops >/dev/null

program_name="$(basename "${0}")"
source_dir=$(cd "$(dirname "${0}")" && pwd)
repo_root_dir="$(git -C "${source_dir}" rev-parse --show-toplevel)"

base_dir="${repo_root_dir}"/kp15s/base

host=jpat.io
os_name="$(uname -s | tr '[:upper:]' '[:lower:]')"
xss="$(if [[ "${os_name}" = *linux* ]]; then echo ".XXXXXX"; else echo ""; fi)"

temp_dir=$(mktemp -d -t "${host}".tls"${xss}")

handle_error() {
  grep --color=auto ".*" <<<"$(
    printf '%s\n' "Caught error: ${*}"
  )"

  # to-do
  # tear-down/clean-up
  return 0
}

trap 'handle_error "${?}" "${BASH_COMMAND:-?}" "${LINENO:-?}"' ERR

usage() {
  usage_doc="$(
    cat <<-EOF

Generates encrypted k8s secret manifests, with the 'sops' command.

Note: for demonstration and local experimental it uses a none-preserved PGP key!

Successfully generated encrypted secrets will be found in the directory, '"${base_dir}"' with the
following name pattern '\*-secret.enc.yaml'

Usage: ${program_name} [function] [parameters]

Available functions:

   gen_sops_encrypted_tls_secret [parameters]

   gen_sops_encrypted_tls_secret_with_validate_strict [parameters]

   gen_sops_encrypted_ca_secret [parameters]

Parameters:

A function generates a TLS secret requires: 'tls_crt' and 'tls_key';
A function generates a secret contains the CA requires: 'ca_crt';

Examples:

  \$ ${program_name} gen_sops_encrypted_tls_secret ~/.local/tls/tls.crt ~/.local/tls/tls.key
  \$ ${program_name} gen_sops_encrypted_ca_secret ~/.local/tls/ca.crt
EOF
  )"

  printf '%s\n' "${usage_doc}"

  return 0
}

letter="$(
  cat <<-EOF

A TLS secret is a PEM-encoded X.509, RSA (2048) secret

Note: 'crt' and 'pem' are just interchangeable extensions for the same format and do not differ
EOF
)"

gen_sops_encrypted_tls_secret() {
  # Usage Example
  # ./opt/tls-encrypt.bash gen_sops_encrypted_tls_secret ~/.local/tls/tls.crt ~/.local/tls/tls.key
  local tls_crt="${1:?Expected Server certificate! E.g., tls.crt}"
  local tls_key="${2:?Expected Server certificate key! E.g., tls.key}"

  printf '%s\n' "${letter}"
  printf '%s\n' "Attempt to make an encrypted k8s TLS secret..."

  kubectl create secret tls tls-secret \
    --cert "${tls_crt}" \
    --key "${tls_key}" \
    --dry-run=client \
    --output yaml >"${temp_dir}"/tls-secret.yaml &&
    sops --encrypt "${temp_dir}"/tls-secret.yaml >"${base_dir}"/tls-secret.enc.yaml

  return "${?}"
}

gen_sops_encrypted_tls_secret_with_validate_strict() {
  local tls_crt="${1:?Expected Server certificate! E.g., tls.crt}"
  local tls_key="${2:?Expected Server certificate key! E.g., tls.key}"

  printf '%s\n' "${letter}"
  printf '%s\n' " Attempt to make an encrypted k8s TLS secret, with specifying the CA..."

  kubectl create secret tls tls-secret \
    --cert "${tls_crt}" \
    --key "${tls_key}" \
    --validate=strict \
    --dry-run=client \
    --output yaml >"${temp_dir}"/tls-secret.yaml &&
    sops --encrypt "${temp_dir}"/tls-secret.yaml >"${base_dir}"/tls-secret.enc.yaml

  return "${?}"
}

gen_sops_encrypted_ca_secret() {
  # Usage Example
  # ./opt/tls-encrypt.bash gen_sops_encrypted_ca_secret ~/.local/tls/ca.crt
  local ca_crt="${1:?Expected CA certificate! E.g., ca.crt}"

  printf '%s\n' "${letter}"
  printf '%s\n' "Attempt to make an encrypted k8s Generic secret for the CA..."

  kubectl create secret generic ca-secret \
    --from-file "${ca_crt}" \
    --type=Opaque \
    --dry-run=client \
    --output yaml >"${temp_dir}"/ca-secret.yaml &&
    sops --encrypt "${temp_dir}"/ca-secret.yaml >"${base_dir}"/ca-secret.enc.yaml

  return "${?}"
}

[ -z "${*}" ] && {
  usage

  exit "${?}"
}

grep -q "help" <<<"${1}" && usage

"${@}"

printf '\n%s\n' "The secret is encrypted, check the following file(s)"

grep --color=auto ".*" <<<"$(git --no-pager diff --name-only "${repo_root_dir}/**/*-secret.enc.yaml")"

# LocalWords: LocalWords pem crt tls yaml

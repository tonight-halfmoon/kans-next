#!/usr/bin/env bash

set -o errtrace
# set -o xtrace

###############################################################################
#                    Generate a CA and a server certificate                   #
#
# The CA is supposed to be used for generating a client certificate
# for mutual authentication
#
###############################################################################

program_name="$(basename "${0}")"

usage() {
  usage_doc="$(
    cat <<EOF

Usage example:

\$. ${program_name} ~/.local/tls/mkcert/rootCA.pem ~/.local/tls/mkcert/rootCA-key.pem

EOF
  )"

  printf '%s\n' "${usage_doc}"

  return 0
}

host=jpat.io

program_name="$(basename "${0}")"

type openssl >/dev/null

printf '%s\n' "${program_name}; current directory, $(pwd)"

os_name="$(uname -s | tr '[:upper:]' '[:lower:]')"
xss="$(if [[ "${os_name}" = *linux* ]]; then echo ".XXXXXX"; else echo ""; fi)"

temp_dir=$(mktemp -d -t "${host}".tls"${xss}")

handle_error() {
  grep --color=auto ".*" <<<"$(
    printf '%s\n' "Error: ${*}"
  )"

  rm -f -r -v "${temp_dir}"

  # to-do
  # tear-down/clean-up
  return 0
}
trap 'handle_error "${?}" "${BASH_COMMAND:-?}" "${LINENO:-?}"' ERR

[ ! -e .gitignore ] && touch .gitignore
grep -q ssl <<<"$(<.gitignore)" || echo "ssl" >>.gitignore

ca_crt="${1:-"NONE"}"
ca_key="${2:-"NONE"}"

if [ "${ca_crt}" = "NONE" ] || [ "${ca_key}" = "NONE" ]; then
  printf '%s\n' "${program_name}; attempt to generate the CA..."

  ca_crt="${temp_dir}"/ca.crt
  ca_key="${temp_dir}"/ca.key
  ## The root CA (Certificate Authority)
  openssl genrsa -out "${ca_key}" 4096 # >1024

  ### Certificate signing request for root CA
  openssl req -x509 -new -nodes -key "${ca_key}" -sha256 -days 186 -subj "/O=Experiment TA/CN=experiment.ta" -set_serial 0 -out "${ca_crt}"

  [ -s "${ca_crt}" ] && [ -s "${ca_key}" ]
elif find -f "${ca_crt}" && find -f "${ca_key}"; then
  [ -s "${ca_crt}" ] && printf '%s\n' "The CA certificate found."
  [ -s "${ca_key}" ] && printf '%s\n' "The CA key found."

else
  grep --color=auto ".*" <<<"$(printf '%s' "Error: unable to find ${ca_crt} and/or ${ca_key}! Aborting..." >&2)"
  exit 1
fi

tls_crt="${temp_dir}"/tls.crt
tls_key="${temp_dir}"/tls.key
tls_csr="${temp_dir}"/tls.csr

printf '%s\n' "Attempt to generate a TLS certificate with subject (host name): ${host}..."

## The server certificate
openssl genrsa -out "${tls_key}" 4096 # >1024

### Certificate signing request for the server certificate
openssl req -new -key "${tls_key}" -nodes -subj "/CN=${host}/O=${host}" -out "${tls_csr}"

### Sign the server certificate using the root CA
openssl x509 -req -extfile <(printf '%s' "subjectAltName=DNS:${host}") -in "${tls_csr}" -CA "${ca_crt}" -CAkey "${ca_key}" -CAcreateserial -set_serial 1 -out "${tls_crt}" -days 186 -sha256

[ -s "${tls_crt}" ] && [ -s "${tls_key}" ]

printf '\n%s\n' "The TLS \*.{crt,key} are generated, check the files,"
grep --color=auto ".*" <<<"$(ls -Ahlt "${temp_dir}"/*.{crt,key})"

# LocalWords: LocalWords ssl crt crl tls TLS

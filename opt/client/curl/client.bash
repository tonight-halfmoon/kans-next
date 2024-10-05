#!/usr/bin/env bash

set -o nounset
# set -o xtrace

########################################################################################################################
#                       run a client against a back-end
#
# Usage example:
#    [against a back-end is up and running on a kubernetes cluster behind an Ingress terminating the TLS]
#
#   \$ ./client.bash https /healthz 443 ~/.local/tls/client.crt ~/.local/tls/client.key ~/.local/tls/ca.crt
#   \$ ${program_name} http /metrics 9100
#
#    [against a back-end running bare on a local terminal with `npm start`]
#
#   \$ ${program_name} https /api/v1/ping 8443 /etc/tls/client.crt /etc/tls/client.key /etc/ssl/certs/ca.crt
#
########################################################################################################################

IFS="$(printf ' \t')"

repo_root_dir=$(git -C . rev-parse --show-toplevel)
program_name="$(basename "${0}")"

host_name=jpat.io

usage() {
  usage_doc="$(
    cat <<-EOF

Usage:

\$ ./${program_name}
              <URL Scheme>
              <Endpoint path>
              <PORT>
              <Client certificate (HTTPS)>
              <Client certificate key (HTTPS)>
              <CA Certificate Authority (HTTPS)>
              [HOST]
              [--header "Authorization: ..."]

- URL scheme (HTTP protocols):        HTTPS, HTTP
- Default Certificate Type:           PEM
- Default Server name (host):         ${host_name}

Usage Examples:

\$ ./${program_name} http /metrics 9100

\$ ./${program_name} https healthz 443 /etc/tls/client.crt /etc/tls/client.key /etc/ssl/certs/ca.crt
EOF
  )"

  printf '%s\n' "${usage_doc}"

  return 0
}

url_scheme="${1:?Expected URL Scheme (HTTP Protocol)! E.g, http, https. $(usage)}" # (sometimes called protocol)
endpoint_path="${2:?Expected Endpoint path! $(usage)}"
port="${3:?Expected port! $(usage)}"

if [ "${url_scheme}" = https ]; then
  client_crt="${4:?Expected client certificate .[crt|pem], signed by the server certificate or CA (for mutual authorisation)! $(usage)}"
  client_key="${5:?Expected client certificate Key! $(usage)}"
  ca_crt="${6:?Expected CA .[crt|pem]! $(usage)}"
  cert_type=PEM
  pkey="$("${repo_root_dir}"/opt/private-key-gen.bash)"
  this_jwt="$("${repo_root_dir}"/opt/jwt/jwt-gen.bash s_X "${pkey}")"

  printf '%s\n' "Generated a JWT token - (showing only first 4 characters): $(cut -c -4 <<<"${this_jwt}")"
fi

host="${7:-${host_name}}"

url="${url_scheme}"://"${host}":"${port}"/"${endpoint_path#/}"

printf '%s\n' "Attempt to evaluate curl on the URL, ${url}"

if [ "${url_scheme}" = https ]; then
  curl \
    --header "Authorization: Bearer ${this_jwt}" \
    --cert "${client_crt}" \
    --key "${client_key}" \
    --cacert "${ca_crt}" \
    --cert-type "${cert_type}" \
    --tlsv1.2 --tls-max 1.3 \
    --include \
    --verbose \
    "${url}" | grep --color=auto ".*"
else
  curl \
    --include \
    --verbose \
    "${url}" | grep --color=auto ".*"
fi

unset IFS

# LocalWords: LocalWords cacert tlsv tls TLS crt pem

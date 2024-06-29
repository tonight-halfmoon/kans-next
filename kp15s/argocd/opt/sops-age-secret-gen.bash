#!/usr/bin/env bash

set -o errexit

type sops 1>/dev/null

source_dir="$(cd "$(dirname "${0}")" && pwd)"
repo_root_dir="$(git -C "${source_dir}" rev-parse --show-toplevel)"

if [ ! -r "${HOME}"/.config/sops/age/keys.txt ]; then
  age-keygen -o /tmp/age.keys.txt
  mkdir -p "${HOME}"/.config/sops/age && mv /tmp/age.keys.txt "${HOME}"/.config/sops/age/keys.txt
fi

kubectl create secret generic sops-age \
  --namespace argocd \
  --dry-run=client \
  --from-file keys.txt=/dev/stdin \
  --output yaml <"${HOME}"/.config/sops/age/keys.txt \
  >"${source_dir}"/sops-age-secret.yaml

sops --encrypt "${source_dir}"/sops-age-secret.yaml >"${repo_root_dir}"/argocd/sops-age-secret.enc.yaml

rm "${source_dir}"/sops-age-secret.yaml 1>/dev/null

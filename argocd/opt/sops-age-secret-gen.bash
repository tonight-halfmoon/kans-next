#!/usr/bin/env bash

if [ ! -r "${HOME}"/.config/sops/age/keys.txt ]; then
  age-keygen -o /tmp/age.keys.txt
  mkdir -p "${HOME}"/.config/sops/age && mv /tmp/age.keys.txt "${HOME}"/.config/sops/age/keys.txt
fi

kubectl create secret generic sops-age \
  --namespace argocd \
  --from-file keys.txt=/dev/stdin \
  <"${HOME}"/.config/sops/age/keys.txt

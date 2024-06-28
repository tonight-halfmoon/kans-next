#!/usr/bin/env bash

###############################################################################
#                      Minikube CLI client                      #
#
###############################################################################

minikube_enable_ingress() {
  minikube status ||
    {
      printf '%s\n' "Expected minikube to be running!" >&2
      return 1
    }

  if [ enabled = "$(minikube addons list --output json | jq ".\"ingress\".\"Status\"" | tr -d '\"' | tr -d '\n')" ]; then

    printf '%s\n' "minikube addons ingress is already enabled ✨👍"
  else
    printf '%s\n' "Attempt to enable minikube addons ingress..."
    minikube addons enable ingress
  fi

  return "${?}"
}

is_minikube_context() {
  grep -q "^minikube$" <<<"$(kubectx --current | tr -d '\n')" || {
    printf '%s\n' :not_minikube_context! >&2
    return 1
  }
  return 0
}

minikube_wait_for_ingress_nginx() {
  this_ingress_nginx_pod=""
  until [ -n "${this_ingress_nginx_pod}" ]; do
    printf '%s' .
    sleep 1
    this_ingress_nginx_pod=$(kubectl --namespace ingress-nginx get pod --selector app.kubernetes.io/component=controller --output name)
  done
  echo -e

  kubectl --namespace ingress-nginx wait --for condition=Ready pod "${this_ingress_nginx_pod#pod/}" --timeout -1s

  return "${?}"
}

"${@}"

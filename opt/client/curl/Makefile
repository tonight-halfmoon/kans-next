.PHONY: help

help:
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[37;2;1m%-17s\033[32;m %s\n", $$1, $$2}'

# Usage Example:
# From the root directory of this project, evaluate the following command
# make --directory=./opt/client/curl healthz

minikube_tunnel: ## Run Minikube tunnel
	minikube tunnel

health: ## Run a cURL client against the (actuator) `health` (HTTPS Endpoint); CLAs: client_cert=/etc/tls/client.crt client_key=/etc/tls/client.key ca_cert=~/.local/tls/ca.crt
	./client.bash https health 443 $(client_cert) $(client_key) $(ca_cert)

api_ping: ## Run a cURL client against the `api/v1/ping` API (HTTPS Endpoint)
	./client.bash https api/v1/ping 443 /etc/tls/client.crt /etc/tls/client.key /etc/ssl/certs/ca.crt

.PHONY: help

help:
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[37;2;1m%-17s\033[32;m %s\n", $$1, $$2}'

# Usage Example:
# From the root directory of this project, evaluate the following command
# make --directory=./opt/client/curl healthz

health: ## Run a cURL client against the (actuator) `health` (HTTPS Endpoint); CLAs: client_cert=/etc/tls/client.crt client_key=/etc/tls/client.key ca_cert=~/.local/tls/ca.crt
	./client.bash https health $(port) $(client_cert) $(client_key) $(ca_cert)

api_ping: ## Run a cURL client against the `api/v1/ping` API (HTTPS Endpoint); Usage Example: make api_ping port=4001 client_cert=/etc/tls/client.crt client_key=/etc/tls/client.key ca_cert=~/.local/tls/ca.crt
	./client.bash https api/v1/ping $(port) $(client_cert) $(client_key) $(ca_cert)

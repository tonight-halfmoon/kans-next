.PHONY: help

help:
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[37;2;1m%-17s\033[32;m %s\n", $$1, $$2}'

postgres_access_secret_gen: ## Generate K8s secret for PostgreSQL database access (username and password)
	kubectl create secret generic postgres-access \
		--from-literal username=$(username) --from-literal password=$(password) \
		--type=Opaque \
		--dry-run=client \
		--output yaml >/tmp/postgres-access-secret.yaml

postgres_access_secret_enc: ## Encrypt with SOPS the K8s secret and delete the raw source secret
	sops --encrypt /tmp/postgres-access-secret.yaml >postgres-access-secret.enc.yaml
	rm /tmp/postgres-access-secret.yaml

psql_client_on_kubernetes_pod: ## Access the deployed PostgreSQL database on Kubernetes; CLA: deployment_environment=dev
	kubectl --namespace postgres exec --stdin --tty pods/postgresql-0 -- psql --username ci_$(deployment_environment) --dbname postgres

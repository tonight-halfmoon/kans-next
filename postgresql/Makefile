postgres_access_secret_gen: ## Generate K8s secret for PostgreSQL database access (username and password)
	kubectl create secret generic postgres-access \
		--from-literal username=$(username) --from-literal password=$(password) \
		--type=Opaque \
		--dry-run=client \
		--output yaml >/tmp/postgres-access-secret.yaml

postgres_access_secret_enc: ## Encrypt with SOPS the K8s secret and delete the raw source secret
	sops --encrypt /tmp/postgres-access-secret.yaml >postgres-access-secret.enc.yaml
	rm /tmp/postgres-access-secret.yaml

postgres_access_secret_gen:
	kubectl create secret generic postgres-access \
		--from-literal username=$(username) --from-literal password=$(password) \
		--type=Opaque \
		--dry-run=client \
		--output yaml >/tmp/postgres-access-secret.yaml

postgres_access_secret_enc:
	sops --encrypt /tmp/postgres-access-secret.yaml >postgres-access-secret.enc.yaml
	rm /tmp/postgres-access-secret.yaml

.PHONY: help

help:
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[37;2;1m%-17s\033[32;m %s\n", $$1, $$2}'

repo_root_dir := $(CURRDIR)

export

deploy_services: ## Kustomize Build with root Kustomization.yaml with plugins enabled and pipe to kubectl apply
	kustomize build --enable-alpha-plugins --enable-exec  | kubectl apply --filename -

deploy_app: ## Kustomize Build a particular app/environment with plugins enabled and pipe to kubectl apply; Command Line Argument example: app=elixir env=dev
	kustomize build --enable-alpha-plugins --enable-exec .$(repo_root_dir)/$(app)/overlays/$(env) | kubectl apply --filename -

diff_app: ## Kustomize Build a particular app/environment with plugins enabled and pipe to kubectl diff; Command Line Argument example: app=elixir env=dev
	kustomize build --enable-alpha-plugins --enable-exec .$(repo_root_dir)/$(app)/overlays/$(env) | kubectl diff --filename -

deploy_monitoring_installation: ## Monitoring installation
	helm repo add prometheus-community \
		https://prometheus-community.github.io/helm-charts
	helm upgrade --install \
		-f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/docs/src/samples/monitoring/kube-stack-config.yaml \
		prometheus-community \
		prometheus-community/kube-prometheus-stack

gen_tls_certificate_for_host: ## Generate A TLS certificate for the HOST; pass host name, e.g., host=jpat.io; Pass CA cert and key if available
	.$(repo_root_dir)/opt/certificate/tls-gen-$(host) $(ca_cert) $(ca_key)

gen_sops_encrypted_tls_secret: ## Generate an encrypted `TLS` K8s secret manifest; Command Line Argument example: pem=tls.crt pem_key=tls.key
	.$(repo_root_dir)/opt/certificate/tls-encrypt.bash gen_sops_encrypted_tls_secret_with_validate_strict $(pem) $(pem_key)

gen_sops_encrypted_ca_secret: ## Generate an encrypted CA K8s secret manifest; Command Line Argument example: ca_pem=ca.crt
	.$(repo_root_dir)/opt/certificate/tls-encrypt.bash gen_sops_encrypted_ca_secret $(ca_pem) $(app)

codespell_check: ## Run codespell to check misspelling
	@codespell --skip="**/cache,**/_build,**/deps,**/assets,**/priv,**/node_modules" --uri-ignore-words-list statics --exclude-file Makefile

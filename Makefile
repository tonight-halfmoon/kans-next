.PHONY: help

help:
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[37;2;1m%-17s\033[32;m %s\n", $$1, $$2}'

repo_root_dir := $(CURRDIR)

export

minikube_start: ## Start a K8s cluster with Minikube
	minikube start --cpus=4 --disk-size=40gb --memory=8gb

build_image_and_minikube_load: ## Build a docker image for an application and load it to the current profile of Minikube K8s cluster; Command Line Argument example: app=elixir environment=dev source_revision="$(tr -d '\n'<./elixir/app/VERSION)"
	docker build \
		--build-arg parameter_mix_env=$(environment) \
		--label kans.source_revision=$(source_revision) \
		--label kans.app_name=$(app) \
		--tag $(app)-$(environment):$(source_revision) \
		--progress plain \
		--file ./$(app)/app/Dockerfile.alpine \
		./$(app)/app
	minikube image load $(app)-$(environment):$(source_revision)

deploy_services: ## Kustomize Build with root Kustomization.yaml with plugins enabled and pipe to kubectl apply
	kustomize build --enable-alpha-plugins --enable-exec  | kubectl apply --filename -

deploy_app: ## Kustomize Build a particular app/environment with plugins enabled and pipe to kubectl apply; Command Line Argument example: app=elixir env=dev
	kustomize build --enable-alpha-plugins --enable-exec .$(repo_root_dir)/$(app)/overlays/$(env) | kubectl apply --filename -

deploy_monitoring_installation: ## Monitoring installation
	helm repo add prometheus-community \
		https://prometheus-community.github.io/helm-charts
	helm upgrade --install \
		-f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/docs/src/samples/monitoring/kube-stack-config.yaml \
		prometheus-community \
		prometheus-community/kube-prometheus-stack

gen_sops_encrypted_tls_secret: ## Generate encrypted `TLS` K8s secret for app; Command Line Argument example: pem=tls.crt pem_key=tls.key app=elixir
	.$(repo_root_dir)/opt/tls-encrypt.bash gen_sops_encrypted_tls_secret $(pem) $(pem_key) $(app)

gen_sops_encrypted_ca_secret: ## Generate encrypted CA K8s secret for app; Command Line Argument example: ca_pem=ca.crt app=elixir
	.$(repo_root_dir)/opt/tls-encrypt.bash gen_sops_encrypted_ca_secret $(ca_pem) $(app)

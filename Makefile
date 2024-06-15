.PHONY: help

help:
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[37;2;1m%-17s\033[32;m %s\n", $$1, $$2}'

repo_root_dir := $(CURRDIR)

export

minikube_start: ## Start a K8s cluster with Minikube
	minikube start --cpus=4 --disk-size=40gb --memory=8gb

build_image: ## Build a docker image for an application and load it to the current profile of Minikube K8s cluster
	docker build \
		--build-arg parameter_mix_env=$(environment) \
		--label source_revision=$(source_revision) \
		--label app_name=$(app) \
		--tag $(app)-$(environment):$(source_revision) \
		--file ./$(app)/app/Dockerfile.alpine \
		./$(app)/app
	minikube image load $(app)-$(environment):$(source_revision)

deploy: ## Kustomize Build with plugins enabled and pipe to kubectl apply
	kustomize build --enable-alpha-plugins --enable-exec $(repo_root_dir) | kubectl apply --filename -

deploy_monitoring_installation: ## Monitoring installation
	helm repo add prometheus-community \
		https://prometheus-community.github.io/helm-charts
	helm upgrade --install \
		-f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/docs/src/samples/monitoring/kube-stack-config.yaml \
		prometheus-community \
		prometheus-community/kube-prometheus-stack

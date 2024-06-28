.PHONY: help

help:
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[37;2;1m%-17s\033[32;m %s\n", $$1, $$2}'

minikube_start: ## Start a K8s cluster with Minikube
	minikube start --cpus=4 --disk-size=40gb --memory=8gb

minikube_enable_ingress:
	./minikube-cli-client.bash minikube_enable_ingress

is_minikube_context:
	./minikube-cli-client.bash is_minikube_context

minikube_wait_for_ingress_nginx:
	./minikube-cli-client.bash minikube_wait_for_ingress_nginx

minikube_load_docker_image: ## load a Docker image into the current profile of Minikube; Command Line Argument example: app=elixir environment=dev source_revision="$(tr -d '\n'<./elixir/app/VERSION)"
	minikube image load $(app)-$(environment):$(source_revision)

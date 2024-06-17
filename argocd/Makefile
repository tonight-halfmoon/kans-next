.PHONY: help

help:
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[37;2;1m%-17s\033[32;m %s\n", $$1, $$2}'

git_remote := $(shell git remote --verbose | head -n 1 | cut -d ' ' -f 1 | awk '{print $2}' | sed s/'\:'/'\/'/ | cut -d '@' -f 2)

export

argocd_install: ## Install ArgoCD (Getting Started)
	kubectl create namespace argocd
	kubectl apply --namespace argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

argocd_login_cli: ## Login to Local ArgoCD with the CLI
	argocd login 127.0.0.1:8080

argocd_connect_to_this_git_repo_with_ssh_private_key: ## Setup connection against a private Git Repository with SSH private key
	argocd repo add git@$(git_remote) --ssh-private-key-path $(HOME)/.ssh/kans-next

argocd_restart_server: ## ArgoCD restart the K8s deployment `argocd-server` and watch the status
	kubectl --namespace argocd rollout restart deployment argocd-server
	kubectl --namespace argocd rollout status deployment argocd-server

argocd_restart_repo_server: ## ArgoCD restart the K8s deployment `argocd-repo-server` and watch the status
	kubectl --namespace argocd rollout restart deployment argocd-repo-server
	kubectl --namespace argocd rollout status deployment argocd-repo-server

argocd_port_forward: ## Run a port-forward against the K8s service `argocd-server`; Client can check `127.0.0.1:8080`
	kubectl --namespace argocd port-forward svc/argocd-server 8080:80 &

generate_sops_age_secret: ## Generate `age` Keys and deploy a K8s secret `sops-age`
	./opt/sops-age-secret-gen.bash

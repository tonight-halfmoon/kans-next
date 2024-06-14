# Operation Manual (Minikube)

Run commands at the repository directory's root level unless specied otherwise.

## Initial setup

```shell
asdf install
```

## K8s cluster with Minikube

### Start a Minikube K8s cluster

```shell
asdf plugin-add minikube
asdf install
```

```shell
make minikube_start
```

## Monitoring

```shell
make deploy_monitoring_installation
```

```shell-session
kubectl port-forward svc/prometheus-community-kube-prometheus 9090
```

## Make first deployment

```shell
make deploy
```

## ArgoCD

```shell
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

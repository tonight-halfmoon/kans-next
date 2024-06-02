# Kubernetes Dashboard

```shell
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
```

```shell
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
```

```shell
kubectl create serviceaccount -n kubernetes-dashboard admin-user
```

```shell
kubectl create clusterrolebinding -n kubernetes-dashboard admin-user --clusterrole cluster-admin --serviceaccount=kubernetes-dashboard:admin-user
```

```shell
token=$(kubectl -n kubernetes-dashboard create token admin-user)
```

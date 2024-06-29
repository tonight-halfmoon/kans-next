# ArgoCD

- [Getting Started](https://argo-cd.readthedocs.io/en/stable/getting_started/)

## Makefile

In the root directory, one may run ArgoCD Makefile tasks as follows.

```shell
make --directory=./argocd
```

## Bug Fix

### trouble decrypting

The K8s `argocd-repo-server` is not able to decrypt a sops-encrypted secret
with `age` keys

```txt
Unable to create application: application spec for kans-elixir-dev is
invalid: InvalidSpecError: Unable to generate manifests in
elixir/overlays/dev: rpc error: code = Unknown desc = `kustomize build
<path to cached source>/elixir/overlays/dev --enable-alpha-plugins
--enable-exec` failed exit status 1: failed to evaluate function:
error decrypting file "./ca-secret.enc.yaml" from manifest.Files:
trouble decrypting file: Error getting data key: 0 successful groups
required, got 0unable to generate manifests: error decrypting file
"./ca-secret.enc.yaml" from manifest.Files: trouble decrypting file:
Error getting data key: 0 successful groups required, got 0Error:
accumulating resources: accumulation err='accumulating resources from
'../**/base': '<path to cached source>/**/base' must resolve to a
file': recursed accumulation of path '<path to cached
source>/**/base': couldn't execute function: exit status 1
```

Assumptions:

- The private key of `age` is deployed as a K8s secret in the `argocd`
  namespace and the `argocd-repo-server` has already consumed it.

## Debugging

Exec to the container of `argocd-repo-server` found out that the
volume is incorrectly configured. Instead of being a file contains the
necessary key value. It is actually a directory!

```shell
argocd@argocd-repo-server-123:~$ test -d /.config/sops/age/keys.txt && echo yes
yes
```

### InvalidSpecError

Error detail: destination server and namespace do not match

```text
Unable to create application: application spec for kans-elixir-dev is
invalid: InvalidSpecError: application repo
git@github.com:tonight-halfmoon/kans-next.git is not permitted in
project 'jpat';InvalidSpecError: application destination server
'https://kubernetes.default.svc' and namespace 'kans-elixir-dev' do
not match any of the allowed destinations in project 'jpat'
```

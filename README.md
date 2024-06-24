# Empirical Pursue DevOps and GitOps Approach

Empirical minimum viable demonstration on DevOps and GitOps topics

Showing the following

- Kubernetes workload is defined by the tracked Git commit of the source code (i.e., HEAD)
- Code yields in the next image artifact (Docker)
- Continuous Deployment (CD) with ArgoCD
- Continuous Integration (CI) with GitHub Actions and Bitbucket Pipelines (in-progress)
  - Manual integration is utilised with Makefile and shell scripts
- Kubernetes deployment with the following technologies
  - Kustomize - With a Base layer and Overlays (at the moment development)
  - SOPS - encrypt sensitive data
  - TLS - Self-signed certificate to demonstrate `HTTPS`
  - Ingress - (simple expose to Kubernetes Nodeport/Service)
  - Monitoring (on-going progress)
    - Prometheus with Service Monitor (Helm installation with minimum Kubernetes customisation)
  - mkcert is utilised for generating self-signed certificate
  - Minikube as a local cluster
  - K3d as a local cluster (on-going)
  - Code changes for the next image build with `Makefile` to facilitate rapid local development
    course (test, write, fix)
  - Image push
  - Microservices and Server-Client Architecture (Next Phase)
  - Simple scripts wrapping `cURL` client to make HTTPS requests against the REST API

The ArgoCD is an on-going progress of being managed a part of GitOps in
this Git repository. Next Git commit-merge is watched by the ArgoCD application running locally.
At the moment, managing infrastructure by Terraform is not necessary because Minikube/K3d clusters
are utilised locally. The docker images are not pushed to remote Docker Hub.

Managed Kubernetes workloads of Demonstration

- Elixir Phoenix application serves a simple REST API
- Context Services
  - PostgreSQL (Docker image)
  - ArgoCD (incrementally on-going progress)
  - Redis to demonstrate cache utilisation (next Phase)

## Tests

GitHub Actions, BitBucket pipelines and Makefile scripts are provided. Makefile is very useful to
run the unit tests with/on a docker image locally after some code modification,
and before a Git commit push to remote.
This is very useful for a rapid development course.

## Future Work

- Deploy and manage another backend to show clearer microserviecs architecture
- Utilise MQTT Message broker and simulated connected non-human clients
- Provision and manage infrastructure with Terraform
- Utilise cert-manager on `letsencrypt`
- Get a free subscription with cloud provider to provision and manage the infrastructure
  in Terraform (IaC)
- Complete the Kubernetes deployment management of ArgoCD
- Remote Git repository
  - Setup branch protections and add branch rule-set
  - Register and setup GitHub App access for ArgoCD
- Unit Tests and code coverage
  - Maintain 85% code coverage
  - Utilise code coverage tool
- Fix the CI GitHub Actions and Bitbucket Pipelines
- Utilise Kustomize Components

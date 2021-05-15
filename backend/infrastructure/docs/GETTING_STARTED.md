# Buckram: Getting Started

## Local development

### Prerequisites

* docker-compose

## Kubernetes deployment

### Prerequisites

* kubectl
* helm
* a running Kubernetes cluster (with RBAC)

### Steps

Assuming

1. Create `values.yaml`
2. Run `helm init`
3. Set up SSL (LetsEncrypt)
   * `helm install --name cert-manager stable/cert-manager`
   * `helm install --name nginx-ingress stable/nginx-ingress`

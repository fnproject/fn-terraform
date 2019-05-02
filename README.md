# Terraform Module for Fn

*** EXPERIMENTAL ***

This repository is intended to provide a quick start for deploying a production ready install of Fn
with the following features:

* DNS managed by External-DNS
* TLS managed by Cert-Manager
* Ingress managed by Ingress-Nginx
* Metrics provided by Prometheus
* Visualizations provided by Grafana

### Pre-requisites:

1. Fresh Kubernetes cluster (1.11+)

1. Helm / Tiller configured
    * `kubectl create serviceaccount --namespace kube-system tiller`
    * `kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller`
    * `kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'`
    * `helm init --service-account tiller --upgrade`

1. Install Cert-Manager custom resource definitions
    * `kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.7/deploy/manifests/00-crds.yaml`

### Configuring External-DNS

See `external-dns-values.yaml.sample` for a simple example using Dyn.  Note that the `dns_zone` variable is available
and that the file will be interpolated through Terraform.

1. Copy `external-dns-values.yaml.sample` to `external-dns-values.yaml`
1. Fill in appropriate values based on your DNS provider.

See https://github.com/helm/charts/tree/master/stable/external-dns for configuration options.

### Configuring TLS / Let's Encrypt

1. Copy `fn-values.yaml.sample` to `fn-values.yaml`
1. Fill in your email address and other values as needed.  Let's Encrypt will use this email to notify you of certificate expirations.

### After install:

1. Fetch Grafana admin password:
    * `kubectl get secret grafana -o yaml`
    * Decode it using `base64`
    * echo <encoded bits from kubectl output> | base64 --decode

1. Fetch Ingress endpoints:
    * `kubectl get ingress`

1. Configure Fn (~/.fn/contexts/default)
    * https://fn.api.<dns_zone>.com/

NOTES:

External DNS helm chart is cloned in this repo pending this pull request's approval:
* https://github.com/helm/charts/pull/12166

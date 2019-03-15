# Terraform Module for Fn

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

1. Install Let's Encrypt Staging fake root certificate
    * https://letsencrypt.org/certs/fakelerootx1.pem
    * Install is OS specific and beyond scope of this document.

### Configuring External-DNS

See `external-dns-values.yaml.sample` for a simple example using Dyn.  Note that the `dns_zone` variable is available 
and that the file will be interpolated through Terraform.  Copy this file to `external-dns-values.yaml` and fill in as
appropriate based on your DNS provider.

See https://github.com/helm/charts/tree/master/stable/external-dns for configuration options.

### After install:

1. Fetch Grafana admin password:
    * `kubectl get secret grafana -o yaml`
    * Decode it using `base64`
    * echo <encoded bits from kubectl output> | base64 --decode

1. Fetch Ingress endpoints:
    * `kubectl get ingress`

1. Configure Fn (~/.fn/contexts/default)
    * https://fn.api.<dyn_zone>.com/

1. Add Prometheus as Data Source in Grafana: `http://prometheus-server`

### Working with Fn behind nginx-ingress

To use certain commands, such as `fn invoke`, you will need to set an HTTP_PROXY which is based off of the `dns_zone` variable.
For example:
    `export HTTP_PROXY=fn.api.example.com:80`
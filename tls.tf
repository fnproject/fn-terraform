resource "kubernetes_namespace" "cert-manager" {
    metadata {
        name = "${var.namespace_cert_manager}"

        labels {
            "certmanager.k8s.io/disable-validation" = "true"
        }
    }
}

data "helm_repository" "jetstack" {
    name = "jetstack"
    url  = "https://charts.jetstack.io"
}

resource "helm_release" "cert-manager" {
    name       = "cert-manager"
    repository = "${data.helm_repository.jetstack.metadata.0.name}"
    chart      = "jetstack/cert-manager"
    version    = "0.7.0"
    namespace  = "${var.namespace_cert_manager}"
    wait       = true
}
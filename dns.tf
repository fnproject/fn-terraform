data "template_file" "external-dns-config" {
  template = "${file("${path.module}/external-dns-values.yaml")}"

  vars = {
      dns_zone = "${var.dns_zone}"
  }
}

resource "helm_release" "external-dns" {
    name       = "external-dns"
    chart      = "./external-dns"
    namespace  = "${var.namespace_external_dns}"
    wait       = true
    depends_on = ["helm_release.nginx_ingress"]

    set {
        name  = "rbac.create"
        value = "true"
    }

    set {
        name  = "rbac.apiVersion"
        value = "v1"
    }

    values = [
        "${data.template_file.external-dns-config.rendered}"
    ]
}
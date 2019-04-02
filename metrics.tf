resource "helm_release" "prometheus" {
    name      = "prometheus"
    chart     = "stable/prometheus"
    namespace = "${var.namespace_prometheus}"
    wait      = false

    set {
        name  = "server.ingress.enabled"
        value = "true"
    }

    set_string {
        name  = "server.ingress.hosts[0]"
        value = "prometheus.${var.dns_zone}"
    }
}

data "kubernetes_secret" "grafana_admin_secret" {
  metadata {
    namespace = "${var.namespace_grafana}"
    name      = "grafana"
  }
}

output "grafana_admin_user" {
  value = "${data.kubernetes_secret.grafana_admin_secret.data.admin-user}"
}

output "grafana_admin_password" {
  value = "${data.kubernetes_secret.grafana_admin_secret.data.admin-password}"
}

resource "helm_release" "grafana" {
    name      = "grafana"
    chart     = "stable/grafana"
    namespace = "${var.namespace_grafana}"
    wait      = false

    set {
        name  = "ingress.enabled"
        value = "true"
    }

    set_string {
        name  = "ingress.hosts[0]"
        value = "grafana.${var.dns_zone}"
    }
}
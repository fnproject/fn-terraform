resource "helm_release" "prometheus" {
    name  = "prometheus"
    chart = "stable/prometheus"
    wait  = false

    set {
        name  = "server.ingress.enabled"
        value = "true"
    }

    set_string {
        name  = "server.ingress.hosts[0]"
        value = "prometheus.${var.dns_zone}"
    }
}

resource "helm_release" "grafana" {
    name  = "grafana"
    chart = "stable/grafana"
    wait  = false

    set {
        name  = "ingress.enabled"
        value = "true"
    }

    set_string {
        name  = "ingress.hosts[0]"
        value = "grafana.${var.dns_zone}"
    }
}
data "kubernetes_service" "nginx-ingress-service" {
  metadata {
    namespace = "${var.namespace_nginx_ingress}"
    name      = "nginx-ingress-controller"
  }
  depends_on = ["helm_release.nginx_ingress"]
}

# TODO: Add Nginx scraper to Prometheus config.
resource "helm_release" "nginx_ingress" {
    name      = "nginx-ingress"
    chart     = "stable/nginx-ingress"
    namespace = "${var.namespace_nginx_ingress}"
    wait      = true

    set {
        name  = "controller.publishService.enabled"
        value = "true"
    }

    set {
        name  = "controller.metrics.enabled"
        value = "true"
    }

    set {
        name  = "controller.stats.enabled"
        value = "true"
    }
}
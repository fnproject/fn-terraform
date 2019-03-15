resource "null_resource" "init_fn" {
    provisioner "local-exec" {
        command = "rm -rf fn-helm && git clone https://github.com/fnproject/fn-helm.git && helm dependency update fn-helm/fn"
    }
}

data "template_file" "fn-config" {
    template = "${file("${path.module}/fn-values.yaml")}"
}

// TODO: Enable metrics in Grafana dashboard.
resource "helm_release" "fn" {
    name       = "fn"
    chart      = "fn-helm/fn"
    depends_on = ["null_resource.init_fn",
                  "helm_release.cert-manager"]
    namespace  = "${var.namespace_fn}"
    wait       = true

    set {
        name  = "nameOverride"
        value = "${var.fn_cluster_name}"
    }

    set {
        name  = "fn_lb_runner.service.ingress_hostname"
        value = "lb.${var.dns_zone}"
    }

    set {
        name  = "fn_api.service.ingress_hostname"
        value = "api.${var.dns_zone}"
    }

    set {
        name  = "ui.service.ingress_hostname"
        value = "ui.${var.dns_zone}"
    }

    // TODO: Make resource requests and limits configurable.
    set {
        name  = "fn_runner.resources.requests.cpu"
        value = "200m"
    }

    set {
        name  = "fn_runner.resources.requests.memory"
        value = "16Gi"
    }

    set {
        name  = "fn_runner.resources.limits.cpu"
        value = "200m"
    }

    set {
        name  = "fn_runner.resources.limits.memory"
        value = "16Gi"
    }

    values = [
        "${data.template_file.fn-config.rendered}"
    ]
}
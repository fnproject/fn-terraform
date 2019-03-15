variable "k8s_config_path" {
    default = "~/.kube/config"
}

variable fn_cluster_name {
    default = "demo"
}

variable dns_zone {}

variable namespace_cert_manager {
    default = "cert-manager"
}

variable namespace_external_dns {
    default = "ingress"
}

variable namespace_fn {
    default = "fn"
}

variable namespace_grafana {
    default = "metrics"
}

variable namespace_nginx_ingress {
    default = "ingress"
}

variable namespace_prometheus {
    default = "metrics"
}
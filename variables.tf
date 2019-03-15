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
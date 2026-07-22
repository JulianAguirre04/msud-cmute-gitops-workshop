output "kubeconfig" {
  value     = kind_cluster.lab.kubeconfig
  sensitive = true
}

output "endpoint" {
  value = kind_cluster.lab.endpoint
}
output "cluster_endpoint" {
  description = "Internal endpoint of the Kubernetes API server"
  value       = google_container_cluster.private_cluster.endpoint
}

output "bastion_ip" {
  description = "External IP address of the bastion host"
  value       = google_compute_instance.bastion_host.network_interface[0].access_config[0].nat_ip
}


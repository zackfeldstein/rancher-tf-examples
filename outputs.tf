# Cluster Information
output "cluster_id" {
  description = "The ID of the RKE2 cluster"
  value       = rancher2_cluster.rke2_cluster.id
}

output "cluster_name" {
  description = "The name of the RKE2 cluster"
  value       = rancher2_cluster.rke2_cluster.name
}

output "cluster_state" {
  description = "The state of the RKE2 cluster"
  value       = rancher2_cluster.rke2_cluster.cluster_registration_token.0.cluster_id != null ? "active" : "provisioning"
}

output "kubernetes_version" {
  description = "The Kubernetes version of the cluster"
  value       = rancher2_cluster.rke2_cluster.rke2_config[0].version
}

# Cluster Access
output "kube_config" {
  description = "Kubeconfig for accessing the cluster"
  value       = rancher2_cluster_sync.rke2_cluster_sync.kube_config
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "CA certificate for the cluster"
  value       = rancher2_cluster_sync.rke2_cluster_sync.ca_crt
  sensitive   = true
}

output "cluster_client_certificate" {
  description = "Client certificate for the cluster"
  value       = rancher2_cluster_sync.rke2_cluster_sync.client_cert
  sensitive   = true
}

output "cluster_client_key" {
  description = "Client key for the cluster"
  value       = rancher2_cluster_sync.rke2_cluster_sync.client_key
  sensitive   = true
}

# Registration Information
output "cluster_registration_token" {
  description = "Registration token for adding nodes to the cluster"
  value       = rancher2_cluster.rke2_cluster.cluster_registration_token[0].token
  sensitive   = true
}

output "cluster_registration_command" {
  description = "Command to register nodes to the cluster"
  value       = rancher2_cluster.rke2_cluster.cluster_registration_token[0].command
  sensitive   = true
}

# Node Pool Information
output "control_plane_pool_id" {
  description = "The ID of the control plane node pool"
  value       = rancher2_node_pool.control_plane.id
}

output "worker_pool_id" {
  description = "The ID of the worker node pool"
  value       = var.worker_count > 0 ? rancher2_node_pool.worker[0].id : null
}

output "total_nodes" {
  description = "Total number of nodes in the cluster"
  value       = var.control_plane_count + var.worker_count
}

output "control_plane_nodes" {
  description = "Number of control plane nodes"
  value       = var.control_plane_count
}

output "worker_nodes" {
  description = "Number of worker nodes"
  value       = var.worker_count
}

# Network Information
output "cluster_cidr" {
  description = "CIDR range for cluster pods"
  value       = rancher2_cluster.rke2_cluster.cluster_cidr
}

output "service_cidr" {
  description = "CIDR range for cluster services"
  value       = rancher2_cluster.rke2_cluster.service_cidr
}

output "cluster_endpoint" {
  description = "Cluster API endpoint"
  value       = rancher2_cluster_sync.rke2_cluster_sync.api_endpoint
} 
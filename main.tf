# RKE2 Cluster
resource "rancher2_cluster" "rke2_cluster" {
  name        = var.cluster_name
  description = var.cluster_description

  rke2_config {
    version = var.kubernetes_version
    
    upgrade_strategy {
      control_plane_concurrency = "1"
      worker_concurrency        = "1"
    }
  }

  # Network configuration
  cluster_cidr    = var.cluster_cidr
  service_cidr    = var.service_cidr
  cluster_dns     = var.cluster_dns
  cluster_domain  = var.cluster_domain

  # Security
  enable_network_policy                     = var.enable_network_policy
  default_pod_security_policy_template_id  = var.default_pod_security_policy_template_id

  # Metadata
  labels      = var.labels
  annotations = var.annotations

  lifecycle {
    create_before_destroy = true
  }
}

# Control Plane Node Pool
resource "rancher2_node_pool" "control_plane" {
  cluster_id       = rancher2_cluster.rke2_cluster.id
  name             = "${var.cluster_name}-control-plane"
  hostname_prefix  = var.control_plane_hostname_prefix
  node_template_id = var.node_template_id
  quantity         = var.control_plane_count
  control_plane    = true
  etcd             = true
  worker           = false

  lifecycle {
    create_before_destroy = true
  }
}

# Worker Node Pool
resource "rancher2_node_pool" "worker" {
  count = var.worker_count > 0 ? 1 : 0
  
  cluster_id       = rancher2_cluster.rke2_cluster.id
  name             = "${var.cluster_name}-worker"
  hostname_prefix  = var.worker_hostname_prefix
  node_template_id = var.node_template_id
  quantity         = var.worker_count
  control_plane    = false
  etcd             = false
  worker           = true

  lifecycle {
    create_before_destroy = true
  }
}

# Cluster Sync - Wait for cluster to be active
resource "rancher2_cluster_sync" "rke2_cluster_sync" {
  cluster_id = rancher2_cluster.rke2_cluster.id
  state_confirm = 2
  
  timeouts {
    create = "20m"
    update = "20m"
  }
} 
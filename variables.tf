# Rancher Configuration
variable "rancher_api_url" {
  description = "Rancher server API URL"
  type        = string
}

variable "rancher_token_key" {
  description = "Rancher API token"
  type        = string
  sensitive   = true
}

variable "rancher_insecure" {
  description = "Allow insecure connections to Rancher API"
  type        = bool
  default     = false
}

# Cluster Configuration
variable "cluster_name" {
  description = "Name of the RKE2 cluster"
  type        = string
  default     = "rke2-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version for RKE2 cluster"
  type        = string
  default     = "v1.28.8+rke2r1"
}

variable "cluster_description" {
  description = "Description for the RKE2 cluster"
  type        = string
  default     = "RKE2 cluster managed by Terraform"
}

# Node Pool Configuration
variable "control_plane_count" {
  description = "Number of control plane nodes"
  type        = number
  default     = 3
  
  validation {
    condition     = var.control_plane_count >= 1 && var.control_plane_count % 2 == 1
    error_message = "Control plane count must be an odd number and at least 1."
  }
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 7
  
  validation {
    condition     = var.worker_count >= 0
    error_message = "Worker count must be zero or positive."
  }
}

# Node Configuration
variable "node_template_id" {
  description = "Node template ID for cluster nodes"
  type        = string
}

variable "control_plane_hostname_prefix" {
  description = "Hostname prefix for control plane nodes"
  type        = string
  default     = "cp"
}

variable "worker_hostname_prefix" {
  description = "Hostname prefix for worker nodes"
  type        = string
  default     = "worker"
}

# Network Configuration
variable "cluster_cidr" {
  description = "CIDR range for cluster pods"
  type        = string
  default     = "10.42.0.0/16"
}

variable "service_cidr" {
  description = "CIDR range for cluster services"
  type        = string
  default     = "10.43.0.0/16"
}

variable "cluster_dns" {
  description = "Cluster DNS service IP"
  type        = string
  default     = "10.43.0.10"
}

variable "cluster_domain" {
  description = "Cluster domain"
  type        = string
  default     = "cluster.local"
}

# Additional Configuration
variable "enable_network_policy" {
  description = "Enable network policy enforcement"
  type        = bool
  default     = false
}

variable "default_pod_security_policy_template_id" {
  description = "Default pod security policy template ID"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the cluster"
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "Labels to apply to the cluster"
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Annotations to apply to the cluster"
  type        = map(string)
  default     = {}
} 
# RKE2 Cluster Terraform Module

This Terraform configuration creates a RKE2 (Rancher Kubernetes Engine 2) cluster using the Rancher provider. It provisions a highly available Kubernetes cluster with configurable control plane and worker nodes.

## Features

- **Modular Design**: Easy to customize and extend
- **High Availability**: Supports multiple control plane nodes (odd numbers recommended)
- **Scalable**: Configurable number of worker nodes
- **Network Configuration**: Customizable CIDR ranges and DNS settings
- **Security**: Optional network policy and pod security policy support
- **Metadata Support**: Labels, annotations, and tags for resource organization

## Architecture

By default, this configuration creates:
- 3 Control Plane nodes (etcd + control plane)
- 7 Worker nodes
- Total: 10 nodes

## Prerequisites

1. **Rancher Server**: A running Rancher server instance
2. **Rancher API Token**: API token with appropriate permissions
3. **Node Template**: Pre-configured node template in Rancher for node provisioning
4. **Terraform**: Version >= 1.0
5. **Network Access**: Connectivity between Terraform execution environment and Rancher server

## Quick Start

### 1. Clone and Navigate

```bash
git clone <repository-url>
cd rancher-tf-examples
```

### 2. Configure Variables

Copy the example variables file and customize it:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your specific values:

```hcl
# Required Variables
rancher_api_url   = "https://your-rancher-server.com"
rancher_token_key = "token-xxxxx:your-api-token"
node_template_id  = "nt-xxxxx:your-node-template-id"

# Cluster Configuration
cluster_name = "my-production-cluster"
control_plane_count = 3
worker_count = 7
```

### 3. Initialize and Deploy

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply
```

### 4. Access Your Cluster

After successful deployment, get your kubeconfig:

```bash
# Output the kubeconfig to a file
terraform output -raw kube_config > kubeconfig.yaml

# Set KUBECONFIG environment variable
export KUBECONFIG=./kubeconfig.yaml

# Verify cluster access
kubectl get nodes
```

## Configuration Reference

### Required Variables

| Variable | Description | Type |
|----------|-------------|------|
| `rancher_api_url` | Rancher server API URL | string |
| `rancher_token_key` | Rancher API token | string |
| `node_template_id` | Node template ID for provisioning | string |

### Cluster Configuration

| Variable | Description | Default | Type |
|----------|-------------|---------|------|
| `cluster_name` | Name of the RKE2 cluster | `"rke2-cluster"` | string |
| `kubernetes_version` | Kubernetes version | `"v1.28.8+rke2r1"` | string |
| `cluster_description` | Cluster description | `"RKE2 cluster managed by Terraform"` | string |
| `control_plane_count` | Number of control plane nodes | `3` | number |
| `worker_count` | Number of worker nodes | `7` | number |

### Network Configuration

| Variable | Description | Default | Type |
|----------|-------------|---------|------|
| `cluster_cidr` | CIDR range for pods | `"10.42.0.0/16"` | string |
| `service_cidr` | CIDR range for services | `"10.43.0.0/16"` | string |
| `cluster_dns` | Cluster DNS service IP | `"10.43.0.10"` | string |
| `cluster_domain` | Cluster domain | `"cluster.local"` | string |

### Node Configuration

| Variable | Description | Default | Type |
|----------|-------------|---------|------|
| `control_plane_hostname_prefix` | Control plane hostname prefix | `"cp"` | string |
| `worker_hostname_prefix` | Worker hostname prefix | `"worker"` | string |

### Security Configuration

| Variable | Description | Default | Type |
|----------|-------------|---------|------|
| `enable_network_policy` | Enable network policy | `false` | bool |
| `default_pod_security_policy_template_id` | Pod security policy template ID | `null` | string |
| `rancher_insecure` | Allow insecure connections | `false` | bool |

## Usage Examples

### Basic 3-Node Cluster

```hcl
control_plane_count = 1
worker_count = 2
```

### Large Production Cluster

```hcl
control_plane_count = 5
worker_count = 20
kubernetes_version = "v1.29.3+rke2r1"
enable_network_policy = true
```

### Development Cluster

```hcl
control_plane_count = 1
worker_count = 1
cluster_name = "dev-cluster"
```

## Outputs

After deployment, the following outputs are available:

- `cluster_id`: Cluster ID
- `cluster_name`: Cluster name
- `cluster_state`: Cluster state
- `kube_config`: Kubeconfig for cluster access (sensitive)
- `cluster_endpoint`: Cluster API endpoint
- `total_nodes`: Total number of nodes

### Accessing Outputs

```bash
# List all outputs
terraform output

# Get specific output
terraform output cluster_id

# Get sensitive output
terraform output -raw kube_config
```

## Node Templates

Before using this module, you need to create a node template in Rancher. Node templates define:

- Cloud provider settings
- Instance specifications (CPU, memory, disk)
- Operating system configuration
- Network settings
- Security groups/firewalls

### Creating a Node Template

1. Log into Rancher UI
2. Go to **User Settings** → **Node Templates**
3. Click **Add Template**
4. Configure your cloud provider settings
5. Save and note the template ID

## Troubleshooting

### Common Issues

1. **Authentication Errors**
   ```bash
   # Verify your token
   curl -k -H "Authorization: Bearer $RANCHER_TOKEN" "$RANCHER_URL/v3/clusters"
   ```

2. **Node Template Not Found**
   - Verify the node template ID exists
   - Ensure the template is in the correct Rancher project

3. **Cluster Stuck in Provisioning**
   - Check Rancher logs
   - Verify cloud provider credentials in node template
   - Ensure network connectivity between nodes

4. **Network Connectivity Issues**
   - Verify CIDR ranges don't conflict
   - Check security groups/firewall rules
   - Ensure DNS resolution works

### Logging

Enable Terraform debugging:

```bash
export TF_LOG=DEBUG
terraform apply
```

### Cleanup

To destroy the cluster:

```bash
terraform destroy
```

**Warning**: This will permanently delete your cluster and all data.

## Advanced Configuration

### Custom Labels and Annotations

```hcl
labels = {
  environment = "production"
  team        = "platform"
  cost-center = "engineering"
}

annotations = {
  "cluster.example.com/owner" = "platform-team"
  "cluster.example.com/backup" = "enabled"
}
```

### Network Policies

```hcl
enable_network_policy = true
# Requires a CNI that supports network policies (Calico, etc.)
```

### Pod Security Policies

```hcl
default_pod_security_policy_template_id = "your-psp-template-id"
```

## Best Practices

1. **Control Plane Nodes**: Always use odd numbers (1, 3, 5) for HA
2. **Resource Planning**: Ensure adequate resources for your workload
3. **Backup Strategy**: Implement etcd backup procedures
4. **Monitoring**: Set up cluster monitoring and alerting
5. **Security**: Enable network policies and pod security policies
6. **Updates**: Plan for regular Kubernetes version updates

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:

1. Check the troubleshooting section
2. Review Rancher documentation
3. Open an issue in this repository
4. Contact your platform team

## Version Compatibility

| Terraform | Rancher Provider | Rancher Server | Kubernetes |
|-----------|------------------|----------------|------------|
| >= 1.0    | ~> 3.0          | >= 2.6         | 1.25-1.29  | 
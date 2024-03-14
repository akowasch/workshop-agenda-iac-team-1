<!-- markdownlint-disable MD012 -->
<!-- markdownlint-disable MD033 -->
# Cluster Module

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_role_assignment.cluster_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.kubelet_identity_acr_pull](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_subscription.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_container_registry_id"></a> [azure\_container\_registry\_id](#input\_azure\_container\_registry\_id) | The id of the container registry to link to the cluster. | `string` | n/a | yes |
| <a name="input_infix"></a> [infix](#input\_infix) | The infix to use for naming all resources. | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The version of Kubernetes to use for the cluster. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the scope for all resources. | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | The resource group in which to create all resources. | <pre>object({<br>    name     = string<br>    location = string<br>    id       = string<br>  })</pre> | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The ids of the subnets to use for the cluster. | `map(string)` | n/a | yes |
| <a name="input_api_server_authorized_ip_ranges"></a> [api\_server\_authorized\_ip\_ranges](#input\_api\_server\_authorized\_ip\_ranges) | The authorized IP ranges for the cluster API server. | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to associate with all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the kubernetes cluster. |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | The kube\_config of the kubernetes cluster. |
<!-- END_TF_DOCS -->

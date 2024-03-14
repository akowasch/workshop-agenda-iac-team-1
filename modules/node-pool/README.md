<!-- markdownlint-disable MD012 -->
<!-- markdownlint-disable MD033 -->
# Node Pool Module

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster_node_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | The cluster id for which node pools should be created. | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The version of Kubernetes to use for the cluster. | `string` | n/a | yes |
| <a name="input_max_count"></a> [max\_count](#input\_max\_count) | The maximum number of nodes for the node pool. | `number` | n/a | yes |
| <a name="input_max_pods"></a> [max\_pods](#input\_max\_pods) | The maximum number of pods that can run on each node. | `number` | n/a | yes |
| <a name="input_min_count"></a> [min\_count](#input\_min\_count) | The minimum number of nodes for the node pool. | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the scope for all resources. | `string` | n/a | yes |
| <a name="input_node_taints"></a> [node\_taints](#input\_node\_taints) | Any taints to be set on the nodes. | `map(string)` | n/a | yes |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb) | The size of the OS disk in GB. | `number` | n/a | yes |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | The operating system type for the node pool. | `string` | n/a | yes |
| <a name="input_priority"></a> [priority](#input\_priority) | The priority for virtual machines of the node pool. | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | The resource group in which to create all resources. | <pre>object({<br>    name     = string<br>    location = string<br>    id       = string<br>  })</pre> | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The ids of the subnets to use for the node pool. | `map(string)` | n/a | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The size of the virtual machines to use for the node pool. | `string` | n/a | yes |
| <a name="input_node_labels"></a> [node\_labels](#input\_node\_labels) | Any labels to be set on the nodes. | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to associate with all resources. | `map(string)` | `{}` | no |
<!-- END_TF_DOCS -->

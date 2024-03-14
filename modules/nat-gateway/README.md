<!-- markdownlint-disable MD012 -->
<!-- markdownlint-disable MD033 -->
# Nat Gateway Module

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_infix"></a> [infix](#input\_infix) | The infix to use for naming all resources. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the scope for all resources. | `string` | n/a | yes |
| <a name="input_public_ip_count"></a> [public\_ip\_count](#input\_public\_ip\_count) | The number of public ip addressses to associate with the nat gateway. | `number` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | The resource group in which to create all resources. | <pre>object({<br>    name     = string<br>    location = string<br>    id       = string<br>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to associate with all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ids"></a> [ids](#output\_ids) | The ids of the nat gateways. |
| <a name="output_public_ip_addresses"></a> [public\_ip\_addresses](#output\_public\_ip\_addresses) | The public ip addresses of the nat gateways. |
<!-- END_TF_DOCS -->

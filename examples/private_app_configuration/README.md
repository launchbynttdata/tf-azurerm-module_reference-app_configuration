# private_app_configuration

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.117 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_network_resource_names"></a> [network\_resource\_names](#module\_network\_resource\_names) | git::https://github.com/launchbynttdata/tf-launch-module_library-resource_name.git | 1.0.1 |
| <a name="module_network_resource_group"></a> [network\_resource\_group](#module\_network\_resource\_group) | git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-resource_group.git | 1.1.0 |
| <a name="module_virtual_network"></a> [virtual\_network](#module\_virtual\_network) | git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-virtual_network.git | 3.0.0 |
| <a name="module_app_configuration"></a> [app\_configuration](#module\_app\_configuration) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object({<br>    name       = string<br>    max_length = optional(number, 60)<br>  }))</pre> | <pre>{<br>  "app_configuration": {<br>    "max_length": 80,<br>    "name": "appcs"<br>  },<br>  "private_endpoint": {<br>    "max_length": 80,<br>    "name": "pe"<br>  },<br>  "private_service_connection": {<br>    "max_length": 80,<br>    "name": "pesc"<br>  },<br>  "resource_group": {<br>    "max_length": 80,<br>    "name": "rg"<br>  }<br>}</pre> | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"redis"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | (Required) Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | `"dev"` | no |
| <a name="input_location"></a> [location](#input\_location) | target resource group resource mask | `string` | `"eastus"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Custom tags for the deployment | `map(string)` | `{}` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | The address space to deploy a virtual network with | `list(string)` | <pre>[<br>  "10.1.0.0/24"<br>]</pre> | no |
| <a name="input_customer_managed_encryption_key"></a> [customer\_managed\_encryption\_key](#input\_customer\_managed\_encryption\_key) | The customer managed encryption key configuration<br>    Requires a user assigned identity with read access to the desired key.<br>    The user assigned identity must be provided in the `identity_ids` variable. | <pre>object({<br>    key_vault_key_id   = string<br>    identity_client_id = string<br>  })</pre> | `null` | no |
| <a name="input_local_auth_enabled"></a> [local\_auth\_enabled](#input\_local\_auth\_enabled) | Whether local authentication methods is enabled. | `bool` | `true` | no |
| <a name="input_public_network_access"></a> [public\_network\_access](#input\_public\_network\_access) | Whether public network access is enabled. Possible values are 'Enabled' and 'Disabled'. | `string` | `"Disabled"` | no |
| <a name="input_purge_protection_enabled"></a> [purge\_protection\_enabled](#input\_purge\_protection\_enabled) | Whether purge protection is enabled. | `bool` | `false` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Locations to replicate the App configuration store | `map(string)` | `null` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The SKU of the App Configuration. Possible values are 'free' and 'standard'. | `string` | `"standard"` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | The number of days that items should be retained for once soft-deleted. | `number` | `7` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | Specifies a list of user managed identity ids to be assigned. | `list(string)` | `null` | no |
| <a name="input_private_dns_zone_suffix"></a> [private\_dns\_zone\_suffix](#input\_private\_dns\_zone\_suffix) | The DNS Zone suffix for Azure Redis cache. Default is `privatelink.azconfig.io` for Public Cloud<br>    For US gov cloud it should be `privatelink.azconfig.azure.us` | `string` | `"privatelink.azconfig.io"` | no |
| <a name="input_additional_vnet_links"></a> [additional\_vnet\_links](#input\_additional\_vnet\_links) | A map of names to VNET IDs to create links with the private redis cache DNS Zone<br>    Applicable only when `public_network_access` is set to 'Disabled' | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

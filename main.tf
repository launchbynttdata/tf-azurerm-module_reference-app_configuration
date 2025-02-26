// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.0"

  for_each = var.resource_names_map

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  region                  = var.location
  class_env               = var.class_env
  cloud_resource_type     = each.value.name
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  maximum_length          = each.value.max_length
  use_azure_region_abbr   = var.use_azure_region_abbr
}

module "resource_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm"
  version = "~> 1.1"

  count = var.resource_group_name != null ? 0 : 1

  name     = module.resource_names["resource_group"].standard
  location = var.location

  tags = merge(var.tags, { resource_name = module.resource_names["resource_group"].standard })
}

module "app_configuration" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/app_configuration/azurerm"
  version = "~> 1.0"

  name                = module.resource_names["app_configuration"].standard
  resource_group_name = var.resource_group_name != null ? var.resource_group_name : module.resource_group[0].name
  location            = var.location

  sku = var.sku

  customer_managed_encryption_key = var.customer_managed_encryption_key
  identity_ids                    = var.identity_ids
  local_auth_enabled              = var.local_auth_enabled
  public_network_access           = var.public_network_access
  purge_protection_enabled        = var.purge_protection_enabled
  replicas                        = var.replicas
  soft_delete_retention_days      = var.soft_delete_retention_days

  tags = merge(var.tags, { resource_name = module.resource_names["app_configuration"].standard })

  depends_on = [module.resource_group]
}

module "app_configuration_data" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/app_configuration_data/azurerm"
  version = "~> 1.0"

  configuration_store_id = module.app_configuration.app_configuration_id
  keys                   = var.keys
  features               = var.features

}

module "private_endpoint" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/private_endpoint/azurerm"
  version = "~> 1.0"

  count = local.enable_public_network_access ? 0 : 1

  region                          = var.location
  endpoint_name                   = module.resource_names["private_endpoint"].standard
  is_manual_connection            = false
  resource_group_name             = var.resource_group_name != null ? var.resource_group_name : module.resource_group[0].name
  private_service_connection_name = module.resource_names["private_service_connection"].standard
  private_connection_resource_id  = module.app_configuration.app_configuration_id
  subresource_names               = ["configurationStores"]
  subnet_id                       = var.private_endpoint_subnet_id
  private_dns_zone_ids            = var.private_dns_zone_ids
  private_dns_zone_group_name     = "configurationStores"

  tags = merge(var.tags, { resource_name = module.resource_names["private_endpoint"].standard })

  depends_on = [module.resource_group, module.app_configuration]
}

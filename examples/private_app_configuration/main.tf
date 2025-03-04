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

  for_each = {
    resource_group = {
      name       = "rg"
      max_length = 80
    }
    virtual_network = {
      name       = "vnet"
      max_length = 80
    }
  }

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  region                  = var.location
  class_env               = var.class_env
  cloud_resource_type     = each.value.name
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  maximum_length          = each.value.max_length
}

module "resource_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm"
  version = "~> 1.1"

  name     = module.resource_names["resource_group"].minimal_random_suffix
  location = var.location
  tags     = var.tags
}

module "private_dns_zone" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/private_dns_zone/azurerm"
  version = "~> 1.0"

  zone_name           = var.private_dns_zone_suffix
  resource_group_name = module.resource_group.name

  tags = var.tags

  depends_on = [module.resource_group]
}

module "virtual_network" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/virtual_network/azurerm"
  version = "~> 3.1"

  resource_group_name = module.resource_group.name

  vnet_name     = module.resource_names["virtual_network"].minimal_random_suffix
  vnet_location = var.location

  address_space = var.vnet_address_space
  subnets = {
    "private-endpoint-subnet" = {
      prefix = var.vnet_address_space[0]
    }
  }

  tags = var.tags

  depends_on = [module.resource_group]
}

module "app_configuration" {
  source = "../../"

  resource_names_map      = var.resource_names_map
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  location                = var.location
  class_env               = var.class_env
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource

  sku = var.sku

  customer_managed_encryption_key = var.customer_managed_encryption_key
  identity_ids                    = var.identity_ids
  local_auth_enabled              = var.local_auth_enabled
  public_network_access           = var.public_network_access
  purge_protection_enabled        = var.purge_protection_enabled
  replicas                        = var.replicas
  soft_delete_retention_days      = var.soft_delete_retention_days

  private_dns_zone_ids       = [module.private_dns_zone.id]
  private_endpoint_subnet_id = module.virtual_network.subnet_map["private-endpoint-subnet"].id

  keys     = var.keys
  features = var.features

  tags = var.tags

  depends_on = [module.virtual_network]
}

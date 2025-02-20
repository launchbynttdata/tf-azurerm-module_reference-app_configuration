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

# COMMON

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object({
    name       = string
    max_length = optional(number, 60)
  }))

  default = {
    resource_group = {
      name       = "rg"
      max_length = 80
    }
    app_configuration = {
      name       = "appcs"
      max_length = 80
    }
    key_vault = {
      name       = "kv"
      max_length = 24
    }
    private_endpoint = {
      name       = "pe"
      max_length = 80
    }
    private_service_connection = {
      name       = "pesc"
      max_length = 80
    }
  }
}

variable "instance_env" {
  type        = number
  description = "Number that represents the instance of the environment."
  default     = 0

  validation {
    condition     = var.instance_env >= 0 && var.instance_env <= 999
    error_message = "Instance number should be between 0 to 999."
  }
}

variable "instance_resource" {
  type        = number
  description = "Number that represents the instance of the resource."
  default     = 0

  validation {
    condition     = var.instance_resource >= 0 && var.instance_resource <= 100
    error_message = "Instance number should be between 0 to 100."
  }
}

variable "logical_product_family" {
  type        = string
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_family))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "launch"
}

variable "logical_product_service" {
  type        = string
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_service))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "appcs"
}

variable "class_env" {
  type        = string
  description = "(Required) Environment where resource is going to be deployed. For example. dev, qa, uat"
  nullable    = false
  default     = "dev"

  validation {
    condition     = length(regexall("\\b \\b", var.class_env)) == 0
    error_message = "Spaces between the words are not allowed."
  }
}

variable "location" {
  description = "target resource group resource mask"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = null
}

variable "use_azure_region_abbr" {
  description = "Use Azure region abbreviation in resource names"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Custom tags for the deployment"
  type        = map(string)
  default     = {}
}

# App configuration store

variable "customer_managed_encryption_key" {
  description = <<EOF
    The customer managed encryption key configuration
    Requires a user assigned identity with read access to the desired key.
    The user assigned identity must be provided in the `identity_ids` variable.
  EOF
  type = object({
    key_vault_key_id   = string
    identity_client_id = string
  })
  default = null
}

variable "local_auth_enabled" {
  description = "Whether local authentication methods is enabled."
  type        = bool
  default     = true
}

variable "public_network_access" {
  description = "Whether public network access is enabled. Possible values are 'Enabled' and 'Disabled'."
  type        = string
  default     = "Enabled"
}

variable "purge_protection_enabled" {
  description = "Whether purge protection is enabled."
  type        = bool
  default     = false
}

variable "replicas" {
  description = "Locations to replicate the App configuration store"
  type        = map(string)
  default     = null
}

variable "sku" {
  description = "The SKU of the App Configuration. Possible values are 'free' and 'standard'."
  type        = string
  default     = "free"
}

variable "soft_delete_retention_days" {
  description = "The number of days that items should be retained for once soft-deleted."
  type        = number
  default     = 7
}

variable "identity_ids" {
  description = <<EOT
    Specifies a list of user managed identity ids to be assigned.
  EOT
  type        = list(string)
  default     = null
}

# app configuration data

variable "keys" {
  description = <<EOF
    map(object({
      content_type        = content type of the configuration key
      label               = label (partition) of the app configuration store
      value               = value of the configuration key
      locked              = whether the key is locked to prevent changes
      type                = type of the configuration key, `kv` or `vault` (key vault reference)
      vault_key_reference = id of the vault secret this key refers to
      tags                = custom tags to assign
    }))
  EOF
  type = map(object({
    content_type        = optional(string)
    label               = optional(string)
    value               = optional(string)
    locked              = optional(bool)
    type                = optional(string)
    vault_key_reference = optional(string)
    tags                = optional(map(string))
  }))
  default = {}
}

variable "features" {
  description = <<EOF
    map(object({
      name        = name of the feature flag
      description = description of the feature
      enabled     = status of the feature, defaults to false
      label       = label (partition) of the app configuration store
      locked      = whether the feature is locked to prevent changes

      targeting_filter = optional(object({
        default_rollout_percentage = default percentage of the user base for which to enable the feature
        groups                     = map of groups and their rollout percentages (groups defined in the application logic)
        users                      = list of users to target (users defined in the application logic)
      }))

      timewindow_filter = optional(object({
        start = the earliest timestamp the feature is enabled, RFC3339 format
        end   = the latest timestamp the feature is enabled, RFC3339 format
      }))
    }))
  EOF
  type = map(object({
    name        = string
    description = optional(string)
    enabled     = optional(bool)
    label       = optional(string)
    locked      = optional(bool)

    targeting_filter = optional(object({
      default_rollout_percentage = number
      groups                     = optional(map(number))
      users                      = optional(list(string))
    }))

    timewindow_filter = optional(object({
      start = optional(string)
      end   = optional(string)
    }))
  }))
  default = {}
}


# variables to configure private DNS zone

variable "private_dns_zone_suffix" {
  description = <<EOT
    The DNS Zone suffix. Default is `privatelink.azconfig.io` for Public Cloud
    For US gov cloud it should be `privatelink.azconfig.azure.us`
  EOT
  type        = string
  default     = "privatelink.azconfig.io"
}

variable "additional_vnet_links" {
  description = <<EOF
    A map of names to VNET IDs to create links to a resource and only available
    when `public_network_access` is set to 'Disabled'
  EOF
  type        = map(string)
  default     = {}
}

# variables to configure private endpoint

variable "private_endpoint_subnet_id" {
  description = <<EOF
    ID of the subnet where the private endpoint should be deployed
    Required when `public_network_access` is set to 'Disabled'
  EOF
  type        = string
  default     = null
}

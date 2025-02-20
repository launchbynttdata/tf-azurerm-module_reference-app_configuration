resource_names_map = {
  resource_group = {
    name       = "rg"
    max_length = 80
  }
  app_configuration = {
    name       = "appcs"
    max_length = 80
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
instance_env            = 0
instance_resource       = 0
logical_product_family  = "launch"
logical_product_service = "appcs"
class_env               = "gotest"
location                = "eastus"

keys = {
  test-config-key = {
    value = "Hello, World!"
  }
}

features = {}

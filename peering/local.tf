locals {
  resource_group_name = "learning"
  location            = "eastus"
  environment = {
    stage = "10.0.0.0/16"
    test  = "10.1.0.0/16"
  }
}
locals {
  resource_group_name = "learning"
  location            = "eastus"
  virtual_network = {
    address_space = "10.0.0.0/16"
  }
}
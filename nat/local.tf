locals {
  azure_resource_group = "nat"
  location            = "eastus"
  network = {
    name          = "vnet1"
    sub-name      = "sub1"
    address_space = "192.168.0.0/16"
    subnet1       = "192.168.1.0/24"
  }
}   
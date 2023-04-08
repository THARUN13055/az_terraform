locals {
  resource_grp_name = "linuxvm"
  location          = "eastus"
  networks = {
    name          = "vnet1"
    address_space = "10.0.0.0/16"
  }
}

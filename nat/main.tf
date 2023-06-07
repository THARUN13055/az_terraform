module "general" {
  source = "./module/general"

  azure_resource_group = local.azure_resource_group
  location             = local.location
}

module "networks" {
  source = "./module/network"

  azure_resource_group = local.azure_resource_group
  location             = local.location
  publicip_name        = "nat-publicip"
  nat-gateway-name     = "nat-gateway"
}

module "machine" {
  source = "./module/machine"

  azure_resource_group = local.azure_resource_group
  location             = local.location
  vnet-name            = local.network.name
  sub-name             = local.network.sub-name
  address_space        = local.network.address_space
  subnet_address       = local.network.subnet1
  nic-name             = "nat-nic-card"
  vm-name              = "nat-vm"
  vm-size              = "Standard_B1s"
  admin_username       = "tharun"
  admin_password       = "@Password1234567"
  nat_gateway_id       = module.networks.nat-gateway.id
}
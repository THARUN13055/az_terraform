module "general_module" {
  source              = "./modules/general"
  resource_group_name = local.resource_group_name
  location            = local.location
}

module "networking_module" {
  source               = "./modules/network"
  resource_group_name  = local.resource_group_name
  location             = local.location
  virtual_network_name = "vnet"
  address_space        = "10.0.0.0/16"
  subnet_name          = ["web-subnet1", "db-subnet2"]
  bastion_host_name    = "bastion"
  bastion_required     = true
  network-security_group_names = {
    "web-nsg" = "web-subnet1"
    "db-nsg"  = "db-subnet2"
  }
  network_security_group_rules = [
    // this is connect to the db server vm
    {
      id                          = 1,
      priority                    = "200",
      network_security_group_name = "web-nsg"
      destination_port_range      = "22"
      access                      = "Allow"
      name                        = "ssh"
    },
    // this under all connect to web-subnet
    {
      id                          = 2,
      priority                    = "300",
      network_security_group_name = "web-nsg"
      destination_port_range      = "80"
      access                      = "Allow"
      name                        = "http"
    },
    {
      id                          = 3,
      priority                    = "400",
      network_security_group_name = "web-nsg"
      destination_port_range      = "8172"
      access                      = "Allow"
      name                        = "webport"
    },
    {
      id                          = 4,
      priority                    = "500",
      network_security_group_name = "db-nsg"
      destination_port_range      = "3389"
      access                      = "Allow"
      name                        = "dbport"
    }
  ]
}


module "compute_module" {
  source                        = "./modules/compute"
  network_interface_name = "db-interface"
  resource_group_name           = local.resource_group_name
  location                      = local.location
  subnet_id                     = module.networking_module.vsubnet["db-subnet2"].id
  
  depends_on = [
    module.networking_module
  ]
}
module "general" {
  source            = "./module/general"
  resource_grp_name = local.resource_grp_name
  location          = local.location
}
/*
module "linuxvm" {
  source               = "./module/vm"
  resource_group_name  = local.resource_grp_name
  location             = local.location
  name                 = "tharun"
  size                 = "Standard_B1s"
  admin_username       = "linux"
  password             = "@pass1234567"
  sku                  = "22.04-LTS"
  storage_account_type = "Standard_LRS"
  disk_name            = "disk1"
  disk_size            = "30"
}
*/
module "networks" {
  source              = "./module/network"
  resource_group_name = local.resource_grp_name
  location            = local.location
  net_name            = local.networks.name
  address_space       = local.networks.address_space
  // subnet
  subnet_name = ["subnet1", "subnet2"]
  // network interface
  ip_configuration_name         = "internal"
  private_ip_address_allocation = "Static"
  // public_ip
  public_ip_sku = "Standard"
  // network security group
  nsg_name = {
    "nsg-sub1" = "subnet1"
    "nsg-sub2" = "subnet2"
  }
  // network security group rules
  network_security_rule = [
    {
      id                     = 1,
      priority               = 200,
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "80"
      sgn                    = "nsg-sub1"
      name                   = "http"
    },
    {
      id                     = 2,
      priority               = 300,
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "22"
      name                   = "ssh"
      sgn                    = "nsg-sub1"
    },
    {
      id                     = 3,
      priority               = 200,
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "80"
      sgn                    = "nsg-sub2"
      name                   = "http"
    },
    {
      id                     = 4,
      priority               = 300,
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "22"
      name                   = "ssh"
      sgn                    = "nsg-sub2"
    }
  ]
}

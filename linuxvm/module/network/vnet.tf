module "general" {
  source            = ".././general"
  resource_grp_name = var.resource_group_name
  location          = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.net_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.address_space]
  depends_on = [
    module.general
  ]
}

resource "azurerm_subnet" "vsubnets" {
  for_each             = var.subnet_name
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.net_name
  address_prefixes     = [cidrsubnet(var.address_space, 8, index(tolist(var.subnet_name), each.value))]
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_network_interface" "v_nic" {
  for_each             = var.subnet_name
  name                 = "nic-${each.key}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = azurerm_subnet.vsubnets[each.key].id
    private_ip_address_allocation = var.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.vpublic_ip[each.key].id
  }

}


resource "azurerm_public_ip" "vpublic_ip" {
  for_each            = var.subnet_name
  name                = "public-ip-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = var.public_ip_sku
}


resource "azurerm_network_security_group" "az_nsg" {
  for_each            = var.nsg_name
  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_network_security_rule" "nsg_rule" {
  for_each                    = { for rule in var.network_security_rule : rule.id => rule }
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = "Outbound"
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.az_nsg[each.value.sgn].name

}

resource "azurerm_network_interface_security_group_association" "nisga" {
  for_each                  = var.nsg_name
  network_interface_id      = azurerm_network_interface.v_nic[each.value].id
  network_security_group_id = azurerm_network_security_group.az_nsg[each.key].id
}
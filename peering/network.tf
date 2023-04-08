
resource "azurerm_virtual_network" "vnet" {
  for_each            = local.environment
  name                = "${each.key}az-vnet"
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = [each.value]
  depends_on = [
    azurerm_resource_group.azrsgp
  ]

  subnet {
    name           = "${each.key}subnet1"
    address_prefix = cidrsubnet(each.value, 8, 0)
  }

}

resource "azurerm_network_security_group" "securitygroup" {
  for_each            = local.environment
  name                = "${each.key}-nsg"
  location            = local.location
  resource_group_name = local.resource_group_name

  security_rule {
    name                       = "http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "ssh"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_subnet_network_security_group_association" "subgrp" {
  for_each                  = local.environment
  subnet_id                 = azurerm_virtual_network.vnet[each.key].subnet.*.id[0]
  network_security_group_id = azurerm_network_security_group.securitygroup[each.key].id

  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_network_security_group.securitygroup
  ]
}
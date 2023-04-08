
resource "azurerm_resource_group" "learning" {

  name     = "learning"
  location = "eastus"

}
resource "azurerm_network_security_group" "aznsecgrp" {

  name                = "azure-network-secgrp"
  location            = azurerm_resource_group.learning.location
  resource_group_name = azurerm_resource_group.learning.name

  dynamic "security_rule" {
    for_each = local.networksecuritygrp
    content {
      name                       = "Allow-${security_rule.value.destination_port_range}"
      protocol                   = "Tcp"
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      access                     = "Allow"
      source_address_prefix      = "*"
      destination_address_prefix = "*"

    }
  }

}

locals {
  networksecuritygrp = [
    {
      priority               = 200
      destination_port_range = "22"
    },
    {
      priority               = 300
      destination_port_range = "8080"
    }
  ]
}



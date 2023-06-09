module "general" {
  source               = ".././general"
  azure_resource_group = var.azure_resource_group
  location             = var.location
}

resource "azurerm_virtual_network" "vnet1" {
  name                = var.vnet-name
  address_space       = [var.address_space]
  location            = var.location
  resource_group_name = var.azure_resource_group
}

resource "azurerm_subnet" "sub1" {
  name                 = var.sub-name
  resource_group_name  = var.azure_resource_group
  virtual_network_name = var.vnet-name
  address_prefixes     = [var.subnet_address]
}

resource "azurerm_subnet_nat_gateway_association" "example" {
  subnet_id      = azurerm_subnet.sub1.id
  nat_gateway_id = var.nat_gateway_id
}

resource "azurerm_network_interface" "n-interface" {
  name                = var.nic-name
  location            = var.location
  resource_group_name = var.azure_resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.security_group_name
  location            = var.location
  resource_group_name = var.azure_resource_group
}

resource "azurerm_network_security_rule" "nsr" {
  for_each                    = { for rule in var.network_security_rule : rule.id => rule }
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.azure_resource_group
  network_security_group_name = azurerm_network_security_group.nsg.name
  depends_on = [
    azurerm_network_security_group.nsg
  ]
}

resource "azurerm_subnet_network_security_group_association" "subsecurityasso" {
  subnet_id                 = azurerm_subnet.sub1.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.vm-name
  resource_group_name = var.azure_resource_group
  location            = var.location
  size                = var.vm-size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.n-interface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

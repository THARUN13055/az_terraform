
resource "azurerm_network_interface" "dbinterface" {
  name                = "dbinterface"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    public_ip_address_id          = try(azurerm_public_ip.db-public[0].id, null)
  }
   depends_on = [    
    azurerm_public_ip.db-public
  ]
}

resource "azurerm_public_ip" "db-public" {
  count               = var.public_ip_required ? 1 : 0
  name                = "app-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

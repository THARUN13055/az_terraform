module "general" {
  source               = ".././general"
  azure_resource_group = var.azure_resource_group
  location             = var.location
}

resource "azurerm_public_ip" "nat-publicip" {
  name                = var.publicip_name
  location            = var.location
  resource_group_name = var.azure_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

resource "azurerm_nat_gateway" "nat-gateway" {
  name                    = var.nat-gateway-name
  location                = var.location
  resource_group_name     = var.azure_resource_group
  sku_name                = "Standard"
  idle_timeout_in_minutes = 5
  zones                   = ["1"]
}

output "nat_gateway_id" {
  value = azurerm_nat_gateway.nat-gateway.id
}

resource "azurerm_nat_gateway_public_ip_association" "nat-public-ip-association" {
  nat_gateway_id       = azurerm_nat_gateway.nat-gateway.id
  public_ip_address_id = azurerm_public_ip.nat-publicip.id
}
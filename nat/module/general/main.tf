resource "azurerm_resource_group" "rsgp" {
  name     = var.azure_resource_group
  location = var.location
}
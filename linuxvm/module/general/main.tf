resource "azurerm_resource_group" "linuxrsg" {
  name     = var.resource_grp_name
  location = var.location
}
resource "azurerm_resource_group" "azrsgp" {

  name     = local.azurerm_resource_group
  location = "eastus"
}
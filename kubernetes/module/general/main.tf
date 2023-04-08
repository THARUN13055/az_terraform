resource "azurerm_resource_group" "kubernetesrsgp" {
  name     = var.resource_group_name
  location = var.location
}
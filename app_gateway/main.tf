resource "azurerm_resource_group" "azrsgp" {
    name = local.resource_group_name
    location = local.location
}
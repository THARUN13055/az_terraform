resource "azurerm_virtual_network_peering" "azpeering1" {
  for_each                  = local.environment
  name                      = "stagetotest"
  resource_group_name       = local.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet["stage"].name
  remote_virtual_network_id = azurerm_virtual_network.vnet["test"].id
}


resource "azurerm_virtual_network_peering" "azpeering2" {
  for_each                  = local.environment
  name                      = "testtostage"
  resource_group_name       = local.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet["test"].name
  remote_virtual_network_id = azurerm_virtual_network.vnet["stage"].id
}
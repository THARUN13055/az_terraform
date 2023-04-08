resource "azurerm_management_lock" "resourcelock" {
  name       = "resourcelock"
  scope      = azurerm_resource_group.resourcegroup.id
  lock_level = "CanNotDelete"
  notes      = "Items can't be deleted in this subscription!"
}
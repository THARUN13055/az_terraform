/*resource "azurerm_log_analytics_workspace" "logworkspace" {
  name                = "log-analytics-workspace"
  location            = azurerm_resource_group.learning.location
  resource_group_name = azurerm_resource_group.learning.name
  sku                 = "Standard"
  retention_in_days   = 30
  depends_on = [
    azurerm_resource_group.learning
  ]
}
*/
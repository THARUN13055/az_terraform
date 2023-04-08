resource "azurerm_log_analytics_workspace" "azloganaworkspace" {
  name                = "workspace-test"
  location            = azurerm_resource_group.azrsgrp.location
  resource_group_name = azurerm_resource_group.azrsgrp.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "azappinsights" {
  name                = "tf-test-appinsights"
  location            = azurerm_resource_group.azrsgrp.location
  resource_group_name = azurerm_resource_group.azrsgrp.name
  workspace_id        = azurerm_log_analytics_workspace.azloganaworkspace.id
  application_type    = "web"
  depends_on = [
    azurerm_log_analytics_workspace.azloganaworkspace
  ]
}

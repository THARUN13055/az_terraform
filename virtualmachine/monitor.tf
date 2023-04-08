
resource "azurerm_log_analytics_workspace" "azlog" {
  name                = "workspace-01"
  location            = azurerm_resource_group.learning.location
  resource_group_name = azurerm_resource_group.learning.name
}

resource "azurerm_monitor_action_group" "monitoraction" {
  name                = "CriticalAlertsAction"
  resource_group_name = azurerm_resource_group.learning.name
  short_name          = "emailreciver"


  email_receiver {
    name          = "learncloud"
    email_address = "learncloud13055@gmail.com"
  }

}

resource "azurerm_monitor_activity_log_alert" "main" {
  name                = "example-activitylogalert"
  resource_group_name = azurerm_resource_group.learning.name
  scopes              = [azurerm_resource_group.learning.id]
  description         = "This alert will monitor a specific storage account updates."

  criteria {
    resource_id    = azurerm_virtual_machine.azvm.id
    operation_name = "Microsoft.Compute/virtualmachines/delete"
    category       = "Administrative"
  }

  action {
    action_group_id = azurerm_monitor_action_group.monitoraction.id

  }
}

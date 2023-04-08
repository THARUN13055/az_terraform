resource "azurerm_log_analytics_workspace" "azloganalytics" {
  name                = "analyticworkspace"
  location            = azurerm_resource_group.azrsgp.location
  resource_group_name = azurerm_resource_group.azrsgp.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_mssql_database_extended_auditing_policy" "azauditing" {
  database_id            = azurerm_mssql_database.mysqldb.id
  log_monitoring_enabled = true
  depends_on = [
    azurerm_log_analytics_workspace.azloganalytics
  ]

}


resource "azurerm_monitor_diagnostic_setting" "azdiagnostic" {
  name                       = "${azurerm_mssql_database.mysqldb.name}-settings"
  target_resource_id         = azurerm_mssql_database.mysqldb.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.azloganalytics.id

  enabled_log {
    category = "SQLSecurityAuditEvents"
    retention_policy {
      enabled = true
    }
  }

}
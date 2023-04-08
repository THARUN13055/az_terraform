resource "azurerm_traffic_manager_profile" "trafficmanagerprofile" {
  name                   = "trafficmanager4321"
  resource_group_name    = local.azurerm_resource_group
  traffic_routing_method = "Priority"

  dns_config {
    relative_name = "trafficmanager4321"
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTPS"
    port                         = 443
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }
  depends_on = [
    azurerm_resource_group.azrsgp
  ]

}

resource "azurerm_traffic_manager_azure_endpoint" "primary" {
  name               = "primary"
  profile_id         = azurerm_traffic_manager_profile.trafficmanagerprofile.id
  priority           = 1
  weight             = 100
  target_resource_id = azurerm_windows_web_app.windowsprimary.id

  custom_header {
    name = "host"
    value = "${azurerm_windows_web_app.windowsprimary.name}.azurewebsites.net"

  }

}

resource "azurerm_traffic_manager_azure_endpoint" "secondary" {
  name               = "secondary"
  profile_id         = azurerm_traffic_manager_profile.trafficmanagerprofile.id
  priority           = 2
  weight             = 100
  target_resource_id = azurerm_windows_web_app.windowssecondary.id

  custom_header {
    name = "host"
    value = "${azurerm_windows_web_app.windowssecondary.name}.azurewebsites.net"

  }

}

resource "azurerm_app_service_custom_hostname_binding" "primary" {
  hostname            = "${azurerm_traffic_manager_profile.trafficmanagerprofile.fqdn}"
  app_service_name    = azurerm_windows_web_app.windowsprimary.name
  resource_group_name = local.azurerm_resource_group
  depends_on = [
    azurerm_traffic_manager_azure_endpoint.primary
  ]
}



resource "azurerm_service_plan" "appserviceplan" {
  name                = "azureappserviceplan"
  location            = "eastus"
  resource_group_name = local.azurerm_resource_group
  os_type             = "Windows"
  sku_name            = "S1"
  depends_on = [
    azurerm_resource_group.azrsgp
  ]
}

resource "azurerm_windows_web_app" "windowsprimary" {
  name                = "dotnetapp4201"
  resource_group_name = local.azurerm_resource_group
  location            = "eastus"
  service_plan_id     = azurerm_service_plan.appserviceplan.id

  site_config {
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
    }
  }
  depends_on = [
    azurerm_service_plan.appserviceplan
  ]
}



resource "azurerm_service_plan" "appserviceplan1" {
  name                = "azureappserviceplan1"
  location            = "centralus"
  resource_group_name = local.azurerm_resource_group
  os_type             = "Windows"
  sku_name            = "S1"
  depends_on = [
    azurerm_resource_group.azrsgp
  ]
}


resource "azurerm_windows_web_app" "windowssecondary" {
  name                = "dotnetapp42012"
  resource_group_name = local.azurerm_resource_group
  location            = "centralus"
  service_plan_id     = azurerm_service_plan.appserviceplan1.id

  site_config {
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
    }
  }
  depends_on = [
    azurerm_service_plan.appserviceplan1
  ]
}
//Creating Resource Group

resource "azurerm_resource_group" "azrsgrp" {

  name     = "learning"
  location = "eastus"

}

// Creating webapp service plan

resource "azurerm_service_plan" "azserviceplan" {

  name                = "dotnetsappservice"
  location            = azurerm_resource_group.azrsgrp.location
  resource_group_name = azurerm_resource_group.azrsgrp.name
  os_type             = "Windows"
  sku_name            = "B1"
  depends_on = [
    azurerm_resource_group.azrsgrp
  ]

}

// Creating the Linux web app

resource "azurerm_windows_web_app" "azlinuxwebapp" {
  name                = "windowsapplication4321"
  resource_group_name = azurerm_resource_group.azrsgrp.name
  location            = azurerm_resource_group.azrsgrp.location
  service_plan_id     = azurerm_service_plan.azserviceplan.id

  site_config {
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
    }
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"   = azurerm_application_insights.azappinsights.instrumentation_key
    "APPLICATIONSIGHTS_CONNECT_STRING" = azurerm_application_insights.azappinsights.connection_string
  }

  depends_on = [

    azurerm_service_plan.azserviceplan
  ]
}

resource "azurerm_app_service_source_control" "example" {
  app_id                 = azurerm_windows_web_app.azlinuxwebapp.id
  repo_url               = "https://github.com/alashro/webapp"
  branch                 = "master"
  use_manual_integration = true

}
/*
log {
  detailed_error_message = true
  http_logs {
    azure_blob_storage {
      retention_in_days = 7
      sas_url           = "https://${azurerm_storage_account.azurestorageaccount.name}.blob.core.windows.net/${azurerm_storage_container.aztoragecontainer.name}${data.azurerm_storage_account_blob_container_sas.accountsas.sas}"
    }
  }
}
*/


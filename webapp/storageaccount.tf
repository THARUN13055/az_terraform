/*
resource "azurerm_storage_account" "azurestorageaccount" {

  name                      = "devopsstorageaccount143"
  location                  = azurerm_resource_group.azrsgrp.location
  resource_group_name       = azurerm_resource_group.azrsgrp.name
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
  enable_https_traffic_only = "false"
  //public_network_access_enabled = "true"
  depends_on = [
    azurerm_resource_group.azrsgrp
  ]

}

resource "azurerm_storage_container" "azstoragecontainer" {

  name                  = "log"
  storage_account_name  = azurerm_storage_account.azurestorageaccount.name
  container_access_type = "blob"

  depends_on = [
    azurerm_storage_account.azurestorageaccount
  ]

}
data "azurerm_storage_account_blob_container_sas" "azstorageaccblobconsas" {
  connection_string = azurerm_storage_account.azurestorageaccount.primary_connection_string
  container_name    = azurerm_storage_container.azstoragecontainer.name
  https_only        = true

  start  = "2023-3-18"
  expiry = "2023-4-18"

  permissions {
    read   = true
    add    = true
    create = false
    write  = false
    delete = true
    list   = true
  }

  cache_control       = "max-age=5"
  content_disposition = "inline"
  content_encoding    = "deflate"
  content_language    = "en-US"
  content_type        = "application/json"
}

output "sas_url_query_string" {
  value     = nonsensitive("https://${azurerm_storage_account.azurestorageaccount.name}.blob.core.windows.net/${azurerm_storage_container.aztoragecontainer.name}${data.azurerm_storage_account_blob_container_sas.azstorageaccblobconsas.sas}")
}

*/
/*
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "azurekeyvault" {
  name                        = "azurekeyvault"
  location                    = azurerm_resource_group.learning.location
  resource_group_name         = azurerm_resource_group.learning.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 90
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id



    secret_permissions = [
      "Get","Set"
    ]

  }
}


resource "azurerm_key_vault_secret" "azvmsecret" {
  name         = "azvmkey"
  value        = "@pass1234567"
  key_vault_id = azurerm_key_vault.azurekeyvault.id
  depends_on = [
    azurerm_key_vault.azurekeyvault
  ]
}

*/
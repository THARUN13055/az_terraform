
resource "azurerm_resource_group" "resourcegroup" {

  name     = "storage"
  location = "eastus"
  tags = {
    "machine" = "test"
  }

}

resource "azurerm_virtual_network" "azvirtualnetwork" {

  name                = "azstorage-vn"
  address_space       = ["192.168.0.0/16"]
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

}

resource "azurerm_subnet" "azvirtualnetworksubnet" {

  name                 = "azvnsubnet"
  address_prefixes     = ["192.168.2.0/24"]
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.azvirtualnetwork.name
  service_endpoints    = ["Microsoft.Storage"]

}

resource "azurerm_storage_account_network_rules" "azstorageacntrules" {

  storage_account_id = azurerm_storage_account.azurestorageaccount.id

  default_action             = "Deny"
  ip_rules                   = ["192.168.0.0/16"]
  bypass                     = ["Metrics"]
  virtual_network_subnet_ids = [azurerm_subnet.azvirtualnetworksubnet.id]

}



resource "azurerm_storage_account" "azurestorageaccount" {

  name                      = "devopsstorageaccount143"
  location                  = azurerm_resource_group.resourcegroup.location
  resource_group_name       = azurerm_resource_group.resourcegroup.name
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
  enable_https_traffic_only = "false"
  //public_network_access_enabled = "true"
  depends_on = [
    azurerm_resource_group.resourcegroup
  ]

}

resource "azurerm_storage_container" "azstoragecontainer" {

  name                  = "samplefilestorage"
  storage_account_name  = azurerm_storage_account.azurestorageaccount.name
  container_access_type = "blob"

  depends_on = [
    azurerm_storage_account.azurestorageaccount
  ]

}

resource "azurerm_storage_blob" "azcontainerblob1" {

  name                   = "main.tf"
  storage_account_name   = azurerm_storage_account.azurestorageaccount.name
  storage_container_name = azurerm_storage_container.azstoragecontainer.name
  type                   = "Block"
  source                 = "main.tf"

  depends_on = [
    azurerm_storage_container.azstoragecontainer
  ]

}



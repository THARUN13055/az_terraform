
resource "azurerm_resource_group" "resourcegroup" {

  name     = "learning"
  location = "eastus"
  tags = {
    "machine" = "test"
  }

}
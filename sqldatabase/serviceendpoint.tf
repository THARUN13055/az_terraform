//creating the virtual netowrk
resource "azurerm_virtual_network" "azvnet" {
  name                = "azvnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.azrsgp.location
  resource_group_name = azurerm_resource_group.azrsgp.name
}

//creating the subnet

resource "azurerm_subnet" "azsubnet" {
  name                 = "mysqlssubnet"
  resource_group_name  = azurerm_resource_group.azrsgp.name
  virtual_network_name = azurerm_virtual_network.azvnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Sql"]
  depends_on = [
    azurerm_virtual_network.azvnet
  ]
}

//creating the virtual network rule

resource "azurerm_mssql_virtual_network_rule" "azvnetrule" {
  name      = "mysql-vnet-rule"
  server_id = azurerm_mssql_server.azmysqlserver.id
  subnet_id = azurerm_subnet.azsubnet.id
  depends_on = [
    azurerm_subnet.azsubnet
  ]

}

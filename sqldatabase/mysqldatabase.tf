
// creating the mysql server

resource "azurerm_mssql_server" "azmysqlserver" {
  name                          = "mssqlserver420"
  resource_group_name           = azurerm_resource_group.azrsgp.name
  location                      = azurerm_resource_group.azrsgp.location
  version                       = "12.0"
  administrator_login           = "tharun4321"
  administrator_login_password  = "@pass1234567"
  public_network_access_enabled = true
  depends_on = [
    azurerm_resource_group.azrsgp
  ]

  tags = {
    environment = "testing"
  }
}

//creating the mysql database

resource "azurerm_mssql_database" "mysqldb" {
  name         = "acctest-db-d"
  server_id    = azurerm_mssql_server.azmysqlserver.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "Basic"
  depends_on = [
    azurerm_mssql_server.azmysqlserver
  ]

  tags = {
    foo = "database for test"
  }
}

//Creating the firewall to allowing the database database to dbserver

resource "azurerm_mssql_firewall_rule" "mysqlfirewall" {
  name             = "firewall1"
  server_id        = azurerm_mssql_server.azmysqlserver.id
  start_ip_address = "117.213.102.134"
  end_ip_address   = "117.213.102.134"
}

resource "azurerm_public_ip" "loadip" {
  name                = "loadbalancerip"
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = "Static"
  sku                 = "Standard"
  depends_on = [
    azurerm_resource_group.appgrp
  ]
}

resource "azurerm_lb" "azlb" {
  name                = "TestLoadBalancer"
  location            = local.location
  resource_group_name = local.resource_group_name
  sku                 = "Standard"
  sku_tier            = "Regional"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.loadip.id
  }
  depends_on = [
    azurerm_public_ip.loadip
  ]
}


resource "azurerm_lb_backend_address_pool" "backendpool" {

  name               = "backendaddresspool"
  loadbalancer_id    = azurerm_lb.azlb.id
  virtual_network_id = azurerm_virtual_network.appnetwork.id
  depends_on = [
    azurerm_lb.azlb
  ]
}

resource "azurerm_lb_backend_address_pool_address" "addressvmachine" {
  count                   = var.number_of_machines
  name                    = "appvm${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backendpool.id
  virtual_network_id      = azurerm_virtual_network.appnetwork.id
  ip_address              = azurerm_network_interface.appinterface[count.index].private_ip_address

  depends_on = [
    azurerm_lb_backend_address_pool.backendpool
  ]
}

resource "azurerm_lb_probe" "healthprob" {
  loadbalancer_id = azurerm_lb.azlb.id
  name            = "windows_health"
  port            = 80
  protocol        = "Tcp"
  depends_on = [
    azurerm_lb.azlb
  ]

}

resource "azurerm_lb_rule" "example" {
  loadbalancer_id                = azurerm_lb.azlb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backendpool.id]
  depends_on = [
    azurerm_lb.azlb
  ]
}

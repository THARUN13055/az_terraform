resource "azurerm_network_interface" "webinterface" {
  name                = "web-interface"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.networking_module.vsubnet["web-subnet1"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web-public.id
  }
}

resource "azurerm_public_ip" "web-public" {
  name                = "web-public-ip"
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = "Static"
}

data "azurerm_shared_image" "webimage" {
  name                = "webimage"
  gallery_name        = "appgallery"
  resource_group_name = "web-grp"
}


resource "azurerm_virtual_machine" "web-vm" {
  name                             = "web-vm"
  location                         = local.location
  resource_group_name              = local.resource_group_name
  network_interface_ids            = [azurerm_network_interface.webinterface.id]
  vm_size                          = "Standard_B1s"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = data.azurerm_shared_image.webimage
  }
  storage_os_disk {
    name              = "web-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  depends_on = [
    azurerm_network_interface.webinterface,
    module.general_module.rsgp
  ]
}
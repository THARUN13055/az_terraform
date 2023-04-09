module "general" {
  source            = ".././general"
  resource_grp_name = var.resource_group_name
  location          = var.location
}

resource "azurerm_virtual_machine" "vmachine" {
  for_each              = var.vmname
  name                  = each.key
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = var.azurerm_network_interface
  vm_size               = var.vmsize

  delete_os_disk_on_termination = true

  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.image_sku
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.computer_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

}

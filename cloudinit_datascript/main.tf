
resource "azurerm_virtual_machine" "azvm" {

  name                = "linuxvm"
  resource_group_name = azurerm_resource_group.learning.name
  location            = azurerm_resource_group.learning.location
  vm_size             = "Standard_B1s"
  custom_data         = filebase64(data.template_file.cloudinitfile.rendered)


  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true


  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myos"
    create_option     = "FromImage"
    disk_size_gb      = "30"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"

  }

  os_profile {
    computer_name  = "linux"
    admin_username = "linux"
    admin_password = "@pass1234567"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

data "template_file" "cloudinitfile" {

  template = file("script.sh")

}


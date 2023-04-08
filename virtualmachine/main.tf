// Creating the resource group

resource "azurerm_resource_group" "learning" {

  name     = "learning12"
  location = "eastus"

}

//Creating the Security Group 

resource "azurerm_network_security_group" "aznsecgrp" {

  name                = "azure-network-secgrp"
  location            = azurerm_resource_group.learning.location
  resource_group_name = azurerm_resource_group.learning.name

  // Create the jenkins port

  security_rule {

    name                       = "jenkins"
    protocol                   = "Tcp"
    priority                   = "100"
    direction                  = "Inbound"
    source_port_range          = "*"
    destination_port_range     = "8080"
    access                     = "Allow"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }

  // Create the ssh port 

  security_rule {

    name                       = "ssh"
    protocol                   = "Tcp"
    priority                   = "400"
    direction                  = "Inbound"
    source_port_range          = "*"
    destination_port_range     = "22"
    access                     = "Allow"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }


}

//creating the azure virtual network

resource "azurerm_virtual_network" "azvn1" {

  name                = "azvn1"
  location            = azurerm_resource_group.learning.location
  resource_group_name = azurerm_resource_group.learning.name
  address_space       = ["192.168.0.0/16"]

  tags = {
    name = "testing network"
  }


}

//creating the azure subnet depends on virtual netowork

resource "azurerm_subnet" "subnet1" {

  name                 = "sub1"
  resource_group_name  = azurerm_resource_group.learning.name
  virtual_network_name = azurerm_virtual_network.azvn1.name
  address_prefixes     = ["192.168.1.0/24"]



}

// creating the network interface card which the network connect internally 

resource "azurerm_network_interface" "aznetinterface" {

  name                = "aznetwork-interface"
  location            = azurerm_resource_group.learning.location
  resource_group_name = azurerm_resource_group.learning.name


  ip_configuration {

    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }



}

resource "azurerm_network_interface_security_group_association" "interfaceallocation" {

  network_interface_id      = azurerm_network_interface.aznetinterface.id
  network_security_group_id = azurerm_network_security_group.aznsecgrp.id

}

// creating the public ip address statically in sku of basic

resource "azurerm_public_ip" "publicip" {

  name                = "publicipaddress"
  location            = azurerm_resource_group.learning.location
  resource_group_name = azurerm_resource_group.learning.name
  allocation_method   = "Static"
  sku                 = "Basic"


}

// creating the virtual machine based on ubuntu 22.04

resource "azurerm_virtual_machine" "azvm" {

  name                  = "linuxvm"
  resource_group_name   = azurerm_resource_group.learning.name
  location              = azurerm_resource_group.learning.location
  network_interface_ids = [azurerm_network_interface.aznetinterface.id]
  vm_size               = "Standard_B1s"


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


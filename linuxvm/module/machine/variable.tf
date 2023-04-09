variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vmname" {
  type = set(string)
}

variable "vmsize" {
  type = string
}

variable "image_sku" {
  type = string
}

variable "computer_name" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "azurerm_network_interface" {
  type = string
}
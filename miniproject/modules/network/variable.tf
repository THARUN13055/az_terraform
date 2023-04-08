variable "resource_group_name" {
    type = string
    description = "this is the resource group name"
}

variable "location" {
    type = string
    description = "this is the location name"
}

variable "virtual_network_name" {
    type = string
    description = "this is the virtual machine name"
}

variable "address_space" {
    type = string
    description = "this is the address space" 
}

variable "subnet_name" {
  type = set(string)
  description = "it will define the two or more variable in the list of string"
}

variable "bastion_host_name" {
  type = string
  description = "this is bastion host name" 
}

variable "bastion_required" {
  type = bool
  default = false
  
}

variable "network-security_group_names" {
  type = map(string)
  description = "this is network security group name"
  
}

variable "network_security_group_rules" {
  type = list
  description = "this is the network security group rule"
}

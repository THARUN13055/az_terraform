// this variable for virtual_network

variable "resource_group_name" {
  type = string
}

variable "net_name" {
  type = string
}

variable "location" {
  type = string
}

variable "address_space" {
  type = string
}

// this variable for subnet

variable "subnet_name" {
  type = set(string)
}

// this is for network interface 

variable "ip_configuration_name" {
  type = string
}

variable "private_ip_address_allocation" {
  type = string
}

// this is for public ip address assign for network

variable "public_ip_sku" {
  type = string
}

// this is for creating the network security group

variable "nsg_name" {
  type = map(string)
}

variable "network_security_rule" {
  type = list(any)
}

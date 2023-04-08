variable "resource_group_name" {
  description = "this is the resource group name"
  type        = string
}

variable "location" {
  description = "the is the resource group location "
  type        = string
}


variable "network_interface_name" {
  type = string
  description = "this si the network interface name"
}

variable "subnet_id" {
  type = string
  description = "this is the subnet id"
}

variable "private_ip_address_allocation" {
  type = string
  description = "this value is dynamic or static"
  default = "Dynamic"
}

variable "public_ip_name" {
  type=string
  description="This defines the public ip address"  
  default = "default-ip"
}

variable "public_ip_required" {
  type = bool
  description = "this is tell us that db need public ip address or not because db need secure"  
  default = false
}
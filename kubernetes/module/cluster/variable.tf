variable "cluster_name" {
  type        = string
  description = "this is the cluster name"
}

variable "location" {
  type        = string
  description = "this is the location for the cluster"
}

variable "resource_group_name" {
  type        = string
  description = "this is the rsgp name"
}

variable "node_count" {
  type        = number
  description = "this is use the create the number of node"
}

variable "vm_size" {
  type        = string
  description = "this will describe the size of the vm"
}

variable "kubernetes_version" {
  type        = string
  description = "this will define the kubernetes viersion"
}

variable "enable_auto_scaling" {
  type        = bool
  default     = false
  description = "this will enable auto scalling or not"
}

variable "sku_tier" {
  type        = string
  description = "free tier we need to enable"
}

variable "dns_prefix" {
  type        = string
  description = "this is the name which will assign the network for kubelet"

}
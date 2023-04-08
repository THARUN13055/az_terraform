module "general_module" {
  source              = ".././general"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_kubernetes_cluster" "kubecluster" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
  location            = var.location
  kubernetes_version  = var.kubernetes_version
  dns_prefix          = var.dns_prefix
  sku_tier            = var.sku_tier

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name                = "system"
    enable_auto_scaling = var.enable_auto_scaling
    node_count          = var.node_count
    vm_size             = var.vm_size
    type                = "VirtualMachineScaleSets"
  }


}

resource "azurerm_kubernetes_cluster_node_pool" "nodepool" {
  name                  = "system"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.kubecluster.id
  vm_size               = var.vm_size
  node_count            = var.node_count

}
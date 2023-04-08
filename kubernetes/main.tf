module "general_module" {
  source              = "./module/general"
  resource_group_name = local.resource_group_name
  location            = local.location
}

module "cluster" {
  source              = "./module/cluster"
  resource_group_name = local.resource_group_name
  location            = local.location
  cluster_name        = "sampletestcluster123"
  node_count          = 2
  vm_size             = "Standard_DS2_v2"
  kubernetes_version  = "1.25.4"
  sku_tier            = "Free"
  dns_prefix          = "kubenet-network"

}
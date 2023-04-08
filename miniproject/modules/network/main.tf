module "general_module" {
  source = ".././general"
  resource_group_name = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = var.virtual_network_name
  address_space       = [var.address_space]
  depends_on = [
    module.general_module.rsgp
  ]
}

resource "azurerm_subnet" "vsubnet" {
    for_each = var.subnet_name
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes = [cidrsubnet(var.address_space,8,index(tolist(var.subnet_name),each.value))]
  depends_on = [
      azurerm_virtual_network.vnet
    ]
}

// Here We are creating the bastion so we need to create the subnet and public ip.

resource "azurerm_subnet" "bastionsub" {
  count = var.bastion_required ? 1 : 0 
  name                 = "AzureBastionSubnet" //AzureBastionSubnet is the perment work which we need to use
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes = ["10.0.10.0/24"]
  depends_on = [
      azurerm_virtual_network.vnet
    ]
}

resource "azurerm_public_ip" "publicipbastion" {
  count = var.bastion_required ? 1 : 0 
  name = "publicipbastion"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku = "Standard"
  depends_on = [
    module.general_module.rsgp
  ]
}

resource "azurerm_bastion_host" "bastionhost" {
  count = var.bastion_required ? 1 : 0 
  name                = var.bastion_host_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastionsub[0].id
    public_ip_address_id = azurerm_public_ip.publicipbastion[0].id
  }
}

// network security group

resource "azurerm_network_security_group" "nsgp" {
  for_each = var.network-security_group_names
  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_subnet_network_security_group_association" "netgrpassociation" {
  for_each = var.network-security_group_names
  subnet_id                 = azurerm_subnet.vsubnet[each.value].id
  network_security_group_id = azurerm_network_security_group.nsgp[each.key].id
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_network_security_group.nsgp
  ]
}

resource "azurerm_network_security_rule" "nsrule" {
  for_each = {for rule in var.network_security_group_rules:rule.id=>rule}
  name                        = "${each.value.name}"
  priority                    = each.value.priority
  direction                   = "Outbound"
  access                      = each.value.access
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsgp[each.value.network_security_group_name].name
  depends_on = [
    module.general_module.rsgp,
    azurerm_network_security_group.nsgp
  ]
}

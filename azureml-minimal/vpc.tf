# virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "${local.prefix}-${local.azureml.name}-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# subnet
resource "azurerm_subnet" "subnet" {
  name                 = "${local.prefix}-${local.azureml.name}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.0.0/24"]
}

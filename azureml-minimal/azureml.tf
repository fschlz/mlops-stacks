data "azurerm_client_config" "current" {
  depends_on = [azurerm_resource_group.rg]

}

# workspace application insights
resource "azurerm_application_insights" "ai" {
  name                = "${local.prefix}-${local.azureml.name}-ai"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}

# workspace
# TODO: Jobs runs are not accessible to my user
resource "azurerm_machine_learning_workspace" "ws" {
  name                    = "${local.prefix}-${local.azureml.name}-ws"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  application_insights_id = azurerm_application_insights.ai.id
  key_vault_id            = azurerm_key_vault.secret_manager.id
  storage_account_id      = azurerm_storage_account.account.id

  identity {
    type = "SystemAssigned"
  }
}

# workspace compute cluster
# THIS CAN ONLY BE CREATED OR DELETED, NOT UPDATED
# see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/machine_learning_compute_cluster
resource "azurerm_machine_learning_compute_cluster" "cluster" {
  name                          = "${local.prefix}-${local.azureml.name}-cluster"
  location                      = azurerm_resource_group.rg.location
  vm_priority                   = "LowPriority"
  vm_size                       = "Standard_DS2_v2"
  machine_learning_workspace_id = azurerm_machine_learning_workspace.ws.id
  subnet_resource_id            = azurerm_subnet.subnet.id

  scale_settings {
    min_node_count                       = 0
    max_node_count                       = 2
    scale_down_nodes_after_idle_duration = "PT30S" # 30 seconds
  }

  identity {
    type = "SystemAssigned"
  }
}

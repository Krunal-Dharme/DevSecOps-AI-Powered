resource "azurerm_kubernetes_cluster" "aks" {
  name                = "quantam-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "quantamaks"

  default_node_pool {
    name                = "systempool"
    node_count         = 2
    vm_size            = "Standard_D2s_v3"

    vnet_subnet_id     = azurerm_subnet.subnet.id

    enable_auto_scaling = true
    min_count          = 2
    max_count          = 3
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }
}

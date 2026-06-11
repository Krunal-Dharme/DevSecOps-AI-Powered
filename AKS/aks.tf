resource "azurerm_kubernetes_cluster" "aks" {
  name                = "quantam-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "quantamaks"
  role_based_access_control_enabled = true

  default_node_pool {
    name                 = "systempool"
    node_count           = 1
    vm_size              = "Standard_D2s_v3"
    vnet_subnet_id       = azurerm_subnet.subnet.id

    enable_auto_scaling  = true
    min_count            = 1
    max_count            = 2
    only_critical_addons_enabled = true
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.2.0.0/16"
    dns_service_ip = "10.2.0.10"
  }
}

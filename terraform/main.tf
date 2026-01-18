resource "random_pet" "name" {
  length    = 2
  separator = "-"
}

/*resource "azurerm_resource_group" "k8s" {
  name     = "k8s-${random_pet.name.id}-rg"
  location = var.location
}*/

data "azurerm_resource_group" "k8s" {
  name = var.resource_group_name
}


resource "azurerm_container_registry" "acr" {
  name                = "acr${replace(random_pet.name.id, "-", "")}"
  resource_group_name = data.azurerm_resource_group.k8s.name
  location            = data.azurerm_resource_group.k8s.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${random_pet.name.id}"
  location            = data.azurerm_resource_group.k8s.location
  resource_group_name = data.azurerm_resource_group.k8s.name
  dns_prefix          = "demoaks"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = var.kubernetes_version
}

# The Role Assignment using better names:
resource "azurerm_role_assignment" "aks_to_acr" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "acr_admin_username" {
  value = azurerm_container_registry.acr.admin_username
}

output "acr_admin_password" {
  value = azurerm_container_registry.acr.admin_password
  sensitive = true
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}
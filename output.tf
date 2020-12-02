output "resource_group" {
  value = {
    name = azurerm_resource_group.rg.name
  }
}

output "container_registry" {
  value = {
    uri = azurerm_container_registry.cr.login_server,
    credentials = {
      username = azurerm_container_registry.cr.admin_username,
      password = azurerm_container_registry.cr.admin_password,
    },
  }
  sensitive = true
}

output "container_group" {
  value = {
    name = azurerm_container_group.cg.name
    ip = azurerm_container_group.cg.ip_address
    container = azurerm_container_group.cg.container[0].name
  }
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }

  backend "azurerm" {
    container_name       = "terraform-states-container"
    resource_group_name  = "common"
    storage_account_name = "blehnencommon"
    key                  = "blehnen.terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}rg"
  location = var.location
}

resource "azurerm_container_registry" "cr" {
  name                = "${var.prefix}cr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = {
    application = "application"
  }

  provisioner "local-exec" {
    command = <<EOT
      echo ${azurerm_container_registry.cr.admin_password} | docker login ${azurerm_container_registry.cr.login_server} -u ${azurerm_container_registry.cr.admin_username} --password-stdin &&
      docker build -t ${var.image_name}:latest . &&
      docker tag ${var.image_name}:latest ${azurerm_container_registry.cr.login_server}/${azurerm_container_registry.cr.name}/${var.image_name}:latest
      docker push ${azurerm_container_registry.cr.login_server}/${azurerm_container_registry.cr.name}/${var.image_name}:latest
    EOT
  }
}

resource "azurerm_container_group" "cg" {
  name                = "${var.prefix}cg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "public"
  os_type             = "Linux"
  restart_policy      = "Never"

  image_registry_credential {
    server   = azurerm_container_registry.cr.login_server
    username = azurerm_container_registry.cr.admin_username
    password = azurerm_container_registry.cr.admin_password
  }

  container {
    name   = "flask-application"
    image = "${azurerm_container_registry.cr.login_server}/${azurerm_container_registry.cr.name}/${var.image_name}:latest"
    cpu    = "1"
    memory = "1.5"

    ports {
      port     = 5000
      protocol = "TCP"
    }
  }

  tags = {
    environment = "testing"
  }
}
 

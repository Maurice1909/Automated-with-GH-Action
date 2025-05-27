# Configure the AzureRM Provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Define variables
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "coffee-app-rg"
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
  default     = "uksouth"
}

variable "acr_name" {
  description = "The name of your Azure Container Registry"
  type        = string
  default     = "acrcoffeeapp" 
}

variable "image_name" {
  description = "The name of the Docker image in ACR"
  type        = string
  default     = "first_coffee"
}

variable "image_tag" {
  description = "The tag of the Docker image"
  type        = string
  default     = "latest"
}

# Reference the existing Resource Group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# Reference the Azure Container Registry
data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Deploy the Azure Container Instance
resource "azurerm_container_group" "coffee_app_aci" {
  name                = "coffee-app-instance" # Name for your container instance
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  ip_address_type     = "Public" # Or "Private" if you have a VNET and want internal access
  dns_name_label      = "coffee-app-${random_string.suffix.id}" # Unique DNS label for public IP
  os_type             = "Linux"

  container {
    name   = "coffee-app-container"
    image  = "${data.azurerm_container_registry.acr.login_server}/${var.image_name}:${var.image_tag}"
    cpu    = 1
    memory = 1.5
    ports {
      port     = 80 # Your Python app doesn't expose a web server, but ACI needs a port. This is just for container health.
      protocol = "TCP"
    }
  }

  # Credentials to pull from private ACR
  image_registry_credential {
    server   = data.azurerm_container_registry.acr.login_server
    username = data.azurerm_container_registry.acr.admin_username
    password = data.azurerm_container_registry.acr.admin_password
  }

  tags = {
    Environment = "Development"
    Project     = "CoffeeApp"
  }
}

# Generate a random string to ensure unique DNS label
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
  numeric = true
}

# Output the public IP address
output "container_ip_address" {
  value = azurerm_container_group.coffee_app_aci.ip_address
}

output "container_fqdn" {
  value = azurerm_container_group.coffee_app_aci.fqdn
}
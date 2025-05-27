terraform {
  backend "azurerm" {
    resource_group_name  = "coffee-app-rg" # Use the resource group you created
    storage_account_name = "tfstatestorage1909" # IMPORTANT: Replace with a unique storage account name
    container_name       = "tfstate"
    key                  = "coffee-app.tfstate"
  }
}
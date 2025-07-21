terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.53"
    }
  }

  cloud {
    organization = "Jonathans-Lab"

    workspaces {
      name = "Terraform-Azure-AKS-GitOps-Lab"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-aks-lab"
  location = "eastus"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-lab"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks-lab"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s" # small and free-tier compatible
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "lab"
  }
}

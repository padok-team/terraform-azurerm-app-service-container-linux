provider "azurerm" {
  features {}
}
resource "random_pet" "this" {
  length = 2

}

resource "azurerm_resource_group" "this" {
  name     = random_pet.this.id
  location = "France Central"
}


resource "azurerm_virtual_network" "this" {
  name                = "${random_pet.this.id}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "this" {
  name                 = "${random_pet.this.id}-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_user_assigned_identity" "this" {
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  name = random_pet.this.id
}

resource "azurerm_app_service_plan" "this" {
  name                = random_pet.this.id
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  kind     = "Linux"
  reserved = true

  per_site_scaling = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

module "app_service_container_linux" {
  source = "../.."

  name = random_pet.this.id
  resource_group = {
    name     = azurerm_resource_group.this.name
    location = azurerm_resource_group.this.location
  }
  app_service_plan = azurerm_app_service_plan.this

  app_settings = {
    DOCKER_REGISTRY_SERVER_URL = "https://index.docker.io"
    padok                      = "cool"
  }

  subnet_ids = [azurerm_subnet.this.id]

  identity_ids = [azurerm_user_assigned_identity.this.id]

  number_of_workers = 3
  slots             = 3

  logs_enabled = true

  depends_on = [
    azurerm_app_service_plan.this
  ]
}

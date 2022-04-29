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

resource "azurerm_app_service_plan" "this" {
  name                = random_pet.this.id
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  kind     = "Linux"
  reserved = true

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
    "padok" = "cool"
  }

  depends_on = [
    azurerm_app_service_plan.this
  ]
}

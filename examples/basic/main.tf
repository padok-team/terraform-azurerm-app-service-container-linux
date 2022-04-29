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

module "app_service_container_linux" {
  source = "../.."

  name = random_pet.this.id
  resource_group = {
    name     = azurerm_resource_group.this.name
    location = azurerm_resource_group.this.location
  }
}

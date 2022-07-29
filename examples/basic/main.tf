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
  # The `image` variable is NOT tracked by Terraform.
  # Any changes to it will not be reflected in the Terraform state.
  # Note that, in order to use a Docker Hub image, you need to set an app setting
  # DOCKER_REGISTRY_SERVER_URL = https://index.docker.io
  # which is set by default when no app settings are specified.
  image               = "index.docker.io/kennethreitz/httpbin:latest"
  client_cert_enabled = false
}

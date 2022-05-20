# Azure App Service (Linux Container) Terraform module

Terraform module which creates App Service resources on Azure, configured for use with a Linux Docker image.

## User Stories for this module

- AAOPS I can deploy a Linux container on an App Service with best practices as defaults
- AAOPS I can set up a scalable Linux container App Service with deployment slots

## Usage

```hcl
module "app_service" {
  source = "https://github.com/padok-team/terraform-azurerm-app-service-container-linux?ref=v0.0.1"

  name = "test-app-service"
  resource_group = {
    name     = "example-rg"
    location = "francecentral"
  }
  # The `image` variable, and all app settings, are NOT tracked by Terraform.
  # Any changes to these will not be reflected in the Terraform state.
  # Note that, in order to use a Docker Hub image, you need to set an app setting
  # DOCKER_REGISTRY_SERVER_URL = https://index.docker.io
  # which is set by default when no app settings are specified.
  image               = "index.docker.io/kennethreitz/httpbin:latest"
  client_cert_enabled = false
}
```

## Examples

- [Example of basic use case](examples/basic/main.tf)
- [Example of complex use case](examples/complex/main.tf)

<!-- BEGIN_TF_DOCS -->
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_logger"></a> [logger](#module\_logger) | git@github.com:padok-team/terraform-azurerm-logger.git | v0.1.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Specifies the name of the App Service. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | The Resource group where to deploy AppService. | <pre>object({<br>    name     = string,<br>    location = string<br>  })</pre> | n/a | yes |
| <a name="input_always_on"></a> [always\_on](#input\_always\_on) | Is the App Service always on? | `bool` | `true` | no |
| <a name="input_app_service_plan"></a> [app\_service\_plan](#input\_app\_service\_plan) | App Service Plan ID. The instance should allow App Service to scale (per site scaling enabled). | <pre>object({<br>    id = string<br>  })</pre> | `null` | no |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | A key-value pair of App Settings. | `map(string)` | <pre>{<br>  "DOCKER_REGISTRY_SERVER_URL": "https://index.docker.io"<br>}</pre> | no |
| <a name="input_backup"></a> [backup](#input\_backup) | Backup object to configure the App Service. | <pre>object({<br>    name                = string<br>    enabled             = bool<br>    storage_account_url = string<br>    schedule = object({<br>      frequency_interval       = string<br>      frequency_unit           = string<br>      keep_at_least_one_backup = bool<br>      retention_period_in_days = string<br>      start_time               = string<br>    })<br>  })</pre> | `null` | no |
| <a name="input_client_cert_enabled"></a> [client\_cert\_enabled](#input\_client\_cert\_enabled) | Should a client certificate be required for connections to the App Service? | `bool` | `true` | no |
| <a name="input_connection_strings"></a> [connection\_strings](#input\_connection\_strings) | Connection strings to configure for the App Service. | <pre>map(object({<br>    type  = string<br>    value = string<br>  }))</pre> | `{}` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | List of identity ids. | `list(string)` | `[]` | no |
| <a name="input_image"></a> [image](#input\_image) | Docker image to deploy at App Service generation.  Will only be defined on the first run, and will be ignored by Terraform on subsequent runs. Your application configuration should be separated from your infrastructure configuration. | `string` | `"index.docker.io/busybox:latest"` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The Log Analytics Workspace ID to use for logging. | `string` | `null` | no |
| <a name="input_logs_enabled"></a> [logs\_enabled](#input\_logs\_enabled) | Should logs be enabled for the App Service? | `bool` | `true` | no |
| <a name="input_number_of_workers"></a> [number\_of\_workers](#input\_number\_of\_workers) | Number of workers to configure for the App Service. | `number` | `1` | no |
| <a name="input_slots"></a> [slots](#input\_slots) | Number of additional App Service Slots to create. | `number` | `0` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet ids for network swift connections. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this"></a> [this](#output\_this) | The App Service resource instance. |
<!-- END_TF_DOCS -->

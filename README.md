# Azure App Service (Linux Container) Terraform module

Terraform module which creates App Service resources on Azure, configured for use with a Linux Docker image.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [User Stories for this module](#user-stories-for-this-module)
- [Usage](#usage)
- [Examples](#examples)
- [Modules](#modules)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

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
- [Example of use case with networking and managed identity](examples/network_and_identity/main.tf)

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
| <a name="input_app_service_plan_id"></a> [app\_service\_plan\_id](#input\_app\_service\_plan\_id) | App Service Plan ID. The instance should allow App Service to scale (per site scaling enabled). | `string` | `null` | no |
| <a name="input_app_service_plan_name"></a> [app\_service\_plan\_name](#input\_app\_service\_plan\_name) | The name of the App Service Plan. | `string` | `null` | no |
| <a name="input_app_service_plan_sku"></a> [app\_service\_plan\_sku](#input\_app\_service\_plan\_sku) | The SKU of the App Service Plan. | <pre>object({<br>    tier     = string<br>    size     = string<br>    capacity = number<br>  })</pre> | <pre>{<br>  "capacity": null,<br>  "size": "S1",<br>  "tier": "Standard"<br>}</pre> | no |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | A key-value pair of App Settings. | `map(string)` | <pre>{<br>  "DOCKER_REGISTRY_SERVER_URL": "https://index.docker.io"<br>}</pre> | no |
| <a name="input_backup"></a> [backup](#input\_backup) | Backup object to configure the App Service. | <pre>object({<br>    name                = string<br>    enabled             = bool<br>    storage_account_url = string<br>    schedule = object({<br>      frequency_interval       = string<br>      frequency_unit           = string<br>      keep_at_least_one_backup = bool<br>      retention_period_in_days = string<br>      start_time               = string<br>    })<br>  })</pre> | `null` | no |
| <a name="input_client_cert_enabled"></a> [client\_cert\_enabled](#input\_client\_cert\_enabled) | Should a client certificate be required for connections to the App Service? | `bool` | `true` | no |
| <a name="input_connection_strings"></a> [connection\_strings](#input\_connection\_strings) | Connection strings to configure for the App Service. | <pre>map(object({<br>    type  = string<br>    value = string<br>  }))</pre> | `{}` | no |
| <a name="input_create_app_service_plan"></a> [create\_app\_service\_plan](#input\_create\_app\_service\_plan) | Decide if the module should create its own App Service plan. Should be false if app\_service\_plan\_id is configured. | `bool` | `true` | no |
| <a name="input_enable_auth_settings"></a> [enable\_auth\_settings](#input\_enable\_auth\_settings) | Enable Auth Settings | `bool` | `true` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | List of identity ids. | `list(string)` | `[]` | no |
| <a name="input_image"></a> [image](#input\_image) | Docker image to deploy at App Service generation.  Will only be defined on the first run, and will be ignored by Terraform on subsequent runs. Your application configuration should be separated from your infrastructure configuration. | `string` | `"index.docker.io/busybox:latest"` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The Log Analytics Workspace ID to use for logging. | `string` | `null` | no |
| <a name="input_logs_enabled"></a> [logs\_enabled](#input\_logs\_enabled) | Should logs be enabled for the App Service? | `bool` | `true` | no |
| <a name="input_site_config_override"></a> [site\_config\_override](#input\_site\_config\_override) | The override configuration of site\_config parameters. | `map(any)` | `{}` | no |
| <a name="input_slot_count"></a> [slot\_count](#input\_slot\_count) | Number of additional App Service Slots to create. | `number` | `0` | no |
| <a name="input_slot_prefix"></a> [slot\_prefix](#input\_slot\_prefix) | Slot name prefix. | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet ids for network swift connections. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this"></a> [this](#output\_this) | The App Service resource instance. |
<!-- END_TF_DOCS -->

## License

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

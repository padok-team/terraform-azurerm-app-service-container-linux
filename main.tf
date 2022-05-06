resource "azurerm_app_service_plan" "this" {
  count               = var.app_service_plan == null ? 1 : 0
  name                = "${var.name}-plan"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  kind     = "Linux"
  reserved = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "this" {
  name                = var.name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  app_service_plan_id = var.app_service_plan == null ? azurerm_app_service_plan.this[0].id : var.app_service_plan.id

  https_only          = true
  client_cert_enabled = true
  app_settings        = var.app_settings

  dynamic "backup" {
    for_each = var.backup != null ? [1] : []
    content {
      name                = var.backup.name
      enabled             = var.backup.enabled
      storage_account_url = var.backup.storage_account_url
      schedule {
        frequency_interval       = var.backup.schedule.frequency_interval
        frequency_unit           = var.backup.schedule.frequency_unit
        keep_at_least_one_backup = var.backup.schedule.keep_at_least_one_backup
        retention_period_in_days = var.backup.schedule.retention_period_in_days
        start_time               = var.backup.schedule.start_time
      }
    }
  }

  site_config {
    always_on              = var.always_on
    health_check_path      = "/healthz"
    number_of_workers      = var.number_of_workers
    http2_enabled          = true
    ftps_state             = "Disabled"
    linux_fx_version       = "DOCKER|${var.image}"
    vnet_route_all_enabled = length(var.subnet_ids) > 0
  }

  auth_settings {
    enabled = true
  }

  identity {
    type         = length(var.identity_ids) > 0 ? "UserAssigned" : "SystemAssigned"
    identity_ids = length(var.identity_ids) > 0 ? var.identity_ids : null
  }

  lifecycle {
    ignore_changes = [
      site_config.0.linux_fx_version,
      app_settings
    ]
  }

  tags = var.tags
}

resource "azurerm_app_service_virtual_network_swift_connection" "these" {
  count          = length(var.subnet_ids)
  app_service_id = azurerm_app_service.this.id
  subnet_id      = var.subnet_ids[count.index]
}

locals {
  app_service_plan_name = var.app_service_plan_name == null ? "${var.name}-plan" : var.app_service_plan_name
  app_service_plan_id   = var.create_app_service_plan == true ? azurerm_app_service_plan.this[0].id : var.app_service_plan_id
  slot_prefix           = var.slot_prefix == null ? "${var.name}-slot-" : var.slot_prefix
}

resource "azurerm_app_service_plan" "this" {
  count               = var.create_app_service_plan == true ? 1 : 0
  name                = local.app_service_plan_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  kind     = "Linux"
  reserved = true

  sku {
    tier     = var.app_service_plan_sku.tier
    size     = var.app_service_plan_sku.size
    capacity = var.app_service_plan_sku.capacity
  }
}

resource "azurerm_app_service" "this" {
  name                = var.name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  app_service_plan_id = local.app_service_plan_id

  https_only          = true
  client_cert_enabled = var.client_cert_enabled
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
    health_check_path      = var.health_check_path
    number_of_workers      = var.number_of_workers
    http2_enabled          = true
    ftps_state             = "Disabled"
    linux_fx_version       = "DOCKER|${var.image}"
    vnet_route_all_enabled = length(var.subnet_ids) > 0
  }

  auth_settings {
    enabled = var.enable_auth_settings
  }

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = each.name
      type  = each.value.type
      value = each.value.value
    }
  }

  identity {
    type         = length(var.identity_ids) > 0 ? "UserAssigned" : "SystemAssigned"
    identity_ids = length(var.identity_ids) > 0 ? var.identity_ids : null
  }

  lifecycle {
    ignore_changes = [
      site_config.0.linux_fx_version
    ]
  }

  tags = var.tags
}

resource "azurerm_app_service_virtual_network_swift_connection" "these" {
  for_each       = { for i, v in var.subnet_ids : i => v }
  app_service_id = azurerm_app_service.this.id
  subnet_id      = each.value
}

resource "azurerm_app_service_slot" "these" {
  for_each            = { for k in range(var.slot_count) : k => "" }
  name                = "${local.slot_prefix}${each.key}"
  app_service_name    = azurerm_app_service.this.name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  app_service_plan_id = local.app_service_plan_id

  https_only = true

  app_settings = var.app_settings

  site_config {
    always_on              = var.always_on
    health_check_path      = var.health_check_path
    number_of_workers      = var.number_of_workers
    http2_enabled          = true
    ftps_state             = "Disabled"
    linux_fx_version       = "DOCKER|${var.image}"
    vnet_route_all_enabled = length(var.subnet_ids) > 0
  }

  auth_settings {
    enabled = var.enable_auth_settings
  }

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = each.name
      type  = each.value.type
      value = each.value.value
    }
  }

  identity {
    type         = length(var.identity_ids) > 0 ? "UserAssigned" : "SystemAssigned"
    identity_ids = length(var.identity_ids) > 0 ? var.identity_ids : null
  }

  lifecycle {
    ignore_changes = [
      site_config.0.linux_fx_version
    ]
  }

  tags = var.tags
}

module "logger" {
  source                     = "git@github.com:padok-team/terraform-azurerm-logger.git?ref=v0.1.3"
  count                      = var.logs_enabled ? 1 : 0
  log_analytics_workspace_id = var.log_analytics_workspace_id
  resource_group_name        = var.resource_group.name
  resource_group_location    = var.resource_group.location

  name = "logger"
  resources_to_logs = [
    azurerm_app_service.this.id
  ]
  resources_to_metrics = [
    azurerm_app_service.this.id
  ]
}

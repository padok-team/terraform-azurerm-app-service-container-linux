variable "resource_group" {
  type = object({
    name     = string,
    location = string
  })
  description = "The Resource group where to deploy AppService."
}

###############################
# App Service Plan
###############################
variable "app_service_plan_sku" {
  type = object({
    tier     = string
    size     = string
    capacity = number
  })
  description = "The SKU of the App Service Plan."
  default = {
    tier     = "Standard"
    size     = "S1"
    capacity = null
  }
}

variable "app_service_plan" {
  type = object({
    id = string
  })
  description = "App Service Plan ID. The instance should allow App Service to scale (per site scaling enabled)."
  default     = null
}

############################
# App Service
############################
variable "name" {
  type        = string
  description = "Specifies the name of the App Service. Changing this forces a new resource to be created."
}

variable "client_cert_enabled" {
  type        = bool
  description = "Should a client certificate be required for connections to the App Service?"
  default     = true
}

variable "app_settings" {
  type        = map(string)
  description = "A key-value pair of App Settings."
  default = {
    DOCKER_REGISTRY_SERVER_URL = "https://index.docker.io"
  }
}


variable "health_check_path" {
  type        = string
  description = "Health Check path in application."
  default     = "/healthz"
}

variable "image" {
  type        = string
  description = "Docker image to deploy at App Service generation.  Will only be defined on the first run, and will be ignored by Terraform on subsequent runs. Your application configuration should be separated from your infrastructure configuration."
  default     = "index.docker.io/busybox:latest"
}

variable "backup" {
  type = object({
    name                = string
    enabled             = bool
    storage_account_url = string
    schedule = object({
      frequency_interval       = string
      frequency_unit           = string
      keep_at_least_one_backup = bool
      retention_period_in_days = string
      start_time               = string
    })
  })
  description = "Backup object to configure the App Service."
  default     = null
}

variable "always_on" {
  type        = bool
  description = "Is the App Service always on?"
  default     = true
}

variable "number_of_workers" {
  type        = number
  description = "Number of workers to configure for the App Service."
  default     = 1
}

variable "connection_strings" {
  type = map(object({
    type  = string
    value = string
  }))
  description = "Connection strings to configure for the App Service."
  default     = {}
}

variable "identity_ids" {
  type        = list(string)
  description = "List of identity ids."
  default     = []
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids for network swift connections."
  default     = []
}

variable "slots" {
  type        = number
  description = "Number of additional App Service Slots to create."
  default     = 0
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

variable "logs_enabled" {
  type        = bool
  description = "Should logs be enabled for the App Service?"
  default     = true
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "The Log Analytics Workspace ID to use for logging."
  default     = null
}

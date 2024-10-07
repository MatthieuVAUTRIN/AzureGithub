variable "prefix" {
  type        = string
  default     = "cosmosdb-manualscale"
  description = "Prefix of the resource name"
}

variable "location" {
  type        = string
  default     = "francecentral"
  description = "Resource group location"
}

variable "cosmosdb_account_location" {
  type        = string
  default     = "francecentral"
  description = "Cosmos db account location"
}

variable "docker_registry_username" {
  type        = string
  default = "matthieuvautrin"
  description = "Docker registry username"
  sensitive = true
}

variable "docker_registry_password" {
  type        = string
  description = "Docker registry password"
  sensitive = true
}

resource "random_string" "prefix" {
  length  = 8
  special = false
  upper  = false
}

resource "azurerm_resource_group" "rg" {
  name     = "${random_string.prefix.id}-rg"
  location = var.location
}

resource "azurerm_cosmosdb_account" "cosmosaccount" {
  name                      = "${random_string.prefix.id}-cosmosdb"
  location                  = var.cosmosdb_account_location
  resource_group_name       = azurerm_resource_group.rg.name
  offer_type                = "Standard"
  kind                      = "MongoDB"
  geo_location {
    location          = var.location
    failover_priority = 0
  }
  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_storage_account" "storageaccount" {
  name                     = "storage${random_string.prefix.id}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storagecontainer" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.storageaccount.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "storageblob" {
  name                   = "placeholder.zip"
  storage_account_name   = azurerm_storage_account.storageaccount.name
  storage_container_name = azurerm_storage_container.storagecontainer.name
  type                   = "Block"
}

resource "azurerm_service_plan" "serviceplan" {
  name                = "service-plan${random_string.prefix.id}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "linuxwebapp" {
  name                = "linux-web-app${random_string.prefix.id}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.serviceplan.location
  service_plan_id     = azurerm_service_plan.serviceplan.id

  site_config {
    application_stack{
      docker_image_name = "matthieuvautrin/simpleapi:latest"
      docker_registry_username = var.docker_registry_username
      docker_registry_password = var.docker_registry_password
    }
  }
}

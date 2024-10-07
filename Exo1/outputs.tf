output "cosmodb_name" {
  value = azurerm_cosmosdb_account.cosmosaccount.name
}

output "blob_name" {
  value = azurerm_storage_blob.storageblob.name
} 

output "blob_enpoint" {
  value = azurerm_storage_account.storageaccount.primary_blob_endpoint
}
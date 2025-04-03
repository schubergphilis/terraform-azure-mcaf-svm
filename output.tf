output "subscription_id" {
  value       = length(data.azapi_resource_list.subscription_metadata.output.subscriptionId) > 0 ? data.azapi_resource_list.subscription_metadata.output.subscriptionId[0] : data.azurerm_subscriptions.this.subscriptions[0].subscription_id
  description = "subscription id"
}

output "display_name" {
  value       = length(data.azapi_resource_list.subscription_metadata.output.displayName) > 0 ? data.azapi_resource_list.subscription_metadata.output.displayName[0] : data.azurerm_subscriptions.this.subscriptions[0].display_name
  description = "subscription display name"
}

output "id" {
  value       = length(data.azapi_resource_list.subscription_metadata.output.id) > 0 ? data.azapi_resource_list.subscription_metadata.output.id[0] : data.azurerm_subscriptions.this.subscriptions[0].id
  description = "combined into an azure valid resource id"
}
output "subscription_id" {
  value       = data.azapi_resource.subscription_metadata.output.properties.subscriptionId
  description = "subscription id"
}

output "display_name" {
  value       = data.azapi_resource.subscription_metadata.output.properties.name
  description = "subscription display name"
}

output "id" {
  value       = "/subscriptions/${data.azapi_resource.subscription_metadata.output.properties.subscriptionId}"
  description = "combined into an azure valid resource id"
}
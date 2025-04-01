output "subscription_id" {
  value       = data.azapi_resource.subscription_metadata.output.subscriptionId[0]
  description = "subscription id"
}

output "display_name" {
  value       = data.azapi_resource.subscription_metadata.output.displayName[0]
  description = "subscription display name"
}

output "id" {
  value       = data.azapi_resource.subscription_metadata.output.id[0]
  description = "combined into an azure valid resource id"
}
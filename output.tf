output "subscription_id" {
  value       = data.azapi_resource_list.subscription_metadata.output.subscriptionId[0]
  description = "subscription id"
}

output "display_name" {
  value       = data.azapi_resource_list.subscription_metadata.output.displayName[0]
  description = "subscription display name"
}

output "id" {
  value       = data.azapi_resource_list.subscription_metadata.output.id[0]
  description = "Resource ID of the subscription"
}
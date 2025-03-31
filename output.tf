# output "subscriptions_info" {
#   value = {
#     for env_k, env_v in var.subscription :
#     env_k => {
#       "id"   = try(jsondecode(data.restful_resource.subscription_metadata[env_k].output).subscription.Id, env_v.subscription_id)
#       "name" = env_v.name
#     }
#   }
#   description = "Will output the subscription id(s) and name(s) generated by the module."
# }

# output "subscription" {
#   value       = data.azurerm_subscriptions.this
#   description = "Created subscription details"
# }

output "subscription_id" {
  value       = data.azapi_resource.subscription_metadata.output.properties.subscriptionId
  description = "subscription id"
}

output "display_name" {
  value       = data.azapi_resource.subscription_metadata.output.name
  description = "subscription display name"
}

output "id" {
  value       = "/subscriptions/${data.azapi_resource.subscription_metadata.output.properties.subscriptionId}"
  description = "combined into an azure valid resource id"
}
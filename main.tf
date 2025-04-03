data "azurerm_client_config" "current" {}

data "azurerm_billing_mca_account_scope" "this" {
  count                = var.channel == "ea" ? 1 : 0
  billing_account_name = var.billing_account_name
  billing_profile_name = var.billing_profile_name
  invoice_section_name = var.invoice_section_name
}

resource "azapi_resource" "subscription" {
  count     = var.channel == "ea" ? 1 : 0
  type      = "Microsoft.Subscription/aliases@2024-08-01-preview"
  name      = var.name
  parent_id = "/"
  body = {
    properties = {
      additionalProperties = {
        managementGroupId    = var.parent_management_group_id
        subscriptionOwnerId  = var.owner_id
        subscriptionTenantId = data.azurerm_client_config.current.tenant_id
        tags                 = var.tags
      }
      billingScope = data.azurerm_billing_mca_account_scope.this[0].id
      displayName  = var.name
      workload     = var.sku
    }
  }
}

resource "restful_operation" "subscription" {
  count  = var.channel == "csp" ? 1 : 0
  path   = "/api/create-subscription"
  method = "POST"

  body = {
    SubscriptionName = var.name
    SkuId            = var.sku == "Production" ? "0001" : "0002"
  }

  poll = {
    url_locator       = "header.Location"
    status_locator    = "code"
    default_delay_sec = 15
    status = {
      success = "200"
      pending = ["202"]
    }
  }
}

data "azurerm_subscriptions" "this" {
  display_name_contains = var.name
  depends_on            = [restful_operation.subscription, azapi_resource.subscription]
}

data "azapi_resource_list" "subscription_metadata" {
  type      = "Microsoft.Resources/subscriptions@2024-11-01"
  parent_id = "/"

  response_export_values = {
    subscriptionId = "value[?displayName == '${var.name}'].subscriptionId"
    displayName    = "value[?displayName == '${var.name}'].displayName"
    id             = "value[?displayName == '${var.name}'].id"
  }
}

resource "azurerm_management_group_subscription_association" "this" {
  count               = var.channel == "csp" ? 1 : 0
  management_group_id = var.parent_management_group_id
  subscription_id     = data.azapi_resource_list.subscription_metadata.output.id[0]
}

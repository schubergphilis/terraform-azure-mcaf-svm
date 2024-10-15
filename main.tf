data "azurerm_client_config" "current" {}

data "azurerm_billing_mca_account_scope" "this" {
  for_each             = { for k, v in var.subscription : k => v if var.channel == "ea" }
  billing_account_name = var.billing_account_name
  billing_profile_name = var.billing_profile_name
  invoice_section_name = var.invoice_section_name
}

data "azurerm_management_group" "this" {
  for_each = { for k, v in var.subscription : k => v if var.channel == "ea" }
  name     = var.parent_management_group_name
}

resource "azapi_resource" "this" {
  for_each  = { for k, v in var.subscription : k => v if var.channel == "ea" }
  type      = "Microsoft.Subscription/aliases@2021-10-01"
  name      = each.key
  parent_id = "/"
  body = { properties = {
    additionalProperties = {
      managementGroupId    = data.azurerm_management_group.this.id
      subscriptionOwnerId  = each.value.subscription_owner_id == null ? var.subscription_owner_id : each.value.subscription_owner_id
      subscriptionTenantId = data.azurerm_client_config.current.tenant_id
      tags = {
        for k, v in merge(var.tags, each.value.tags) : k => v
      }
    }
    billingScope = data.azurerm_billing_mca_account_scope.this.id
    displayName  = each.key
    workload     = each.value.sku
    }
  }
}

resource "restful_operation" "this" {
  for_each = { for k, v in var.subscription : k => v if var.channel == "csp" }
  path     = "/api/create-subscription"
  method   = "POST"

  body = {
    SubscriptionName = each.key
    SkuId            = each.value.sku == "Production" ? "0001" : "0002"
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

# data "restful_resource" "subscription_metadata" {
#   for_each = { for k, v in var.subscription : k => v if var.channel == "csp" }

#   id     = "/api/create-subscription/${restful_operation.this[each.key].output}"
#   method = "GET"
# }

data "azurerm_subscriptions" "this" {
  for_each = var.subscription
  display_name_contains = each.key
  depends_on = [ restful_operation.this ]
}
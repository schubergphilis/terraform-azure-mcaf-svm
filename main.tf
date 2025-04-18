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
      }
      billingScope = data.azurerm_billing_mca_account_scope.this[0].id
      displayName  = var.name
      workload     = var.sku
    }
  }

  response_export_values = {
    subscriptionId = "properties.subscriptionId"
    displayName    = "name"
  }

  lifecycle {
    ignore_changes = [name, body]
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

  lifecycle {
    ignore_changes = [body]

  }
}

data "restful_resource" "subscription_metadata" {
  count = var.channel == "csp" ? 1 : 0

  id     = "/api/create-subscription/${restful_operation.subscription[0].output}"
  method = "GET"
}

locals {
  csp_response             = var.channel == "ea" ? {} : jsondecode(data.restful_resource.subscription_metadata[0].output)
  display_name             = var.channel == "ea" ? azapi_resource.subscription[0].output.displayName : local.csp_response.subscription.name
  subscription_id          = var.channel == "ea" ? azapi_resource.subscription[0].output.subscriptionId : local.csp_response.subscription.Id
  subscription_resource_id = "/subscriptions/${local.subscription_id}"

}

resource "azurerm_management_group_subscription_association" "this" {
  count               = var.channel == "csp" ? 1 : 0
  management_group_id = var.parent_management_group_id
  subscription_id     = local.subscription_resource_id
}

resource "azapi_update_resource" "subscription_tags" {
  type        = "Microsoft.Resources/tags@2024-11-01"
  resource_id = "${local.subscription_resource_id}/providers/Microsoft.Resources/tags/default"
  body = {
    properties = {
      tags = var.tags
    }
  }
}

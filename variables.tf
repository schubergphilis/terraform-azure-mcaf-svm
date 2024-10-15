variable "channel" {
  type        = string
  description = "Billing channel to be used by the subscription"
  nullable    = false

  validation {
    condition     = var.channel == "ea" || "csp"
    error_message = "The channel must be either 'ea' or 'csp'"
  }
}

variable "subscription" {
  type = map(object({
    sku                   = optional(string, "Production")
    subscription_owner_id = optional(string)
    tags                  = optional(map(string))
  }))
  nullable    = false
  description = <<DESCRIPTION

  - `name` = (Required) - name that the subscription will get.
  - `subscription_owner_id` = optional(string) - The ID of the subscription owner, only needed if channel is set to ea.
  - `tags` = optional(map(string)) - The tags to apply to the subscription.
  - `sku` = (Optional) - Production or a DevTest type of azure plan, defaults to Production.

To create a EA subscription:
```hcl
  sub1 = {
    subscription_owner_id = "00000000-0000-0000-0000-000000000000"
    tags = {
      Environment = "application1"
    }
  }
```
To create a CSP subscription:
```hcl
  sub2 = {
    tags = {
      Environment = "application2"
    }
  }
```
DESCRIPTION

  validation {
    condition     = alltrue([for s in var.subscription : contains(["Production", "DevTest"], s.sku)])
    error_message = "The sku must be either 'Production' or 'DevTest'."
  }
}

variable "billing_account_name" {
  description = "The name of the billing account, only needed if channel is set to ea"
  type        = string
  default     = null
}

variable "billing_profile_name" {
  description = "The name of the billing profile, only needed if channel is set to ea"
  type        = string
  default     = null
}

variable "invoice_section_name" {
  description = "The name of the invoice section, only needed if channel is set to ea"
  type        = string
  default     = null
}

variable "parent_management_group_name" {
  description = "The name of the parent management group, only needed if channel is set to ea"
  type        = string
  default     = null
}

variable "tags" {
  description = "The tags to apply to the subscription, only works if channel is set to ea"
  type        = map(string)
  default     = null
}

variable "subscription_owner_id" {
  description = "The ID of the subscription owner, only needed if channel is set to ea, can be overridden on a per subscription basis"
  type        = string
  default     = null
}
variable "channel" {
  type        = string
  description = "Billing channel to be used by the subscription"
  nullable    = false

  validation {
    condition     = contains(["ea", "csp"], var.channel)
    error_message = "The channel must be either 'ea' or 'csp'"
  }
}

# Required variables

variable "name" {
  type        = string
  description = "Name of the Subscription to be created"
  nullable    = false
}

variable "sku" {
  type        = string
  description = "Type of subscription to create"
  default     = "Production"

  validation {
    condition     = contains(["Production", "DevTest"], var.sku)
    error_message = "The subscription must be either 'Production' or 'DevTest'"
  }
}

# Enterprise Agreement Variables

variable "tags" {
  type        = map(string)
  description = "Tags to add to the subscription, only needed if channel is set to ea."
  default     = null
}

variable "owner_id" {
  type        = string
  description = "Id of the subscription owner, only needed if channel is set to ea."
  default     = null
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

variable "parent_management_group_id" {
  description = "The Id of the parent management group, only needed if channel is set to ea"
  type        = string
  default     = null
}

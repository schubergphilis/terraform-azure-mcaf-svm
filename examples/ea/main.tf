terraform {
  required_version = ">= 1.7"
}

module "ea_subscription" {
  source               = "../.."
  name                 = "sub-es-test"
  channel              = "ea"
  sku                  = "Production"
  tags                 = { "tag1" = "value" }
  owner_id             = "id"
  billing_account_name = "Billing Account Name"
  billing_profile_name = "Billing Profile Name"
  invoice_section_name = "Invoice Section Name"
}

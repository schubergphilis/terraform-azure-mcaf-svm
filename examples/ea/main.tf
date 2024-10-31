module "ea_subscription" {
  source               = "../.."
  name                 = "sub-ea-test"
  channel              = "ea"
  sku                  = "Production"
  tags                 = { "tag1" = "value" }
  owner_id             = "00000000-0000-0000-0000-000000000000"
  billing_account_name = "Billing Account Name"
  billing_profile_name = "Billing Profile Name"
  invoice_section_name = "Invoice Section Name"
}

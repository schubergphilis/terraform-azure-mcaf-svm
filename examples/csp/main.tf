module "csp_subscription" {
  source = "../.."

  channel = "csp"
  name    = "sub-csp-test"
  sku     = "Production"
}

terraform {
  required_version = ">= 1.7"
}

module "csp_subscription" {
  source  = "../.."
  name    = "sub-csp-test"
  channel = "csp"
  sku     = "Production"
}

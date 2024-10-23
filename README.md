# terraform-azure-mcaf-svm-csp
This terraform module will be able to manage subscriptions for CSP and Enterprise agreements.

## How to work with the CSP configuration

you need to configure the restful provider.
make sure to ask the saas team to whitelist your outgoing ip.

```terraform
provider "restful" {
  base_url = "https://your-csp-app-uri-here"

  header = {
    Content-Type = "application/json"
  }

  security = {
    apikey = [
      {
        in    = "header"
        name  = "x-functions-key"
        value = "x-functions-value"
      },
      {
        in    = "header"
        name  = "x-customer-key"
        value = "x-customer-value"
      },
    ]
  }
}
```

for variables, you need to provide a sku as well, the default is Production, which translates to **0001**, which is fine, setting to DevTest translates to **0002**.

the following options are available:

```
"enabledAzurePlans": [
  {
    "skuId": "0001",
    "skuDescription": "Microsoft Azure Plan"
  }
  {
    "skuId": "0002",
    "skuDescription": "Microsoft Azure Plan for DevTest"
  },
]
```

## How to work with the EA configuration

1. login with your credentials

```powershell
az login -t your-tenant-id-here
az billing account list --query "[].id"
# or
$AccountName = (az billing account list --query "[].id" -o json) | ConvertFrom-Json
```
The output will give you your account name
if you want to see all details, remove the query part.

2. check your billing information

```powershell
az billing profile list --account-name $AccountName --expand "InvoiceSections" --query "[].invoiceSections[].value[].id"
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.7 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | 1.15.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |
| <a name="requirement_restful"></a> [restful](#requirement\_restful) | 0.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | 1.15.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.6.0 |
| <a name="provider_restful"></a> [restful](#provider\_restful) | 0.14.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azapi_resource.this](https://registry.terraform.io/providers/azure/azapi/1.15.0/docs/resources/resource) | resource |
| [restful_operation.this](https://registry.terraform.io/providers/magodo/restful/0.14.0/docs/resources/operation) | resource |
| [azurerm_billing_mca_account_scope.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/billing_mca_account_scope) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscriptions.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscriptions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_channel"></a> [channel](#input\_channel) | Billing channel to be used by the subscription | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Subscription to be created | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | Type of subscription to create | `string` | n/a | yes |
| <a name="input_billing_account_name"></a> [billing\_account\_name](#input\_billing\_account\_name) | The name of the billing account, only needed if channel is set to ea | `string` | `null` | no |
| <a name="input_billing_profile_name"></a> [billing\_profile\_name](#input\_billing\_profile\_name) | The name of the billing profile, only needed if channel is set to ea | `string` | `null` | no |
| <a name="input_invoice_section_name"></a> [invoice\_section\_name](#input\_invoice\_section\_name) | The name of the invoice section, only needed if channel is set to ea | `string` | `null` | no |
| <a name="input_owner_id"></a> [owner\_id](#input\_owner\_id) | Id of the subscription owner, only needed if channel is set to ea. | `string` | `null` | no |
| <a name="input_parent_management_group_id"></a> [parent\_management\_group\_id](#input\_parent\_management\_group\_id) | The name of the parent management group, only needed if channel is set to ea | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add to the subscription, only needed if channel is set to ea. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subscription"></a> [subscription](#output\_subscription) | Created subscription details |
<!-- END_TF_DOCS -->

## License

**Copyright:** Schuberg Philis

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

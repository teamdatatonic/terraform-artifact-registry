# Terraform GCP Artifact Registry

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.3 |
| google | ~> 3.31 |
| google-beta | ~> 3.31 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment\_prefix | n/a | `any` | n/a | yes |
| iam\_policy | n/a | `map` | <pre>{<br>  "admin": [],<br>  "reader": [],<br>  "repoAdmin": [],<br>  "writer": []<br>}</pre> | no |
| project\_id | n/a | `string` | n/a | yes |
| region | n/a | `string` | n/a | yes |
| registry\_config | n/a | `any` | n/a | yes |

## Outputs

No output.

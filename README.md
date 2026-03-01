# terraform-yandex-angular

Terraform modules for deploying Angular SSR applications to Yandex Cloud.

## Usage

```hcl
module "angular" {
  source = "github.com/Angular-YC/terraform-yandex-angular//modules/angular_yc?ref=v1.1.2"

  app_name      = "my-app"
  env           = "production"
  domain_name   = "app.example.com"
  manifest_path = "./build/deploy.manifest.json"

  # Optional external resources:
  # create_dns_zone    = false
  # dns_zone_id        = "dnscxxxxxxxx"
  # certificate_id     = "fpqxxxxxxxx"
  # assets_bucket_name = "my-app-assets"
  # cache_bucket_name  = "my-app-cache"
}
```

## Deployment Flow

Recommended Angular-YC 4-step flow:

1. `angular-yc analyze`
2. `angular-yc build`
3. `angular-yc upload`
4. `terraform apply` for `modules/angular_yc`

Important:

- If you upload **before** Terraform apply (strict 4-step flow), pass existing bucket names via:
  - `assets_bucket_name`
  - `cache_bucket_name` (optional, when response cache is enabled)
- If these are empty, the module creates buckets during apply.

## Modules

### `modules/angular_yc`

Main deployment module that provisions:

- Cloud Functions (server + optional image optimizer)
- Object Storage buckets (assets + optional response cache)
- API Gateway from OpenAPI template
- DNS zone and TLS certificate (managed or external)
- Logging group and IAM bindings

### `modules/core_security`

Security components:

- KMS key
- Lockbox secrets
- IAM service accounts and access keys

### `modules/ydb_docapi`

YDB Serverless database and service account wiring for cache metadata.

## Key Inputs

| Name | Description | Required |
|------|-------------|----------|
| `app_name` | Application name | Yes |
| `env` | Environment (`dev`, `staging`, `production`) | Yes |
| `domain_name` | Custom domain | Yes |
| `manifest_path` | Path to deployment manifest JSON | Yes |
| `build_dir` | Build artifacts directory (used by local helpers) | No |
| `create_dns_zone` | Create DNS zone for `domain_name` | No |
| `dns_zone_id` | Existing zone ID when `create_dns_zone=false` and managed cert is used | No |
| `certificate_id` | Existing Certificate Manager cert ID to reuse | No |
| `assets_bucket_name` | Existing assets bucket name to reuse | No |
| `cache_bucket_name` | Existing cache bucket name to reuse | No |
| `enable_response_cache` | Enable HTML response caching | No |
| `enable_cdn` | Enable CDN (optional) | No |

For full variable list, see [`modules/angular_yc/variables.tf`](/home/work/my-projects/angular-yc/terraform-yandex-angular/modules/angular_yc/variables.tf).

## Outputs

Key outputs include:

- `api_gateway_domain`
- `api_gateway_id`
- `certificate_id`
- `assets_bucket`
- `cache_bucket`
- `server_function_id`, `server_function_version`
- `image_function_id`, `image_function_version`

See [`modules/angular_yc/outputs.tf`](/home/work/my-projects/angular-yc/terraform-yandex-angular/modules/angular_yc/outputs.tf) for the full list.

## Environment Examples

See:

- [`envs/dev/terraform.tfvars.example`](/home/work/my-projects/angular-yc/terraform-yandex-angular/envs/dev/terraform.tfvars.example)
- [`envs/prod/terraform.tfvars.example`](/home/work/my-projects/angular-yc/terraform-yandex-angular/envs/prod/terraform.tfvars.example)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| yandex | ~> 0.100.0 |

## License

MIT

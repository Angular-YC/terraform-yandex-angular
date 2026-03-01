# Angular YC Module

Main Terraform module for deploying Angular SSR applications to Yandex Cloud.

## Features

- Blue-green deployments with versioned artifacts
- Angular SSR server function (Express-based)
- Optional image optimization function
- Object Storage for browser assets and prerender output
- API Gateway routing with OpenAPI template
- Optional response cache (S3 + YDB metadata)
- DNS and TLS certificate (managed or external `certificate_id`)
- Lockbox/KMS integration via `core_security`

## Usage

```hcl
module "angular_app" {
  source = "./modules/angular_yc"

  app_name      = "my-angular-app"
  env           = "production"
  domain_name   = "app.example.com"
  manifest_path = "./build/deploy.manifest.json"

  enable_response_cache = true
  cache_ttl_days        = 30

  function_memory = {
    server = 512
    image  = 256
  }
}
```

## Key Inputs

- `app_name` (required)
- `env` (required)
- `domain_name` (required)
- `manifest_path` (required)
- `enable_response_cache` (default: `true`)
- `enable_cdn` (default: `false`)
- `create_dns_zone` (default: `true`)
- `dns_zone_id` (required when `create_dns_zone = false` and `certificate_id` is empty)
- `certificate_id` (optional; reuse existing Certificate Manager certificate)
- `assets_bucket_name` (optional; reuse pre-created assets bucket, recommended for strict 4-step flow)
- `cache_bucket_name` (optional; reuse pre-created cache bucket when response cache is enabled)

If `assets_bucket_name`/`cache_bucket_name` are empty, the module creates buckets during `terraform apply`.

## Deployment Flow

1. Run `angular-yc analyze` to detect SSR/API/cache capabilities
2. Run `angular-yc build` to create ZIP artifacts and `deploy.manifest.json`
3. Run `angular-yc upload` to publish artifacts to Object Storage
4. Apply Terraform module `angular_yc` with generated manifest coordinates

For step 3 before step 4, provide pre-existing bucket names via `assets_bucket_name` and (optionally) `cache_bucket_name`.

## Outputs

- API Gateway domain and ID
- assets/cache buckets
- function IDs and versions
- certificate ID and status
- YDB endpoint/database (when response cache enabled)
- lockbox secret IDs

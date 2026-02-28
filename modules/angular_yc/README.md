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

## Deployment Flow

1. Build artifacts with `angular-yc build` (manifest + zips + static files)
2. Upload artifacts to Object Storage
3. Apply Terraform with `manifest_path`
4. Verify API Gateway and DNS

## Outputs

- API Gateway domain and ID
- assets/cache buckets
- function IDs and versions
- certificate ID and status
- YDB endpoint/database (when response cache enabled)
- lockbox secret IDs

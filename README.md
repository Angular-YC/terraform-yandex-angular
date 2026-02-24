# terraform-yandex-angular

Terraform modules for deploying Angular SSR applications to Yandex Cloud.

## Usage

```hcl
module "angular" {
  source = "github.com/Angular-YC/terraform-yandex-angular//modules/angular_yc?ref=v1.0.0"

  app_name      = "my-app"
  env           = "production"
  domain_name   = "app.example.com"
  manifest_path = "./deploy.manifest.json"
}
```

## Modules

### `modules/angular_yc`

Main deployment module that provisions:
- Cloud Functions (server + optional image optimizer)
- Object Storage buckets (assets + optional response cache)
- API Gateway from OpenAPI template
- DNS zone and managed TLS certificate
- Logging group and IAM bindings

### `modules/core_security`

Security components:
- KMS key
- Lockbox secrets
- IAM service accounts and access keys

### `modules/ydb_docapi`

YDB Serverless database and service account wiring for cache metadata.

## Variables

| Name | Description | Required |
|------|-------------|----------|
| `app_name` | Application name | Yes |
| `env` | Environment (`dev`, `staging`, `production`) | Yes |
| `domain_name` | Custom domain | Yes |
| `manifest_path` | Path to deployment manifest JSON | Yes |
| `enable_response_cache` | Enable HTML response caching | No |
| `enable_cdn` | Enable CDN (optional) | No |

## Environment Examples

See `envs/dev/` and `envs/prod/` for tfvars examples.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| yandex | ~> 0.100.0 |

## License

MIT

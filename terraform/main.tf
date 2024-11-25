data "terraform_remote_state" "infra_module" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = var.tf_state_key_infra
    region = var.target_region
  }
}

module "lambda_api" {
    source = "git@github.com:3clife-org/aws.module.lambda-api.git?ref=main"
    
    api_name = var.api_name
    
    domain_prefix = var.domain_prefix
    hosted_zone_name = var.hosted_zone_name

    image_repository = data.terraform_remote_state.infra_module.outputs.repository_name
    image_tag = var.image_tag

    authorizer_issuer = var.authorizer_issuer
    authorizer_audience = var.authorizer_audience
    authorizer_jwks_url = var.authorizer_jwks_url
}
variable "tf_state_bucket" {
    description = "The name of the S3 bucket for Terraform state"
    type        = string
}

variable "tf_state_key_infra" {
    description = "The key for the Terraform state file for Infra Module"
    type        = string
}

variable "target_region" {
    description = "The target region for the deployment"
    type        = string
}

variable "api_name" {
    description = "The name of the REST API"
    type        = string
}

variable "domain_prefix" {
    description = "The prefix for the custom domain name"
    type        = string
}

variable "hosted_zone_name" {
    description = "The name of the Route 53 hosted zone"
    type        = string
}

variable "image_tag" {
    description = "The tag of the ECR image to deploy"
    type        = string
}

variable "authorizer_issuer" {
    description = "The issuer of the authorizer"
    type        = string
}

variable "authorizer_audience" {
    description = "The audience of the authorizer"
    type        = string
}

variable "authorizer_jwks_url" {
    description = "The JWKS URI of the authorizer"
    type        = string
}

variable "tags" {
    description = "A map of tags to apply to all resources"
    type        = map(string)
    default     = {}
}
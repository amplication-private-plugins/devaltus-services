data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "ecr" {
    source = "git@github.com:3clife-org/aws.module.elastic-container-registry.git?ref=v0.0.1"
    
    repository_name = "${var.target_env}-${var.name}"   
    tags = local.default_tags
}
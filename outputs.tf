
output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  value = data.aws_region.current.name
}

output "repository_name" {
  value = module.ecr.repository_name
}

output "repository_url" {
  value = module.ecr.repository_url
}
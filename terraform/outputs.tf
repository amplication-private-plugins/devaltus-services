output "api_gateway_invoke_url" {
  value = module.lambda_api.api_gateway.invoke_url
}

output "api_gateway_stage" {
  value = module.lambda_api.api_gateway.stage_name
}

output "domain_name" {
  value = module.lambda_api.acm.domain_name
}
mock_provider "aws" {
}

variables {
  target_env = "test"
  name       = "test-api"
}

run "ecr_repository_creation" {
  command = plan

  assert {
    condition     = module.ecr.repository_name == "test-test-api"
    error_message = "ECR repository name is not as expected"
  }
}
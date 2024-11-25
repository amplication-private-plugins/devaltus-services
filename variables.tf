variable "target_region" {
    description = "The AWS region to deploy resources in"
    type        = string
    default     = "us-east-1"
}

variable "target_env" {
    description = "Name of the environment to deploy to"
    type = string
}

variable "name" {
    description = "The name of the API/Application"
    type        = string
}

variable "tags" {
    description = "A map of tags to apply to all resources"
    type        = map(string)
    default     = {}
}

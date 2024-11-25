PROJECT_NAME = seed.rest-api.micronaut.infra

TF_WORKSPACE ?= local
TF_STATE_BUCKET ?= 

AWS_REGION ?= us-east-1

##
# Functions
# ============================================
##

# Params
# 1 - The container to run the command inside of
# 2 - The command to run inside the container
# 3 - The (optional) parameters to the command
define run_command_in_container
	@docker compose \
		--file docker-compose.yml \
		run \
		-i \
		--rm \
		--remove-orphans \
		$(1) \
		$(2)
endef

# Params
#	1 - The container to run the shell inside of
#	2 - The shell to run inside the container
#	3 - Optional commands to run within the container
define run_shell
	docker compose \
		--file docker-compose.yml \
		run \
		-it \
		--rm \
		--remove-orphans \
		--no-deps \
		--entrypoint $(2) \
		$(1)
endef

.PHONY: help shell ubuntu-shell validate init plan apply test lint

default: help

help:		## Show help menu
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

shell: ## Start bash session inside the Terraform image
	$(call run_shell,terraform,"/bin/sh")

ubuntu-shell: ## Start bash session inside the devcontainer base image
	$(call run_command_in_container,ubuntu,"/bin/bash")

validate: ## Validate the Terraform configuration
	$(call run_command_in_container,terraform,validate)

init: ## Initializes Terraform (run terraform init)
	$(call run_command_in_container,terraform,init -reconfigure $(shell make get_opts_backend))

plan: ## Run terraform plan
	$(call run_command_in_container,terraform,plan $(shell make get_opts_tfvars))

apply: ## Apply the Terraform configuration
	$(call run_command_in_container,terraform,apply -auto-approve $(shell make get_opts_tfvars))

destroy: ## Destroy the Terraform configuration
	$(call run_command_in_container,terraform,destroy -auto-approve $(shell make get_opts_tfvars))

output: ## Show the Terraform output
	$(call run_command_in_container,terraform,output)

test: ## Run the test suite
	$(call run_command_in_container,terraform,test)

lint: ## Lint the terraform code
	$(call run_command_in_container,tflint)


get_opts_tfvars: ## Get the tfvars options
	@if [ -z "$(TF_WORKSPACE)" ]; then \
		echo ""; \
	else \
		echo "-var-file=configs/$(TF_WORKSPACE).tfvars"; \
	fi

get_opts_backend: ## Get the backend-config options
	@if [ -f "override.tf" ]; then \
		echo ""; \
	elif [ -z "$(TF_STATE_BUCKET)" ]; then \
		echo "-backend=false"; \
	else \
		echo "-backend-config=\"bucket=${TF_STATE_BUCKET}\" -backend-config=\"key=applications/${PROJECT_NAME}/terraform.tfstate\" --backend-config=\"region=${AWS_REGION}\""; \
	fi
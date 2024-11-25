PROJECT_NAME ?= seed.rest-api.micronaut
PROJECT_ARTIFACT = pets-api
API_NAME = ${PROJECT_ARTIFACT}

IMAGE_REGISTRY ?=localhost
IMAGE_NAME ?= ${PROJECT_NAME}
IMAGE_TAG ?=latest

PLATFORM ?= linux/arm64,linux/amd64

export AWS_REGION ?= us-east-1
export TF_WORKSPACE ?= local
export TF_STATE_BUCKET ?=
export TF_VAR_tf_state_bucket ?= ${TF_STATE_BUCKET}
export TF_VAR_tf_state_key_infra = applications/${PROJECT_NAME}.infra/terraform.tfstate
export TF_VAR_image_tag ?= ${IMAGE_TAG}

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

default: help

help:		## Show help menu
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

## -------------------------------------- Build Targets --------------------------------------

build:		## Build the application
	@docker compose build
	@docker compose run --rm --entrypoint mvn java clean package

build-native: build	## Build the native image
	@docker buildx build --provenance=false --output type=docker --build-arg ARTIFACT_ID=${PROJECT_ARTIFACT} . -t ${IMAGE_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}

build-native-multiarch:	## Build the native image for multiple architectures
	@docker buildx build --provenance=false --output type=docker --platform ${PLATFORM} --build-arg ARTIFACT_ID=${PROJECT_ARTIFACT} . -t ${IMAGE_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}

## -------------------------------------- Run Targets --------------------------------------

shell: build	## Start bash session inside the Java container
	@docker compose run --rm --entrypoint /bin/bash java

develop: build		## Start the application in development mode
	@docker compose run --rm --service-ports --entrypoint mvn java clean mn:run 

test: build	## Run the tests
	@docker compose run --rm --entrypoint mvn java test

serve: build-native	## Serve the natively compiled application
	@docker run --rm -p 8080:8080 ${IMAGE_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}

release: build-native	## Build and push the native image to the registry
	@docker push ${IMAGE_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}

which-version:
	@docker compose run --rm --entrypoint mvn java help:evaluate -DforceStdout -Dexpression=project.version -q | awk 'NR==1{print}'

which-project:
	@echo ${PROJECT_NAME}

which-ecr-repo: pull-infra-state
	@cat infra.tfstate | jq -r '.outputs.repository_url.value'

pull-infra-state:
	@aws s3 cp s3://${TF_STATE_BUCKET}/${TF_VAR_tf_state_key_infra} infra.tfstate > /dev/null

## -------------------------------------- Terraform Targets --------------------------------------
tf-clean: ## Clean the Terraform configuration
	@docker-compose run --rm --entrypoint /bin/sh terraform -c "rm -rf .terraform || true"

tf-shell: ## Start bash session inside the Terraform image
	$(call run_shell,terraform,"/bin/sh")

tf-validate: ## Validate the Terraform configuration
	$(call run_command_in_container,terraform,validate)

tf-init: ## Initializes Terraform (run terraform init)
	$(call run_command_in_container,terraform,init --upgrade -reconfigure $(shell make get_opts_backend))

tf-plan: ## Run terraform plan
	$(call run_command_in_container,terraform,plan $(shell make get_opts_tfvars))

tf-apply: ## Apply the Terraform configuration
	$(call run_command_in_container,terraform,apply -auto-approve $(shell make get_opts_tfvars))

tf-destroy: ## Destroy the Terraform configuration
	$(call run_command_in_container,terraform,destroy -auto-approve $(shell make get_opts_tfvars))

tf-output: ## Show the Terraform output
	$(call run_command_in_container,terraform,output)

tf-test: ## Run the test suite
	$(call run_command_in_container,terraform,test)

tf-lint: ## Lint the terraform code
	$(call run_command_in_container,tflint)

get_opts_tfvars: ## Get the tfvars options
	@if [ -z "$(TF_WORKSPACE)" ]; then \
		echo ""; \
	else \
		echo "-var-file=configs/$(TF_WORKSPACE).tfvars"; \
	fi

get_opts_backend: ## Get the backend-config options
	@if [ -f "terraform/override.tf" ]; then \
		echo ""; \
	elif [ -z "$(TF_STATE_BUCKET)" ]; then \
		echo "-backend=false"; \
	else \
		echo "-backend-config=\"bucket=${TF_STATE_BUCKET}\" -backend-config=\"key=applications/${PROJECT_NAME}/terraform.tfstate\" --backend-config=\"region=${AWS_REGION}\""; \
	fi

# Terraform Module Seed Project

This repository provides a starting point for writing Terraform modules, with automated testing using the Terraform `test` framework, and linting support via `tflint`. All required tools are provided via Docker containers, managed by `docker-compose`, ensuring a consistent environment across different systems.

## Table of Contents
- [Terraform Module Seed Project](#terraform-module-seed-project)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Dependencies](#dependencies)
  - [Project Structure](#project-structure)
  - [Usage](#usage)
  - [Testing](#testing)
    - [Linting](#linting)
    - [Plan \& Apply](#plan--apply)
  - [Contributing](#contributing)
  - [Contact](#contact)

## Features

- **Automated Testing**: Using the [Terraform `test` framework](https://developer.hashicorp.com/terraform/language/tests) to validate and test Terraform modules.
- **Linting**: Integrated with [TFLint](https://github.com/terraform-linters/tflint) to enforce best practices and catch common mistakes in Terraform code.
- **Dockerized Environment**: All dependencies are handled via Docker, eliminating the need to install Terraform or TFLint on your local machine.
- **Modular Setup**: Easily extend the seed project to build custom Terraform modules.

## Dependencies

This project requires the following dependencies, to install the necessary dependencies on OSX, follow these steps:

1. **Docker**:
    - Download and install Docker Desktop for Mac from the [official Docker website](https://www.docker.com/products/docker-desktop).
    - Follow the installation instructions provided on the website.

2. **GNU Make**:
    - Ensure Homebrew is installed by going to the Self-Service application and running the `Install Workbrew Bootstrap` item.
    - Open Terminal.
    - Use Homebrew to install GNU Make:
      ```bash
      brew install make
      ```

## Local Backend
To override the remote backend configuration, you can create an `override.tf` file in the root of your project. This file will contain the backend configuration that you want to override. 

```hcl
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
```

By using `override.tf`, you can customize the backend configuration without modifying the main configuration files, making it easier to manage different state for local deployments to sandbox.

## Project Structure

```bash
.
├── main.tf              # Example Terraform module
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── tests/               # Directory for Terraform tests
│   └── example_test.tftest.hcl  # Example test cases
├── .tflint.hcl          # TFLint configuration
├── docker-compose.yml   # Docker services for Terraform and TFLint
├── Makefile             # Automation commands for linting and testing
└── README.md            # Project documentation (this file)
```

## Usage

1. **Clone the repository:**

   ```bash
   git clone git@github.com:3clife-org/seed.terraform.git
   cd seed.terraform
   ```

   This command starts up containers for Terraform and TFLint, which will be used for the various tasks.

2. **Available Make Commands:**

   - **View available `make` targets**

   To view a list of all available make targets you can run the following command:

    ```bash
    make help
    ```

    - **Run Tests:**

    To run the Terraform tests:

    ```bash
    make test
    ```

    - **Lint Terraform Code:**

    To lint the Terraform files using TFLint:

    ```bash
     make lint
    ```

   - **Run Terraform Plan:**

    To generate and show an execution plan for the Terraform configuration:

    ```bash
    make plan
    ```

   - **Apply Terraform Configuration:**

    To apply the Terraform configuration to your infrastructure:

    ```bash
    make apply
    ```

## Testing

The tests are located in the `tests/` folder. Each test is written in `.tftest.hcl` files and executed with the `terraform test` command. The tests use assertions to verify the module's output and expected behavior.

Example test file:

```hcl
provider "aws" {
  region = "us-west-2"
}

variables {
  bucket_name = "my-test-bucket"
}

run "validate_s3_bucket" {
  command = "plan"

  assert {
    condition     = aws_s3_bucket.example.bucket == var.bucket_name
    error_message = "S3 bucket name does not match"
  }
}
```

To run the tests:

```bash
make test
```

### Linting

[TFLint](https://github.com/terraform-linters/tflint) is used to enforce Terraform best practices. You can customize the linting rules in the `.tflint.hcl` file.

To run linting:

```bash
make lint
```

### Plan & Apply

You can generate and view the Terraform plan using:

```bash
make plan
```

To apply the Terraform configuration:

```bash
make apply
```

## Contributing
Instructions for contributing to the project.

1. Create a new branch (`git checkout -b feature-branch`).
2. Commit your changes (`git commit -m 'Add some feature'`).
3. Push to the branch (`git push origin feature-branch`).
4. Open a pull request.

## Contact
Contact information for the project maintainers.

- Name: Jarrod Bellmore
- Email: [jbellmore@3clife.info](mailto:jbellmore@3dlife.info)
- GitHub: [Jarrod Bellmore](https://github.com/jbellmore_3CLife)

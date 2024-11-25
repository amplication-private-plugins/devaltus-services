# Seed REST API with Micronaut

This project is a seed REST API built using the [Micronaut Framework](https://micronaut.io/). This repository provides a starting point for developing RESTful services with Micronaut. 

## Project Structure

```
/
├── src
│   ├── main
│   │   ├── java
│   │   │   ├── controllers
│   │   │   ├── models
│   │   │   ├── repositories
│   │   │   └── services
│   │   └── resources
│   └── test
│       ├── java
│       └── resources
├── Makefile
├── README.md
└── pom.xml
```
- `src/main/java/controllers`: Contains the controller classes that handle HTTP requests and responses.
- `src/main/java/models`: Contains the model classes that represent the data structures.
- `src/main/java/repositories`: Contains the repository classes that interact with the database.
- `src/main/java/services`: Contains the service classes that contain business logic.
- `src/main/resources`: Contains configuration files and other resources.
- `src/test/java`: Contains test code.
- `src/test/resources`: Contains test resources.
- `Makefile`: Contains commands to build and manage the project.
- `pom.xml`: Maven build configuration file.


## Local Development

### Dependencies

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

### Usage

The `Makefile` includes several commands to help manage the project. One of the most useful commands is the `help` target, which provides a list of available commands to build, run, and test your application locally.

To see the list of available commands, you can run:

```sh
make help
```


## GraalVM

To develop and test the Micronaut application locally, use the `make develop` command, which provides a fast and flexible environment suited for rapid iteration. This setup allows you to make changes and test them quickly during development.

However, the app is intended to be compiled into native code with GraalVM and deployed on AWS Lambda for improved performance and reduced cold start times. To ensure stability and compatibility, it’s recommended to also test the application locally in its native form. 

Run the `make serve` command to compile the application into a native executable and verify its behavior as it would run in AWS Lambda. This step helps catch potential issues early, ensuring that the natively compiled code performs as expected before deployment.

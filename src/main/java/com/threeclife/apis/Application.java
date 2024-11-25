package com.threeclife.apis;

import io.micronaut.runtime.Micronaut;
import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.info.License;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import io.swagger.v3.oas.annotations.servers.Server;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;


@OpenAPIDefinition(
    info = @Info(
        title = "Pets API",
        version = "1.0.0",
        description = "The Pets API provides a simple, efficient way to manage pet-related data, ideal for applications focused on pet care and adoption.",
        license = @License(name = "Proprietary", url = "https://3clife.info/license"),
        contact = @Contact(name = "Imraaz Rally", email = "irally@3clife.info")         
    ),

    servers = {
        @Server(url = "http://localhost:8080", description = "Local"),
        @Server(url = "https://pets.api.c3lifesandbox01use1.3clife.info", description = "Sandbox")
    }
)

@SecurityScheme(
        name = "jwt",
        type = SecuritySchemeType.HTTP,
        scheme = "bearer",
        bearerFormat = "jwt"        
)

public class Application {

    public static void main(String[] args) {
        Micronaut.run(Application.class, args);
    }
}
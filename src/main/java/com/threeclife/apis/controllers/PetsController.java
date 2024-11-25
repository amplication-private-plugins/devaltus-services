package com.threeclife.apis.controllers;

import io.micronaut.http.annotation.Body;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Delete;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.Post;
import io.micronaut.http.annotation.Put;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import jakarta.inject.Inject;

import java.util.List;

import com.threeclife.apis.models.Pet;
import com.threeclife.apis.services.PetsService;

import io.micronaut.core.annotation.NonNull;
import io.micronaut.http.MediaType;

@Controller("/pets") 
@SecurityRequirement(name = "jwt")
@ApiResponses({
    @ApiResponse(responseCode = "200", description = "Success"),
    @ApiResponse(responseCode = "401", description = "Unauthorized"),
    @ApiResponse(responseCode = "403", description = "Forbidden")
})
public class PetsController { 
    @Inject
    private final PetsService petsService;

    public PetsController (PetsService petsService) {
        this.petsService = petsService;
    }

    @Get(produces = MediaType.APPLICATION_JSON)
    @Operation(summary = "Get all Pets", description = "Retrieves a list of all Pets.")
    public List<Pet> getAllPets() {
        return petsService.getAllPets();
    }

    @Get("/{id}")
    @Operation(summary = "Get a Pet", description = "Retrieves a specific Pet by ID.")
    public Pet getPetById(Long id) {
        return petsService.getPetById(id);
    }

    @Post(consumes = MediaType.APPLICATION_JSON, produces = MediaType.APPLICATION_JSON)
    @Operation(summary = "Create a new Pet", description = "Creates a new Pet.")
    public Pet createPet(@NonNull @Body Pet pet) {
        return petsService.createPet(pet);
    }

    @Put("/{id}")
    @Operation(summary = "Update a Pet", description = "Updates a specific Pet by ID.")
    public Pet updatePetById(Long id, @NonNull @Body Pet pet) {
        return petsService.updatePet(id, pet);
    }

    @Delete("/{id}")
    @Operation(summary = "Delete a Pet", description = "Deletes a specific Pet by ID.")
    public void deletePetById(Long id) {
        petsService.deletePet(id);
    }
}

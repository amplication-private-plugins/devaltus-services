package com.threeclife.apis.services;

import java.util.List;

import com.threeclife.apis.models.Pet;
import com.threeclife.apis.repositories.PetsRepository;

import jakarta.inject.Inject;
import jakarta.inject.Singleton;

@Singleton
public class PetsService {

    @Inject
    private final PetsRepository petsRepository;

    public PetsService(PetsRepository petsRepository) {
        this.petsRepository = petsRepository;
    }

    public List<Pet> getAllPets() {
        return petsRepository.findAll();
    }

    public Pet getPetById(Long id) {
        return petsRepository.findById(id);
    }

    public Pet createPet(Pet pet) {
        return petsRepository.save(pet);
    }

    public Pet updatePet(Long id, Pet pet) {
        return petsRepository.update(id, pet);
    }

    public void deletePet(Long id) {
        Pet pet = petsRepository.findById(id);
        petsRepository.delete(pet);
    }
}

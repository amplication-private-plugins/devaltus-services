package com.threeclife.apis.repositories;

import jakarta.inject.Singleton;

import java.util.ArrayList;
import java.util.List;

import com.threeclife.apis.models.Pet;

// @Repository
// public interface PetsRepository extends CrudRepository <Pet, Long> {   
// }

// Using a SingleTon to simulate a database
@Singleton
public class PetsRepository {
    private List<Pet> pets = new ArrayList<>();

    public List<Pet> findAll() {
        return pets;
    }

    public Pet save(Pet pet) {
        pets.add(pet);
        return pet;
    }

    public void delete(Pet pet) {
        pets.remove(pet);
    }

    public Pet findById(Long id) {
        return pets.stream().filter(pet -> pet.getId().equals(id)).findFirst().orElse(null);
    }

    public Pet update(Long id, Pet pet) {
        Pet existingPet = findById(id);
        if (existingPet != null) {
            existingPet.setName(pet.getName());
        }
        return existingPet;
    }    
}
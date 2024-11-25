package com.threeclife.apis.models;

import io.micronaut.core.annotation.Introspected;
import io.micronaut.core.annotation.NonNull;
import io.micronaut.serde.annotation.Serdeable;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Serdeable
@Entity
@Introspected
public class Pet {
    @Id
    @NonNull
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Schema(description = "Identifier", example = "1")
    private Long id;

    @NonNull
    @Schema(description = "Name of the Pet", example = "Thor")
    private String name;

    public Pet() {
    }

    public Pet(Long id, String name) {
        this.name = name;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }
}

package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.world.World;
import com.ffl.playoffs.domain.model.world.WorldStatus;
import com.ffl.playoffs.domain.model.world.WorldVisibility;
import com.ffl.playoffs.domain.port.WorldRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Use case for retrieving World information.
 */
public class GetWorldUseCase {

    private final WorldRepository repository;

    public GetWorldUseCase(WorldRepository repository) {
        this.repository = repository;
    }

    /**
     * Get a world by ID.
     */
    public Optional<World> getById(UUID id) {
        return repository.findById(id);
    }

    /**
     * Get a world by its unique code.
     */
    public Optional<World> getByCode(String code) {
        return repository.findByCode(code);
    }

    /**
     * Get all worlds owned by a user (as primary owner).
     */
    public List<World> getByPrimaryOwner(UUID ownerId) {
        return repository.findByPrimaryOwnerId(ownerId);
    }

    /**
     * Get all worlds with a specific status.
     */
    public List<World> getByStatus(WorldStatus status) {
        return repository.findByStatus(status);
    }

    /**
     * Get all active worlds.
     */
    public List<World> getActiveWorlds() {
        return repository.findActiveWorlds();
    }

    /**
     * Get publicly visible worlds.
     */
    public List<World> getPubliclyVisibleWorlds() {
        return repository.findPubliclyVisibleWorlds();
    }

    /**
     * Get worlds by visibility.
     */
    public List<World> getByVisibility(WorldVisibility visibility) {
        return repository.findByVisibility(visibility);
    }

    /**
     * Search worlds by name.
     */
    public List<World> searchByName(String namePart) {
        return repository.searchByName(namePart);
    }

    /**
     * Get worlds with available member capacity.
     */
    public List<World> getWorldsWithMemberCapacity() {
        return repository.findWorldsWithMemberCapacity();
    }

    /**
     * Get count of worlds owned by a user.
     */
    public long countByPrimaryOwner(UUID ownerId) {
        return repository.countByPrimaryOwnerId(ownerId);
    }

    /**
     * Get count of active worlds.
     */
    public long countActiveWorlds() {
        return repository.countActiveWorlds();
    }

    /**
     * Check if a world exists by ID.
     */
    public boolean existsById(UUID id) {
        return repository.existsById(id);
    }

    /**
     * Check if a world code exists.
     */
    public boolean existsByCode(String code) {
        return repository.existsByCode(code);
    }
}

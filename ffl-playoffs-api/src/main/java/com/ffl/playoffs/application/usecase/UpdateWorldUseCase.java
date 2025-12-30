package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.domain.port.WorldRepository;

import java.util.UUID;

/**
 * Use case for updating an existing world.
 * Application layer - orchestrates world updates.
 */
public class UpdateWorldUseCase {

    private final WorldRepository worldRepository;

    public UpdateWorldUseCase(WorldRepository worldRepository) {
        this.worldRepository = worldRepository;
    }

    /**
     * Executes the update world use case
     * @param command the command containing world update parameters
     * @return the updated world
     * @throws IllegalArgumentException if world not found
     * @throws IllegalStateException if world cannot be edited
     */
    public World execute(UpdateWorldCommand command) {
        World world = worldRepository.findById(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World not found: " + command.getWorldId()));

        // Check if world can be edited
        if (!world.canEdit()) {
            throw new IllegalStateException("World cannot be edited in current status: " + world.getStatus());
        }

        // Update fields
        if (command.getName() != null) {
            world.setName(command.getName());
        }
        if (command.getDescription() != null) {
            world.setDescription(command.getDescription());
        }
        if (command.getNarrativeSource() != null) {
            world.setNarrativeSource(command.getNarrativeSource());
        }
        if (command.getMaxPlayers() != null) {
            world.setMaxPlayers(command.getMaxPlayers());
        }

        // Persist and return
        return worldRepository.save(world);
    }

    /**
     * Command for updating a world
     */
    public static class UpdateWorldCommand {
        private final UUID worldId;
        private String name;
        private String description;
        private String narrativeSource;
        private Integer maxPlayers;

        public UpdateWorldCommand(UUID worldId) {
            this.worldId = worldId;
        }

        public UUID getWorldId() {
            return worldId;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public String getNarrativeSource() {
            return narrativeSource;
        }

        public void setNarrativeSource(String narrativeSource) {
            this.narrativeSource = narrativeSource;
        }

        public Integer getMaxPlayers() {
            return maxPlayers;
        }

        public void setMaxPlayers(Integer maxPlayers) {
            this.maxPlayers = maxPlayers;
        }
    }
}

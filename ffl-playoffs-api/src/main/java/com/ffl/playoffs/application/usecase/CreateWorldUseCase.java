package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.domain.port.WorldRepository;

import java.util.UUID;

/**
 * Use case for creating a new world.
 * Application layer - orchestrates world creation.
 */
public class CreateWorldUseCase {

    private final WorldRepository worldRepository;

    public CreateWorldUseCase(WorldRepository worldRepository) {
        this.worldRepository = worldRepository;
    }

    /**
     * Executes the create world use case
     * @param command the command containing world creation parameters
     * @return the created world
     */
    public World execute(CreateWorldCommand command) {
        // Create the world
        World world = new World(command.getName(), command.getOwnerId());

        // Set optional fields
        if (command.getDescription() != null) {
            world.setDescription(command.getDescription());
        }
        if (command.getNarrativeSource() != null) {
            world.setNarrativeSource(command.getNarrativeSource());
        }
        if (command.getIsPublic() != null) {
            world.setIsPublic(command.getIsPublic());
        }
        if (command.getMaxPlayers() != null) {
            world.setMaxPlayers(command.getMaxPlayers());
        }

        // Persist and return
        return worldRepository.save(world);
    }

    /**
     * Command for creating a world
     */
    public static class CreateWorldCommand {
        private final String name;
        private final UUID ownerId;
        private String description;
        private String narrativeSource;
        private Boolean isPublic;
        private Integer maxPlayers;

        public CreateWorldCommand(String name, UUID ownerId) {
            this.name = name;
            this.ownerId = ownerId;
        }

        public String getName() {
            return name;
        }

        public UUID getOwnerId() {
            return ownerId;
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

        public Boolean getIsPublic() {
            return isPublic;
        }

        public void setIsPublic(Boolean isPublic) {
            this.isPublic = isPublic;
        }

        public Integer getMaxPlayers() {
            return maxPlayers;
        }

        public void setMaxPlayers(Integer maxPlayers) {
            this.maxPlayers = maxPlayers;
        }
    }
}

package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.domain.port.WorldRepository;

import java.util.UUID;

/**
 * Use case for completing a world/season
 * Application layer orchestrates domain logic
 */
public class CompleteWorldUseCase {

    private final WorldRepository worldRepository;

    public CompleteWorldUseCase(WorldRepository worldRepository) {
        this.worldRepository = worldRepository;
    }

    /**
     * Completes a world, ending the season
     *
     * @param command The complete world command
     * @return The completed World
     * @throws IllegalArgumentException if world not found
     * @throws IllegalStateException if world cannot be completed
     */
    public World execute(CompleteWorldCommand command) {
        World world = worldRepository.findById(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World not found: " + command.getWorldId()));

        world.complete(command.getReason());

        return worldRepository.save(world);
    }

    /**
     * Command object for completing a world
     */
    public static class CompleteWorldCommand {
        private final UUID worldId;
        private final String reason;

        public CompleteWorldCommand(UUID worldId, String reason) {
            this.worldId = worldId;
            this.reason = reason;
        }

        public UUID getWorldId() { return worldId; }
        public String getReason() { return reason; }
    }
}

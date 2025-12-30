package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.domain.port.WorldRepository;

import java.util.UUID;

/**
 * Use case for registering a league to a world
 * Application layer orchestrates domain logic
 */
public class RegisterLeagueToWorldUseCase {

    private final WorldRepository worldRepository;

    public RegisterLeagueToWorldUseCase(WorldRepository worldRepository) {
        this.worldRepository = worldRepository;
    }

    /**
     * Registers a league to a world
     *
     * @param command The register league command
     * @return The updated World
     * @throws IllegalArgumentException if world not found
     * @throws IllegalStateException if registration not allowed
     */
    public World execute(RegisterLeagueCommand command) {
        World world = worldRepository.findById(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World not found: " + command.getWorldId()));

        world.registerLeague(command.getLeagueId());

        return worldRepository.save(world);
    }

    /**
     * Command object for registering a league
     */
    public static class RegisterLeagueCommand {
        private final UUID worldId;
        private final UUID leagueId;

        public RegisterLeagueCommand(UUID worldId, UUID leagueId) {
            this.worldId = worldId;
            this.leagueId = leagueId;
        }

        public UUID getWorldId() { return worldId; }
        public UUID getLeagueId() { return leagueId; }
    }
}

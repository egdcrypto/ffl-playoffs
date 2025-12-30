package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.domain.model.world.WorldConfiguration;
import com.ffl.playoffs.domain.port.WorldRepository;

import java.util.UUID;

/**
 * Use case for creating a new fantasy football world
 * Application layer orchestrates domain logic
 */
public class CreateWorldUseCase {

    private final WorldRepository worldRepository;

    public CreateWorldUseCase(WorldRepository worldRepository) {
        this.worldRepository = worldRepository;
    }

    /**
     * Creates a new world with the provided configuration
     *
     * @param command The create world command
     * @return The newly created World
     * @throws IllegalArgumentException if world name already exists
     */
    public World execute(CreateWorldCommand command) {
        // Validate unique name
        if (worldRepository.existsByName(command.getName())) {
            throw new IllegalArgumentException("World name already exists: " + command.getName());
        }

        // Build configuration
        WorldConfiguration configuration = WorldConfiguration.builder()
                .season(command.getSeason())
                .startingNflWeek(command.getStartingNflWeek())
                .endingNflWeek(command.getEndingNflWeek())
                .maxLeagues(command.getMaxLeagues())
                .maxPlayersPerLeague(command.getMaxPlayersPerLeague())
                .allowLateRegistration(command.getAllowLateRegistration())
                .autoAdvanceWeeks(command.getAutoAdvanceWeeks())
                .timezone(command.getTimezone())
                .build();

        // Create world
        World world = new World(command.getName(), configuration, command.getCreatedBy());

        if (command.getDescription() != null) {
            world.setDescription(command.getDescription());
        }

        // Persist and return
        return worldRepository.save(world);
    }

    /**
     * Command object for creating a world
     */
    public static class CreateWorldCommand {
        private final String name;
        private final Integer season;
        private final UUID createdBy;
        private String description;
        private Integer startingNflWeek = 1;
        private Integer endingNflWeek = 18;
        private Integer maxLeagues = 100;
        private Integer maxPlayersPerLeague = 20;
        private Boolean allowLateRegistration = false;
        private Boolean autoAdvanceWeeks = true;
        private String timezone = "America/New_York";

        public CreateWorldCommand(String name, Integer season, UUID createdBy) {
            this.name = name;
            this.season = season;
            this.createdBy = createdBy;
        }

        // Getters
        public String getName() { return name; }
        public Integer getSeason() { return season; }
        public UUID getCreatedBy() { return createdBy; }
        public String getDescription() { return description; }
        public Integer getStartingNflWeek() { return startingNflWeek; }
        public Integer getEndingNflWeek() { return endingNflWeek; }
        public Integer getMaxLeagues() { return maxLeagues; }
        public Integer getMaxPlayersPerLeague() { return maxPlayersPerLeague; }
        public Boolean getAllowLateRegistration() { return allowLateRegistration; }
        public Boolean getAutoAdvanceWeeks() { return autoAdvanceWeeks; }
        public String getTimezone() { return timezone; }

        // Setters for optional fields
        public void setDescription(String description) { this.description = description; }
        public void setStartingNflWeek(Integer startingNflWeek) { this.startingNflWeek = startingNflWeek; }
        public void setEndingNflWeek(Integer endingNflWeek) { this.endingNflWeek = endingNflWeek; }
        public void setMaxLeagues(Integer maxLeagues) { this.maxLeagues = maxLeagues; }
        public void setMaxPlayersPerLeague(Integer maxPlayersPerLeague) { this.maxPlayersPerLeague = maxPlayersPerLeague; }
        public void setAllowLateRegistration(Boolean allowLateRegistration) { this.allowLateRegistration = allowLateRegistration; }
        public void setAutoAdvanceWeeks(Boolean autoAdvanceWeeks) { this.autoAdvanceWeeks = autoAdvanceWeeks; }
        public void setTimezone(String timezone) { this.timezone = timezone; }
    }
}

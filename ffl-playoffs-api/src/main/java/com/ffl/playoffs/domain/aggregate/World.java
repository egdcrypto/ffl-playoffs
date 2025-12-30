package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.world.SeasonInfo;
import com.ffl.playoffs.domain.model.world.WorldConfiguration;
import com.ffl.playoffs.domain.model.world.WorldStatus;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

/**
 * World aggregate root
 *
 * Represents the top-level container for a fantasy football season/tournament.
 * A World orchestrates multiple leagues, manages the season lifecycle,
 * and coordinates game progression across all participants.
 *
 * Domain model with no framework dependencies.
 */
public class World {

    private UUID id;
    private String name;
    private String description;
    private WorldStatus status;
    private WorldConfiguration configuration;
    private SeasonInfo seasonInfo;

    // League management
    private List<UUID> leagueIds;
    private Integer activeLeagueCount;

    // Lifecycle tracking
    private UUID createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime activatedAt;
    private LocalDateTime completedAt;
    private String completionReason;

    // Statistics
    private Integer totalParticipants;
    private Integer totalGamesPlayed;

    /**
     * Default constructor for creating a new World
     */
    public World() {
        this.id = UUID.randomUUID();
        this.status = WorldStatus.CREATED;
        this.leagueIds = new ArrayList<>();
        this.activeLeagueCount = 0;
        this.totalParticipants = 0;
        this.totalGamesPlayed = 0;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Constructor with essential parameters
     *
     * @param name World name
     * @param configuration World configuration
     * @param createdBy User ID who created this world
     */
    public World(String name, WorldConfiguration configuration, UUID createdBy) {
        this();
        this.name = validateName(name);
        this.configuration = Objects.requireNonNull(configuration, "Configuration is required");
        this.createdBy = Objects.requireNonNull(createdBy, "Creator ID is required");
        this.seasonInfo = SeasonInfo.fromConfiguration(configuration);
    }

    // ==================== Business Methods ====================

    /**
     * Configure the world with new settings
     * Can only be done before the world is active
     *
     * @param configuration new configuration
     * @throws IllegalStateException if world is not in configurable state
     */
    public void configure(WorldConfiguration configuration) {
        validateConfigurable();
        this.configuration = Objects.requireNonNull(configuration, "Configuration is required");
        this.seasonInfo = SeasonInfo.fromConfiguration(configuration);
        this.status = WorldStatus.CONFIGURING;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Mark the world as ready to start
     * Requires at least one league to be registered
     *
     * @throws IllegalStateException if prerequisites not met
     */
    public void markReady() {
        if (status != WorldStatus.CONFIGURING && status != WorldStatus.CREATED) {
            throw new IllegalStateException("World must be in CREATED or CONFIGURING state to mark ready");
        }

        if (configuration == null) {
            throw new IllegalStateException("World must be configured before marking ready");
        }

        this.status = WorldStatus.READY;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Activate the world to start the season
     *
     * @throws IllegalStateException if world is not ready
     */
    public void activate() {
        if (status != WorldStatus.READY) {
            throw new IllegalStateException("World must be in READY state to activate. Current: " + status);
        }

        if (leagueIds.isEmpty()) {
            throw new IllegalStateException("World must have at least one league to activate");
        }

        this.status = WorldStatus.ACTIVE;
        this.activatedAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Pause the world temporarily
     *
     * @param reason reason for pausing
     * @throws IllegalStateException if world is not active
     */
    public void pause(String reason) {
        if (status != WorldStatus.ACTIVE) {
            throw new IllegalStateException("Can only pause an active world");
        }

        this.status = WorldStatus.PAUSED;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Resume a paused world
     *
     * @throws IllegalStateException if world is not paused
     */
    public void resume() {
        if (status != WorldStatus.PAUSED) {
            throw new IllegalStateException("Can only resume a paused world");
        }

        this.status = WorldStatus.ACTIVE;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Advance to the next week
     *
     * @throws IllegalStateException if world is not active or already at last week
     */
    public void advanceWeek() {
        if (status != WorldStatus.ACTIVE) {
            throw new IllegalStateException("Can only advance week for an active world");
        }

        if (seasonInfo.isLastWeek()) {
            complete("Season completed - all weeks finished");
        } else {
            this.seasonInfo = seasonInfo.advanceWeek();
            this.updatedAt = LocalDateTime.now();
        }
    }

    /**
     * Complete the world/season
     *
     * @param reason reason for completion
     * @throws IllegalStateException if world is not active or paused
     */
    public void complete(String reason) {
        if (status != WorldStatus.ACTIVE && status != WorldStatus.PAUSED) {
            throw new IllegalStateException("Can only complete an active or paused world");
        }

        this.status = WorldStatus.COMPLETED;
        this.completedAt = LocalDateTime.now();
        this.completionReason = reason;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Cancel the world
     *
     * @param reason reason for cancellation
     * @throws IllegalStateException if world is already completed or cancelled
     */
    public void cancel(String reason) {
        if (status.isTerminal()) {
            throw new IllegalStateException("Cannot cancel a world that is already " + status);
        }

        this.status = WorldStatus.CANCELLED;
        this.completedAt = LocalDateTime.now();
        this.completionReason = reason;
        this.updatedAt = LocalDateTime.now();
    }

    // ==================== League Management ====================

    /**
     * Register a league in this world
     *
     * @param leagueId the league ID to add
     * @throws IllegalStateException if world cannot accept new leagues
     * @throws IllegalArgumentException if league already registered
     */
    public void registerLeague(UUID leagueId) {
        Objects.requireNonNull(leagueId, "League ID is required");

        if (status.isTerminal()) {
            throw new IllegalStateException("Cannot register leagues in a " + status + " world");
        }

        if (status == WorldStatus.ACTIVE && !configuration.getAllowLateRegistration()) {
            throw new IllegalStateException("Late registration is not allowed for this world");
        }

        if (leagueIds.contains(leagueId)) {
            throw new IllegalArgumentException("League is already registered in this world");
        }

        if (leagueIds.size() >= configuration.getMaxLeagues()) {
            throw new IllegalStateException(
                    String.format("World has reached maximum league limit of %d", configuration.getMaxLeagues()));
        }

        leagueIds.add(leagueId);
        activeLeagueCount++;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Unregister a league from this world
     *
     * @param leagueId the league ID to remove
     * @throws IllegalStateException if world is active
     * @throws IllegalArgumentException if league not found
     */
    public void unregisterLeague(UUID leagueId) {
        Objects.requireNonNull(leagueId, "League ID is required");

        if (status == WorldStatus.ACTIVE) {
            throw new IllegalStateException("Cannot unregister leagues from an active world");
        }

        if (!leagueIds.remove(leagueId)) {
            throw new IllegalArgumentException("League is not registered in this world");
        }

        activeLeagueCount = Math.max(0, activeLeagueCount - 1);
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Get all registered league IDs
     * @return unmodifiable list of league IDs
     */
    public List<UUID> getLeagueIds() {
        return Collections.unmodifiableList(leagueIds);
    }

    // ==================== Statistics ====================

    /**
     * Update participant count
     * @param count new total participant count
     */
    public void updateParticipantCount(int count) {
        if (count < 0) {
            throw new IllegalArgumentException("Participant count cannot be negative");
        }
        this.totalParticipants = count;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Increment games played counter
     */
    public void incrementGamesPlayed() {
        this.totalGamesPlayed++;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Update games played count
     * @param count new total games played
     */
    public void updateGamesPlayed(int count) {
        if (count < 0) {
            throw new IllegalArgumentException("Games played count cannot be negative");
        }
        this.totalGamesPlayed = count;
        this.updatedAt = LocalDateTime.now();
    }

    // ==================== Validation ====================

    private String validateName(String name) {
        if (name == null || name.isBlank()) {
            throw new IllegalArgumentException("World name cannot be null or blank");
        }
        if (name.length() > 100) {
            throw new IllegalArgumentException("World name cannot exceed 100 characters");
        }
        return name.trim();
    }

    private void validateConfigurable() {
        if (status != WorldStatus.CREATED && status != WorldStatus.CONFIGURING) {
            throw new IllegalStateException(
                    "World can only be configured in CREATED or CONFIGURING state. Current: " + status);
        }
    }

    // ==================== Query Methods ====================

    /**
     * Check if the world is active
     * @return true if active
     */
    public boolean isActive() {
        return status == WorldStatus.ACTIVE;
    }

    /**
     * Check if the world is in a terminal state
     * @return true if completed or cancelled
     */
    public boolean isTerminal() {
        return status.isTerminal();
    }

    /**
     * Check if configuration can be modified
     * @return true if configurable
     */
    public boolean isConfigurable() {
        return status == WorldStatus.CREATED || status == WorldStatus.CONFIGURING;
    }

    /**
     * Get the current NFL week
     * @return current week number
     */
    public Integer getCurrentWeek() {
        return seasonInfo != null ? seasonInfo.getCurrentWeek() : null;
    }

    /**
     * Get the current season
     * @return season year
     */
    public Integer getSeason() {
        return configuration != null ? configuration.getSeason() : null;
    }

    // ==================== Getters and Setters ====================

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = validateName(name);
        this.updatedAt = LocalDateTime.now();
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
        this.updatedAt = LocalDateTime.now();
    }

    public WorldStatus getStatus() {
        return status;
    }

    public void setStatus(WorldStatus status) {
        this.status = status;
    }

    public WorldConfiguration getConfiguration() {
        return configuration;
    }

    public void setConfiguration(WorldConfiguration configuration) {
        this.configuration = configuration;
    }

    public SeasonInfo getSeasonInfo() {
        return seasonInfo;
    }

    public void setSeasonInfo(SeasonInfo seasonInfo) {
        this.seasonInfo = seasonInfo;
    }

    public void setLeagueIds(List<UUID> leagueIds) {
        this.leagueIds = leagueIds != null ? new ArrayList<>(leagueIds) : new ArrayList<>();
    }

    public Integer getActiveLeagueCount() {
        return activeLeagueCount;
    }

    public void setActiveLeagueCount(Integer activeLeagueCount) {
        this.activeLeagueCount = activeLeagueCount;
    }

    public UUID getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(UUID createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public LocalDateTime getActivatedAt() {
        return activatedAt;
    }

    public void setActivatedAt(LocalDateTime activatedAt) {
        this.activatedAt = activatedAt;
    }

    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }

    public String getCompletionReason() {
        return completionReason;
    }

    public void setCompletionReason(String completionReason) {
        this.completionReason = completionReason;
    }

    public Integer getTotalParticipants() {
        return totalParticipants;
    }

    public void setTotalParticipants(Integer totalParticipants) {
        this.totalParticipants = totalParticipants;
    }

    public Integer getTotalGamesPlayed() {
        return totalGamesPlayed;
    }

    public void setTotalGamesPlayed(Integer totalGamesPlayed) {
        this.totalGamesPlayed = totalGamesPlayed;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        World world = (World) o;
        return Objects.equals(id, world.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return String.format("World{id=%s, name='%s', status=%s, season=%s, week=%s, leagues=%d}",
                id, name, status, getSeason(), getCurrentWeek(), leagueIds.size());
    }
}

package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.model.RosterConfiguration;
import com.ffl.playoffs.domain.model.ScoringRules;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * League entity - represents an FFL playoffs league
 * Domain model with no framework dependencies
 *
 * Aggregate root for league management with:
 * - Configurable start week (1-22) and duration (1-17 weeks)
 * - Roster configuration defining position requirements
 * - Scoring rules for PPR scoring
 * - Configuration lock mechanism to prevent changes after first game starts
 */
public class League {
    private UUID id;
    private String name;
    private String description;
    private String code;
    private UUID ownerId; // Admin who created the league
    private LeagueStatus status;

    // Week configuration
    private Integer startingWeek; // NFL week to start (1-22)
    private Integer numberOfWeeks; // Duration of league (1-17 weeks)
    private Integer currentWeek; // Current NFL week

    // Configuration
    private RosterConfiguration rosterConfiguration;
    private ScoringRules scoringRules;

    // Configuration lock
    private Boolean configurationLocked;
    private LocalDateTime configurationLockedAt;
    private String lockReason;
    private LocalDateTime firstGameStartTime;

    // Players
    private List<Player> players;

    // Metadata
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    /**
     * Default constructor initializing a new league
     */
    public League() {
        this.id = UUID.randomUUID();
        this.players = new ArrayList<>();
        this.status = LeagueStatus.DRAFT;
        this.configurationLocked = false;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Constructor with essential league parameters
     *
     * @param name League name
     * @param code Unique league code for invitations
     * @param ownerId Admin user ID who created the league
     * @param startingWeek NFL week to start (1-22)
     * @param numberOfWeeks Duration of league (1-17)
     */
    public League(String name, String code, UUID ownerId, Integer startingWeek, Integer numberOfWeeks) {
        this();
        this.name = name;
        this.code = code;
        this.ownerId = ownerId;
        setStartingWeekAndDuration(startingWeek, numberOfWeeks);
        this.currentWeek = startingWeek;
    }

    // ==================== Business Methods ====================

    /**
     * Sets the starting week and duration with validation.
     * Validates that startingWeek + numberOfWeeks - 1 <= 22
     *
     * @param startingWeek NFL week to start (1-22)
     * @param numberOfWeeks Duration of league (1-17)
     * @throws IllegalArgumentException if validation fails
     */
    public void setStartingWeekAndDuration(Integer startingWeek, Integer numberOfWeeks) {
        validateWeekConfiguration(startingWeek, numberOfWeeks);
        this.startingWeek = startingWeek;
        this.numberOfWeeks = numberOfWeeks;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Validates week configuration according to NFL calendar constraints.
     *
     * Validation rules:
     * - startingWeek must be between 1 and 18 (NFL regular season)
     * - numberOfWeeks must be between 1 and 17
     * - startingWeek + numberOfWeeks - 1 must be <= 18
     *
     * @param startingWeek NFL week to start
     * @param numberOfWeeks Duration of league
     * @throws LeagueValidationException if validation fails
     */
    private void validateWeekConfiguration(Integer startingWeek, Integer numberOfWeeks) {
        if (startingWeek == null || numberOfWeeks == null) {
            throw new LeagueValidationException("INVALID_CONFIGURATION",
                "Starting week and number of weeks cannot be null");
        }

        if (startingWeek < 1 || startingWeek > 18) {
            throw new LeagueValidationException("INVALID_STARTING_WEEK",
                String.format("Starting week must be between 1 and 18, got: %d", startingWeek));
        }

        if (numberOfWeeks < 1 || numberOfWeeks > 17) {
            throw new LeagueValidationException("INVALID_NUMBER_OF_WEEKS",
                String.format("Number of weeks must be between 1 and 17, got: %d", numberOfWeeks));
        }

        int endWeek = startingWeek + numberOfWeeks - 1;
        if (endWeek > 18) {
            throw new LeagueValidationException("LEAGUE_EXCEEDS_NFL_SEASON",
                String.format("startingWeek (%d) + numberOfWeeks (%d) - 1 exceeds NFL week 18",
                    startingWeek, numberOfWeeks));
        }
    }

    /**
     * Adds a player to the league.
     * Players can only be added before the league is archived.
     *
     * @param player The player to add
     * @throws IllegalStateException if league is archived
     */
    public void addPlayer(Player player) {
        if (this.status == LeagueStatus.ARCHIVED) {
            throw new IllegalStateException("Cannot add players to an archived league");
        }
        this.players.add(player);
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Activates the league.
     * Requires at least 2 players and valid configuration.
     * Configuration becomes locked after activation.
     *
     * @throws LeagueValidationException if league cannot be activated
     */
    public void activate() {
        if (this.status != LeagueStatus.DRAFT) {
            throw new LeagueValidationException("INVALID_STATUS",
                "League can only be activated from DRAFT status. Current status: " + this.status);
        }
        if (this.players.size() < 2) {
            throw new LeagueValidationException("INSUFFICIENT_PLAYERS",
                "League requires at least 2 players to activate");
        }
        if (this.rosterConfiguration == null) {
            this.rosterConfiguration = RosterConfiguration.standardRoster();
        }
        if (this.scoringRules == null) {
            this.scoringRules = new ScoringRules();
        }

        if (this.rosterConfiguration != null) {
            this.rosterConfiguration.validate();
        }
        this.status = LeagueStatus.ACTIVE;
        this.configurationLocked = true;
        this.configurationLockedAt = LocalDateTime.now();
        this.lockReason = "LEAGUE_ACTIVATED";
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Deactivates the league.
     * Players can no longer make new team selections.
     *
     * @throws IllegalStateException if league is not active
     */
    public void deactivate() {
        if (this.status != LeagueStatus.ACTIVE) {
            throw new IllegalStateException("League can only be deactivated from ACTIVE status. Current status: " + this.status);
        }
        this.status = LeagueStatus.INACTIVE;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Archives the league.
     * League data is preserved for historical viewing but no modifications are allowed.
     *
     * @throws IllegalStateException if league status doesn't allow archiving
     */
    public void archive() {
        if (this.status == LeagueStatus.ARCHIVED) {
            throw new IllegalStateException("League is already archived");
        }
        if (this.status == LeagueStatus.DRAFT) {
            throw new IllegalStateException("Cannot archive a league in DRAFT status. Activate first or cancel.");
        }
        this.status = LeagueStatus.ARCHIVED;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * @deprecated Use activate() instead
     * Starts the league.
     * Requires at least 2 players and valid configuration.
     *
     * @throws IllegalStateException if league cannot be started
     */
    @Deprecated
    public void start() {
        activate();
    }

    /**
     * Advances to the next week.
     * Can only advance weeks for active leagues.
     *
     * @throws IllegalStateException if league is not active
     */
    public void advanceWeek() {
        if (this.status != LeagueStatus.ACTIVE) {
            throw new IllegalStateException("Can only advance week for active leagues");
        }

        int endWeek = this.startingWeek + this.numberOfWeeks - 1;
        if (this.currentWeek >= endWeek) {
            complete();
        } else {
            this.currentWeek++;
            this.updatedAt = LocalDateTime.now();
        }
    }

    /**
     * Completes the league by archiving it.
     * Can only complete leagues that are active or inactive.
     *
     * @throws IllegalStateException if league is not active or inactive
     */
    public void complete() {
        if (this.status != LeagueStatus.ACTIVE && this.status != LeagueStatus.INACTIVE) {
            throw new IllegalStateException("Can only complete leagues that are active or inactive");
        }
        this.status = LeagueStatus.ARCHIVED;
        this.updatedAt = LocalDateTime.now();
    }

    // ==================== Configuration Lock Methods ====================

    /**
     * Checks if the configuration is locked.
     * Configuration becomes immutable once:
     * 1. Explicitly locked via lockConfiguration(), OR
     * 2. First NFL game of the starting week begins
     *
     * @param currentTime The current time to check against
     * @return true if configuration is locked, false otherwise
     */
    public boolean isConfigurationLocked(LocalDateTime currentTime) {
        if (this.configurationLocked != null && this.configurationLocked) {
            return true;
        }

        if (this.configurationLockedAt != null) {
            return true;
        }

        if (this.firstGameStartTime != null && currentTime.isAfter(firstGameStartTime)) {
            return true;
        }

        return false;
    }

    /**
     * Locks the configuration permanently.
     * Should be called when the first game of the starting NFL week begins.
     *
     * @param lockTime The time when the configuration is being locked
     * @param reason The reason for locking (e.g., "FIRST_GAME_STARTED")
     */
    public void lockConfiguration(LocalDateTime lockTime, String reason) {
        if (this.configurationLockedAt == null) {
            this.configurationLocked = true;
            this.configurationLockedAt = lockTime;
            this.lockReason = reason;
            this.updatedAt = LocalDateTime.now();
        }
    }

    /**
     * Validates that configuration can be modified.
     * Throws exception if configuration is locked.
     *
     * @param currentTime The current time to check against
     * @throws ConfigurationLockedException if configuration is locked
     */
    public void validateConfigurationMutable(LocalDateTime currentTime) {
        if (isConfigurationLocked(currentTime)) {
            throw new ConfigurationLockedException(
                "Configuration cannot be modified after the first game has started. " +
                "Locked at: " + this.configurationLockedAt + ". Reason: " + this.lockReason
            );
        }
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

    /**
     * Sets the league name with configuration lock validation.
     *
     * @param name The new league name
     * @param currentTime Current time for lock validation
     */
    public void setName(String name, LocalDateTime currentTime) {
        validateConfigurationMutable(currentTime);
        this.name = name;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Sets the league name without lock validation (for initial creation).
     *
     * @param name The league name
     */
    public void setName(String name) {
        this.name = name;
        this.updatedAt = LocalDateTime.now();
    }

    public String getDescription() {
        return description;
    }

    /**
     * Sets the league description with configuration lock validation.
     *
     * @param description The new league description
     * @param currentTime Current time for lock validation
     */
    public void setDescription(String description, LocalDateTime currentTime) {
        validateConfigurationMutable(currentTime);
        this.description = description;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Sets the league description without lock validation (for initial creation).
     *
     * @param description The league description
     */
    public void setDescription(String description) {
        this.description = description;
        this.updatedAt = LocalDateTime.now();
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public UUID getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(UUID ownerId) {
        this.ownerId = ownerId;
    }

    public LeagueStatus getStatus() {
        return status;
    }

    public void setStatus(LeagueStatus status) {
        this.status = status;
    }

    public Integer getStartingWeek() {
        return startingWeek;
    }

    /**
     * Sets the starting week with configuration lock validation.
     * Also validates the week configuration.
     *
     * @param startingWeek NFL week to start (1-22)
     * @param currentTime Current time for lock validation
     */
    public void setStartingWeek(Integer startingWeek, LocalDateTime currentTime) {
        validateConfigurationMutable(currentTime);
        if (this.numberOfWeeks != null) {
            validateWeekConfiguration(startingWeek, this.numberOfWeeks);
        }
        this.startingWeek = startingWeek;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getNumberOfWeeks() {
        return numberOfWeeks;
    }

    /**
     * Sets the number of weeks with configuration lock validation.
     * Also validates the week configuration.
     *
     * @param numberOfWeeks Duration of league (1-17)
     * @param currentTime Current time for lock validation
     */
    public void setNumberOfWeeks(Integer numberOfWeeks, LocalDateTime currentTime) {
        validateConfigurationMutable(currentTime);
        if (this.startingWeek != null) {
            validateWeekConfiguration(this.startingWeek, numberOfWeeks);
        }
        this.numberOfWeeks = numberOfWeeks;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getCurrentWeek() {
        return currentWeek;
    }

    public void setCurrentWeek(Integer currentWeek) {
        this.currentWeek = currentWeek;
    }

    public RosterConfiguration getRosterConfiguration() {
        return rosterConfiguration;
    }

    /**
     * Sets the roster configuration with configuration lock validation.
     *
     * @param rosterConfiguration The roster configuration
     * @param currentTime Current time for lock validation
     */
    public void setRosterConfiguration(RosterConfiguration rosterConfiguration, LocalDateTime currentTime) {
        validateConfigurationMutable(currentTime);
        this.rosterConfiguration = rosterConfiguration;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Sets the roster configuration without lock validation (for initial creation).
     *
     * @param rosterConfiguration The roster configuration
     */
    public void setRosterConfiguration(RosterConfiguration rosterConfiguration) {
        this.rosterConfiguration = rosterConfiguration;
        this.updatedAt = LocalDateTime.now();
    }

    public ScoringRules getScoringRules() {
        return scoringRules;
    }

    /**
     * Sets the scoring rules with configuration lock validation.
     *
     * @param scoringRules The scoring rules
     * @param currentTime Current time for lock validation
     */
    public void setScoringRules(ScoringRules scoringRules, LocalDateTime currentTime) {
        validateConfigurationMutable(currentTime);
        this.scoringRules = scoringRules;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Sets the scoring rules without lock validation (for initial creation).
     *
     * @param scoringRules The scoring rules
     */
    public void setScoringRules(ScoringRules scoringRules) {
        this.scoringRules = scoringRules;
        this.updatedAt = LocalDateTime.now();
    }

    public Boolean getConfigurationLocked() {
        return configurationLocked;
    }

    public void setConfigurationLocked(Boolean configurationLocked) {
        this.configurationLocked = configurationLocked;
    }

    public LocalDateTime getConfigurationLockedAt() {
        return configurationLockedAt;
    }

    public String getLockReason() {
        return lockReason;
    }

    public LocalDateTime getFirstGameStartTime() {
        return firstGameStartTime;
    }

    /**
     * Sets the first game start time for the starting NFL week.
     * This is used to determine when configuration becomes immutable.
     *
     * @param firstGameStartTime The start time of the first NFL game
     */
    public void setFirstGameStartTime(LocalDateTime firstGameStartTime) {
        this.firstGameStartTime = firstGameStartTime;
    }

    public List<Player> getPlayers() {
        return players;
    }

    public void setPlayers(List<Player> players) {
        this.players = players;
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

    // ==================== Enums ====================

    /**
     * League status enumeration
     */
    public enum LeagueStatus {
        DRAFT,                // League created, configuration can be modified
        ACTIVE,               // League in progress, players can make selections
        INACTIVE,             // League temporarily paused, no new selections allowed
        ARCHIVED,             // League completed and preserved for historical viewing
        CANCELLED             // League cancelled
    }

    /**
     * Custom exception for configuration lock violations
     */
    public static class ConfigurationLockedException extends RuntimeException {
        public ConfigurationLockedException(String message) {
            super(message);
        }
    }

    /**
     * Custom exception for league validation errors with error codes
     */
    public static class LeagueValidationException extends RuntimeException {
        private final String errorCode;

        public LeagueValidationException(String errorCode, String message) {
            super(message);
            this.errorCode = errorCode;
        }

        public String getErrorCode() {
            return errorCode;
        }
    }

    /**
     * Calculates the ending NFL week based on starting week and duration.
     *
     * @return The ending NFL week
     */
    public Integer getEndingWeek() {
        if (startingWeek == null || numberOfWeeks == null) {
            return null;
        }
        return startingWeek + numberOfWeeks - 1;
    }

    /**
     * Gets all NFL weeks covered by this league.
     *
     * @return List of NFL week numbers
     */
    public java.util.List<Integer> getCoveredWeeks() {
        if (startingWeek == null || numberOfWeeks == null) {
            return java.util.Collections.emptyList();
        }
        java.util.List<Integer> weeks = new ArrayList<>();
        for (int i = 0; i < numberOfWeeks; i++) {
            weeks.add(startingWeek + i);
        }
        return weeks;
    }

    /**
     * Checks if the league is in draft mode.
     *
     * @return true if league is in draft status, false otherwise
     */
    public boolean isDraft() {
        return LeagueStatus.DRAFT.equals(this.status);
    }

    /**
     * Checks if the league is currently active.
     *
     * @return true if league is active, false otherwise
     */
    public boolean isActive() {
        return LeagueStatus.ACTIVE.equals(this.status);
    }

    /**
     * Checks if the league is inactive.
     *
     * @return true if league is inactive, false otherwise
     */
    public boolean isInactive() {
        return LeagueStatus.INACTIVE.equals(this.status);
    }

    /**
     * Checks if the league has been archived.
     *
     * @return true if league is archived, false otherwise
     */
    public boolean isArchived() {
        return LeagueStatus.ARCHIVED.equals(this.status);
    }

    /**
     * Gets the number of players in the league.
     *
     * @return The player count
     */
    public int getPlayerCount() {
        return this.players != null ? this.players.size() : 0;
    }

    @Override
    public String toString() {
        return String.format(
            "League{id=%s, name='%s', owner=%s, weeks=%d-%d, status=%s, locked=%s}",
            id, name, ownerId, startingWeek, getEndingWeek(), status, configurationLocked
        );
    }
}

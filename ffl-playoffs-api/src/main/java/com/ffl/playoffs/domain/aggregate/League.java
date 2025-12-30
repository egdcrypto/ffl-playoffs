package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.LeagueStatus;
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

    // Lifecycle tracking
    private String cancellationReason;
    private LocalDateTime completedAt;
    private LocalDateTime pausedAt;
    private LocalDateTime archivedAt;
    private Integer minPlayers = 2; // Default minimum players

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
     * - startingWeek must be between 1 and 22
     * - numberOfWeeks must be between 1 and 17
     * - startingWeek + numberOfWeeks - 1 must be <= 22
     *
     * @param startingWeek NFL week to start
     * @param numberOfWeeks Duration of league
     * @throws IllegalArgumentException if validation fails
     */
    private void validateWeekConfiguration(Integer startingWeek, Integer numberOfWeeks) {
        if (startingWeek == null || numberOfWeeks == null) {
            throw new IllegalArgumentException("Starting week and number of weeks cannot be null");
        }

        if (startingWeek < 1 || startingWeek > 22) {
            throw new IllegalArgumentException(
                String.format("Starting week must be between 1 and 22, got: %d", startingWeek)
            );
        }

        if (numberOfWeeks < 1 || numberOfWeeks > 17) {
            throw new IllegalArgumentException(
                String.format("Number of weeks must be between 1 and 17, got: %d", numberOfWeeks)
            );
        }

        int endWeek = startingWeek + numberOfWeeks - 1;
        if (endWeek > 22) {
            throw new IllegalArgumentException(
                String.format(
                    "League duration exceeds NFL calendar. Starting week %d + %d weeks would end at week %d (max: 22)",
                    startingWeek, numberOfWeeks, endWeek
                )
            );
        }
    }

    /**
     * Adds a player to the league.
     * Players can only be added before the league starts.
     *
     * @param player The player to add
     * @throws IllegalStateException if league has already started
     */
    public void addPlayer(Player player) {
        if (this.status != LeagueStatus.DRAFT && this.status != LeagueStatus.WAITING_FOR_PLAYERS) {
            throw new IllegalStateException("Cannot add players to a league that has started");
        }
        this.players.add(player);
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Activates the league.
     * Requires minimum players and valid configuration.
     *
     * @throws IllegalStateException if league cannot be activated
     */
    public void activate() {
        if (!this.status.canActivate()) {
            throw new IllegalStateException("League cannot be activated in current status: " + this.status);
        }
        if (this.players.size() < this.minPlayers) {
            throw new InsufficientPlayersException(
                "At least " + this.minPlayers + " players required to activate league",
                this.minPlayers,
                this.players.size()
            );
        }
        if (this.rosterConfiguration == null) {
            throw new IncompleteConfigurationException("League requires roster configuration to activate");
        }
        if (this.scoringRules == null) {
            throw new IncompleteConfigurationException("League requires scoring rules to activate");
        }

        this.rosterConfiguration.validate();
        this.status = LeagueStatus.ACTIVE;
        this.configurationLocked = true;
        this.configurationLockedAt = LocalDateTime.now();
        this.lockReason = "LEAGUE_ACTIVATED";
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Starts the league (alias for activate for backward compatibility).
     * Requires minimum players and valid configuration.
     *
     * @throws IllegalStateException if league cannot be started
     */
    public void start() {
        activate();
    }

    /**
     * Deactivates an active league.
     * Players cannot make new selections, but existing selections are preserved.
     *
     * @throws IllegalStateException if league cannot be deactivated
     */
    public void deactivate() {
        if (!this.status.canDeactivate()) {
            throw new IllegalStateException("League cannot be deactivated in current status: " + this.status);
        }
        this.status = LeagueStatus.INACTIVE;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Reactivates an inactive league.
     * Players can make selections again from the current week.
     *
     * @throws IllegalStateException if league cannot be reactivated
     */
    public void reactivate() {
        if (this.status != LeagueStatus.INACTIVE) {
            throw new IllegalStateException("Only INACTIVE leagues can be reactivated, current status: " + this.status);
        }
        this.status = LeagueStatus.ACTIVE;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Pauses an active league.
     * All deadlines are suspended, players cannot make selections.
     *
     * @throws IllegalStateException if league cannot be paused
     */
    public void pause() {
        if (!this.status.canPause()) {
            throw new IllegalStateException("League cannot be paused in current status: " + this.status);
        }
        this.status = LeagueStatus.PAUSED;
        this.pausedAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Resumes a paused league.
     * Deadlines should be recalculated based on current date.
     *
     * @throws IllegalStateException if league cannot be resumed
     */
    public void resume() {
        if (!this.status.canResume()) {
            throw new IllegalStateException("League cannot be resumed in current status: " + this.status);
        }
        this.status = LeagueStatus.ACTIVE;
        this.pausedAt = null;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Cancels the league with a reason.
     * All selections are preserved for reference, no further actions allowed.
     *
     * @param reason The reason for cancellation
     * @throws IllegalStateException if league cannot be cancelled
     */
    public void cancel(String reason) {
        if (!this.status.canCancel()) {
            throw new IllegalStateException("League cannot be cancelled in current status: " + this.status);
        }
        this.status = LeagueStatus.CANCELLED;
        this.cancellationReason = reason;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Archives a completed league.
     * Data is preserved for historical viewing, no modifications allowed.
     *
     * @throws IllegalStateException if league cannot be archived
     */
    public void archive() {
        if (!this.status.canArchive()) {
            throw new IllegalStateException("League cannot be archived in current status: " + this.status);
        }
        this.status = LeagueStatus.ARCHIVED;
        this.archivedAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
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
     * Completes the league.
     * Can only complete leagues that are active.
     *
     * @throws IllegalStateException if league is not active
     */
    public void complete() {
        if (this.status != LeagueStatus.ACTIVE) {
            throw new IllegalStateException("Can only complete leagues that are active");
        }
        this.status = LeagueStatus.COMPLETED;
        this.completedAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Checks if the league can be deleted.
     * Only DRAFT leagues with no players can be deleted.
     *
     * @return true if the league can be deleted
     */
    public boolean canDelete() {
        return this.status.canDelete() && (this.players == null || this.players.isEmpty());
    }

    /**
     * Validates that the league can be deleted and throws exception if not.
     *
     * @throws IllegalStateException if league cannot be deleted
     */
    public void validateCanDelete() {
        if (!this.status.canDelete()) {
            throw new CannotDeleteLeagueException(
                "Cannot delete league in status " + this.status + ". Only DRAFT leagues can be deleted."
            );
        }
        if (this.players != null && !this.players.isEmpty()) {
            throw new CannotDeleteLeagueException(
                "Cannot delete league with players. League has " + this.players.size() + " players."
            );
        }
    }

    /**
     * Gets the game week number for a given NFL week.
     *
     * @param nflWeekNumber the NFL week number
     * @return the game week number (1-based) or null if NFL week is not in range
     */
    public Integer getGameWeekForNflWeek(Integer nflWeekNumber) {
        if (nflWeekNumber == null || startingWeek == null || numberOfWeeks == null) {
            return null;
        }
        if (nflWeekNumber < startingWeek || nflWeekNumber > getEndingWeek()) {
            return null;
        }
        return nflWeekNumber - startingWeek + 1;
    }

    /**
     * Gets the NFL week number for a given game week.
     *
     * @param gameWeekNumber the game week number (1-based)
     * @return the NFL week number or null if game week is out of range
     */
    public Integer getNflWeekForGameWeek(Integer gameWeekNumber) {
        if (gameWeekNumber == null || startingWeek == null || numberOfWeeks == null) {
            return null;
        }
        if (gameWeekNumber < 1 || gameWeekNumber > numberOfWeeks) {
            return null;
        }
        return startingWeek + gameWeekNumber - 1;
    }

    /**
     * Checks if the league is on its final week.
     *
     * @return true if current week is the last week
     */
    public boolean isOnFinalWeek() {
        return this.currentWeek != null && this.currentWeek.equals(getEndingWeek());
    }

    /**
     * Gets the current game week number (1-based).
     *
     * @return the current game week number
     */
    public Integer getCurrentGameWeek() {
        if (this.currentWeek == null || this.startingWeek == null) {
            return null;
        }
        return this.currentWeek - this.startingWeek + 1;
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

    // ==================== New Field Getters/Setters ====================

    public String getCancellationReason() {
        return cancellationReason;
    }

    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public LocalDateTime getPausedAt() {
        return pausedAt;
    }

    public LocalDateTime getArchivedAt() {
        return archivedAt;
    }

    public Integer getMinPlayers() {
        return minPlayers;
    }

    public void setMinPlayers(Integer minPlayers) {
        this.minPlayers = minPlayers;
    }

    // ==================== Exception Classes ====================

    /**
     * Custom exception for configuration lock violations
     */
    public static class ConfigurationLockedException extends RuntimeException {
        public ConfigurationLockedException(String message) {
            super(message);
        }
    }

    /**
     * Exception thrown when trying to activate a league with insufficient players.
     */
    public static class InsufficientPlayersException extends RuntimeException {
        private final int required;
        private final int actual;

        public InsufficientPlayersException(String message, int required, int actual) {
            super(message);
            this.required = required;
            this.actual = actual;
        }

        public int getRequired() {
            return required;
        }

        public int getActual() {
            return actual;
        }

        public String getErrorCode() {
            return "INSUFFICIENT_PLAYERS";
        }
    }

    /**
     * Exception thrown when trying to activate a league with incomplete configuration.
     */
    public static class IncompleteConfigurationException extends RuntimeException {
        public IncompleteConfigurationException(String message) {
            super(message);
        }

        public String getErrorCode() {
            return "INCOMPLETE_CONFIGURATION";
        }
    }

    /**
     * Exception thrown when trying to delete a league that cannot be deleted.
     */
    public static class CannotDeleteLeagueException extends RuntimeException {
        public CannotDeleteLeagueException(String message) {
            super(message);
        }

        public String getErrorCode() {
            return "CANNOT_DELETE_ACTIVE_LEAGUE";
        }
    }

    /**
     * Exception thrown when league validation fails.
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
     * Checks if the league is currently active.
     *
     * @return true if league is active, false otherwise
     */
    public boolean isActive() {
        return LeagueStatus.ACTIVE.equals(this.status);
    }

    /**
     * Checks if the league has been completed.
     *
     * @return true if league is completed, false otherwise
     */
    public boolean isCompleted() {
        return LeagueStatus.COMPLETED.equals(this.status);
    }

    @Override
    public String toString() {
        return String.format(
            "League{id=%s, name='%s', owner=%s, weeks=%d-%d, status=%s, locked=%s}",
            id, name, ownerId, startingWeek, getEndingWeek(), status, configurationLocked
        );
    }
}

package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.port.LeagueRepository;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Use case for validating and enforcing league configuration lock rules
 * Checks if configuration can be modified based on first game start time
 */
public class ValidateConfigurationLockUseCase {

    private final LeagueRepository leagueRepository;

    public ValidateConfigurationLockUseCase(LeagueRepository leagueRepository) {
        this.leagueRepository = leagueRepository;
    }

    /**
     * Validates whether a league's configuration is locked.
     * Returns the lock status without throwing an exception.
     *
     * @param query The validation query
     * @return ConfigurationLockStatus indicating if configuration is locked
     * @throws IllegalArgumentException if league not found
     */
    public ConfigurationLockStatus execute(ValidateConfigurationLockQuery query) {
        // Find league
        League league = leagueRepository.findById(query.getLeagueId())
                .orElseThrow(() -> new IllegalArgumentException("League not found"));

        LocalDateTime checkTime = query.getCheckTime() != null ? query.getCheckTime() : LocalDateTime.now();

        boolean isLocked = league.isConfigurationLocked(checkTime);

        return new ConfigurationLockStatus(
                league.getId(),
                isLocked,
                league.getConfigurationLockedAt(),
                league.getLockReason(),
                league.getFirstGameStartTime()
        );
    }

    /**
     * Locks a league's configuration permanently.
     * Should be called when the first NFL game of the starting week begins.
     *
     * @param command The lock configuration command
     * @return The updated League entity
     * @throws IllegalArgumentException if league not found
     */
    public League lockConfiguration(LockConfigurationCommand command) {
        // Find league
        League league = leagueRepository.findById(command.getLeagueId())
                .orElseThrow(() -> new IllegalArgumentException("League not found"));

        LocalDateTime lockTime = command.getLockTime() != null ? command.getLockTime() : LocalDateTime.now();
        String lockReason = command.getLockReason() != null ? command.getLockReason() : "FIRST_GAME_STARTED";

        // Lock the configuration
        league.lockConfiguration(lockTime, lockReason);

        // Persist updated league
        return leagueRepository.save(league);
    }

    /**
     * Query object for validating configuration lock status
     */
    public static class ValidateConfigurationLockQuery {
        private final UUID leagueId;
        private LocalDateTime checkTime;

        public ValidateConfigurationLockQuery(UUID leagueId) {
            this.leagueId = leagueId;
        }

        public UUID getLeagueId() {
            return leagueId;
        }

        public LocalDateTime getCheckTime() {
            return checkTime;
        }

        public void setCheckTime(LocalDateTime checkTime) {
            this.checkTime = checkTime;
        }
    }

    /**
     * Command object for locking configuration
     */
    public static class LockConfigurationCommand {
        private final UUID leagueId;
        private LocalDateTime lockTime;
        private String lockReason;

        public LockConfigurationCommand(UUID leagueId) {
            this.leagueId = leagueId;
        }

        public UUID getLeagueId() {
            return leagueId;
        }

        public LocalDateTime getLockTime() {
            return lockTime;
        }

        public void setLockTime(LocalDateTime lockTime) {
            this.lockTime = lockTime;
        }

        public String getLockReason() {
            return lockReason;
        }

        public void setLockReason(String lockReason) {
            this.lockReason = lockReason;
        }
    }

    /**
     * Result object containing configuration lock status
     */
    public static class ConfigurationLockStatus {
        private final UUID leagueId;
        private final boolean isLocked;
        private final LocalDateTime lockedAt;
        private final String lockReason;
        private final LocalDateTime firstGameStartTime;

        public ConfigurationLockStatus(
                UUID leagueId,
                boolean isLocked,
                LocalDateTime lockedAt,
                String lockReason,
                LocalDateTime firstGameStartTime) {
            this.leagueId = leagueId;
            this.isLocked = isLocked;
            this.lockedAt = lockedAt;
            this.lockReason = lockReason;
            this.firstGameStartTime = firstGameStartTime;
        }

        public UUID getLeagueId() {
            return leagueId;
        }

        public boolean isLocked() {
            return isLocked;
        }

        public LocalDateTime getLockedAt() {
            return lockedAt;
        }

        public String getLockReason() {
            return lockReason;
        }

        public LocalDateTime getFirstGameStartTime() {
            return firstGameStartTime;
        }
    }
}

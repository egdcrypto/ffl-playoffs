package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.model.RosterLockStatus;
import com.ffl.playoffs.domain.port.RosterRepository;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

/**
 * Use case for validating that roster changes are allowed.
 * Implements the one-time draft model rules:
 * - No roster changes after lock deadline
 * - No trades allowed after roster lock
 * - No waiver wire/free agent pickups after lock
 * - No emergency unlocks allowed (strict enforcement)
 */
public class PreventRosterChangeUseCase {

    private final RosterRepository rosterRepository;

    public PreventRosterChangeUseCase(RosterRepository rosterRepository) {
        this.rosterRepository = rosterRepository;
    }

    /**
     * Validates that a roster change is allowed.
     *
     * @param command The validation command
     * @return ValidationResult indicating if the change is allowed
     */
    public ChangeValidationResult validateChange(ValidateChangeCommand command) {
        // Find the roster
        Optional<Roster> rosterOpt = rosterRepository.findById(command.getRosterId());

        if (rosterOpt.isEmpty()) {
            return ChangeValidationResult.denied(
                    command.getChangeType(),
                    "ROSTER_NOT_FOUND",
                    "Roster not found"
            );
        }

        Roster roster = rosterOpt.get();

        // Check if roster is locked
        if (roster.isLocked() || (roster.getLockStatus() != null && roster.getLockStatus().isLocked())) {
            return getDeniedResultForLockedRoster(command.getChangeType(), roster);
        }

        // Check if deadline has passed (even if not formally locked yet)
        if (roster.getRosterDeadline() != null &&
                command.getRequestTime().isAfter(roster.getRosterDeadline())) {
            return ChangeValidationResult.denied(
                    command.getChangeType(),
                    "ROSTER_LOCKED",
                    "Roster deadline has passed - no changes allowed"
            );
        }

        // Change is allowed
        return ChangeValidationResult.allowed(command.getChangeType());
    }

    /**
     * Validates that a trade is allowed between two rosters.
     *
     * @param command The trade validation command
     * @return ValidationResult indicating if the trade is allowed
     */
    public ChangeValidationResult validateTrade(ValidateTradeCommand command) {
        // Check proposing roster
        ChangeValidationResult proposerResult = validateChange(
                new ValidateChangeCommand(
                        command.getProposingRosterId(),
                        ChangeType.TRADE,
                        command.getRequestTime()
                )
        );

        if (!proposerResult.isAllowed()) {
            return ChangeValidationResult.denied(
                    ChangeType.TRADE,
                    "TRADES_NOT_ALLOWED",
                    "This league uses one-time draft - no trades"
            );
        }

        // Check receiving roster
        ChangeValidationResult receiverResult = validateChange(
                new ValidateChangeCommand(
                        command.getReceivingRosterId(),
                        ChangeType.TRADE,
                        command.getRequestTime()
                )
        );

        if (!receiverResult.isAllowed()) {
            return ChangeValidationResult.denied(
                    ChangeType.TRADE,
                    "TRADES_NOT_ALLOWED",
                    "This league uses one-time draft - no trades"
            );
        }

        return ChangeValidationResult.allowed(ChangeType.TRADE);
    }

    /**
     * Gets time until roster lock deadline.
     *
     * @param rosterId The roster ID
     * @param currentTime Current time
     * @return Optional duration until lock, empty if deadline has passed or no deadline set
     */
    public Optional<Duration> getTimeUntilLock(UUID rosterId, LocalDateTime currentTime) {
        Optional<Roster> rosterOpt = rosterRepository.findById(rosterId);

        if (rosterOpt.isEmpty()) {
            return Optional.empty();
        }

        Roster roster = rosterOpt.get();

        if (roster.isLocked()) {
            return Optional.empty();
        }

        if (roster.getRosterDeadline() == null) {
            return Optional.empty();
        }

        if (currentTime.isAfter(roster.getRosterDeadline())) {
            return Optional.empty();
        }

        return Optional.of(Duration.between(currentTime, roster.getRosterDeadline()));
    }

    private ChangeValidationResult getDeniedResultForLockedRoster(ChangeType changeType, Roster roster) {
        String errorCode;
        String message;

        switch (changeType) {
            case TRADE:
                errorCode = "TRADES_NOT_ALLOWED";
                message = "This league uses one-time draft - no trades";
                break;
            case ADD_PLAYER:
            case DROP_PLAYER:
                errorCode = "ROSTER_LOCKED";
                message = "No roster changes allowed - one-time draft model";
                break;
            case WAIVER_CLAIM:
                errorCode = "ROSTER_LOCKED";
                message = "No waiver wire pickups allowed - one-time draft model";
                break;
            case EDIT_POSITION:
                errorCode = "ROSTER_LOCKED";
                message = "Rosters are locked for the season - no changes allowed";
                break;
            default:
                errorCode = "ROSTER_LOCKED";
                message = "Roster is locked for the season";
        }

        return ChangeValidationResult.denied(changeType, errorCode, message);
    }

    /**
     * Types of roster changes
     */
    public enum ChangeType {
        ADD_PLAYER,
        DROP_PLAYER,
        TRADE,
        WAIVER_CLAIM,
        EDIT_POSITION
    }

    /**
     * Command for validating a roster change
     */
    public static class ValidateChangeCommand {
        private final UUID rosterId;
        private final ChangeType changeType;
        private final LocalDateTime requestTime;

        public ValidateChangeCommand(UUID rosterId, ChangeType changeType) {
            this(rosterId, changeType, LocalDateTime.now());
        }

        public ValidateChangeCommand(UUID rosterId, ChangeType changeType, LocalDateTime requestTime) {
            this.rosterId = rosterId;
            this.changeType = changeType;
            this.requestTime = requestTime;
        }

        public UUID getRosterId() {
            return rosterId;
        }

        public ChangeType getChangeType() {
            return changeType;
        }

        public LocalDateTime getRequestTime() {
            return requestTime;
        }
    }

    /**
     * Command for validating a trade
     */
    public static class ValidateTradeCommand {
        private final UUID proposingRosterId;
        private final UUID receivingRosterId;
        private final LocalDateTime requestTime;

        public ValidateTradeCommand(UUID proposingRosterId, UUID receivingRosterId) {
            this(proposingRosterId, receivingRosterId, LocalDateTime.now());
        }

        public ValidateTradeCommand(UUID proposingRosterId, UUID receivingRosterId, LocalDateTime requestTime) {
            this.proposingRosterId = proposingRosterId;
            this.receivingRosterId = receivingRosterId;
            this.requestTime = requestTime;
        }

        public UUID getProposingRosterId() {
            return proposingRosterId;
        }

        public UUID getReceivingRosterId() {
            return receivingRosterId;
        }

        public LocalDateTime getRequestTime() {
            return requestTime;
        }
    }

    /**
     * Result of change validation
     */
    public static class ChangeValidationResult {
        private final ChangeType changeType;
        private final boolean allowed;
        private final String errorCode;
        private final String message;

        private ChangeValidationResult(ChangeType changeType, boolean allowed, String errorCode, String message) {
            this.changeType = changeType;
            this.allowed = allowed;
            this.errorCode = errorCode;
            this.message = message;
        }

        public static ChangeValidationResult allowed(ChangeType changeType) {
            return new ChangeValidationResult(changeType, true, null, null);
        }

        public static ChangeValidationResult denied(ChangeType changeType, String errorCode, String message) {
            return new ChangeValidationResult(changeType, false, errorCode, message);
        }

        public ChangeType getChangeType() {
            return changeType;
        }

        public boolean isAllowed() {
            return allowed;
        }

        public boolean isDenied() {
            return !allowed;
        }

        public String getErrorCode() {
            return errorCode;
        }

        public String getMessage() {
            return message;
        }
    }
}

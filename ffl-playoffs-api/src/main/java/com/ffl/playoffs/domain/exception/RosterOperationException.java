package com.ffl.playoffs.domain.exception;

/**
 * Domain exception for roster operations
 * Contains error codes for specific failure scenarios
 */
public class RosterOperationException extends RuntimeException {

    private final ErrorCode errorCode;
    private final String details;

    public RosterOperationException(ErrorCode errorCode, String message) {
        super(message);
        this.errorCode = errorCode;
        this.details = null;
    }

    public RosterOperationException(ErrorCode errorCode, String message, String details) {
        super(message);
        this.errorCode = errorCode;
        this.details = details;
    }

    public ErrorCode getErrorCode() {
        return errorCode;
    }

    public String getDetails() {
        return details;
    }

    /**
     * Error codes for roster operations
     */
    public enum ErrorCode {
        // Player validation errors
        PLAYER_NOT_FOUND("NFL player not found"),
        PLAYER_INACTIVE("NFL player is not active"),
        PLAYER_ALREADY_DRAFTED("Player is already on your roster"),

        // Position validation errors
        POSITION_MISMATCH("Player position cannot fill requested slot"),
        POSITION_NOT_ELIGIBLE_FOR_FLEX("Position is not eligible for FLEX slot"),
        POSITION_NOT_ELIGIBLE_FOR_SUPERFLEX("Position is not eligible for SUPERFLEX slot"),
        POSITION_LIMIT_EXCEEDED("Position slots are full"),
        POSITION_NOT_IN_CONFIGURATION("Position is not configured for this league"),

        // Roster state errors
        ROSTER_NOT_FOUND("Roster not found"),
        ROSTER_SLOT_NOT_FOUND("Roster slot not found"),
        ROSTER_PERMANENTLY_LOCKED("Roster is permanently locked - no changes allowed"),
        ROSTER_DEADLINE_PASSED("Roster deadline has passed"),
        ROSTER_INCOMPLETE("Roster is not complete"),

        // Draft order errors
        NOT_YOUR_TURN("It is not your turn to draft"),
        DRAFT_NOT_ACTIVE("Draft is not currently active"),

        // General errors
        INVALID_OPERATION("Invalid roster operation");

        private final String defaultMessage;

        ErrorCode(String defaultMessage) {
            this.defaultMessage = defaultMessage;
        }

        public String getDefaultMessage() {
            return defaultMessage;
        }
    }

    /**
     * Factory method for position mismatch error
     */
    public static RosterOperationException positionMismatch(String playerName, String playerPosition, String slotPosition) {
        return new RosterOperationException(
                ErrorCode.POSITION_MISMATCH,
                String.format("%s (%s) cannot be drafted to %s position", playerName, playerPosition, slotPosition),
                String.format("playerPosition=%s, slotPosition=%s", playerPosition, slotPosition)
        );
    }

    /**
     * Factory method for player already drafted error
     */
    public static RosterOperationException playerAlreadyDrafted(String playerName, String existingPosition) {
        return new RosterOperationException(
                ErrorCode.PLAYER_ALREADY_DRAFTED,
                String.format("You have already drafted %s to position %s", playerName, existingPosition),
                String.format("existingPosition=%s", existingPosition)
        );
    }

    /**
     * Factory method for position limit exceeded error
     */
    public static RosterOperationException positionLimitExceeded(String position, int filled, int max) {
        return new RosterOperationException(
                ErrorCode.POSITION_LIMIT_EXCEEDED,
                String.format("%s position slots are full (%d/%d)", position, filled, max),
                String.format("filled=%d, max=%d", filled, max)
        );
    }

    /**
     * Factory method for player not found error
     */
    public static RosterOperationException playerNotFound(Long playerId) {
        return new RosterOperationException(
                ErrorCode.PLAYER_NOT_FOUND,
                String.format("NFL player with id %d not found", playerId),
                String.format("playerId=%d", playerId)
        );
    }

    /**
     * Factory method for player inactive error
     */
    public static RosterOperationException playerInactive(String playerName, String status) {
        return new RosterOperationException(
                ErrorCode.PLAYER_INACTIVE,
                String.format("%s is not active (status: %s)", playerName, status),
                String.format("status=%s", status)
        );
    }

    /**
     * Factory method for roster locked error
     */
    public static RosterOperationException rosterLocked() {
        return new RosterOperationException(
                ErrorCode.ROSTER_PERMANENTLY_LOCKED,
                "Roster is permanently locked - no changes allowed after first game starts"
        );
    }

    /**
     * Factory method for flex ineligible error
     */
    public static RosterOperationException notEligibleForFlex(String position) {
        return new RosterOperationException(
                ErrorCode.POSITION_NOT_ELIGIBLE_FOR_FLEX,
                String.format("%s is not eligible for FLEX position (accepts: RB, WR, TE)", position),
                String.format("position=%s, eligiblePositions=RB,WR,TE", position)
        );
    }

    /**
     * Factory method for superflex ineligible error
     */
    public static RosterOperationException notEligibleForSuperflex(String position) {
        return new RosterOperationException(
                ErrorCode.POSITION_NOT_ELIGIBLE_FOR_SUPERFLEX,
                String.format("%s is not eligible for SUPERFLEX position (accepts: QB, RB, WR, TE)", position),
                String.format("position=%s, eligiblePositions=QB,RB,WR,TE", position)
        );
    }
}

package com.ffl.playoffs.domain.exception;

/**
 * Domain exception for roster operations
 * Provides specific error codes for roster-related failures
 * Supports the one-time draft model with permanent roster locks
 */
public class RosterOperationException extends RuntimeException {

    private final ErrorCode errorCode;
    private final String details;

    public enum ErrorCode {
        // Player-related errors
        PLAYER_NOT_FOUND("Player not found"),
        PLAYER_INACTIVE("Player is inactive or retired"),
        PLAYER_ALREADY_DRAFTED("Player is already on your roster"),

        // Position-related errors
        POSITION_MISMATCH("Player position does not match slot"),
        POSITION_NOT_ELIGIBLE_FOR_FLEX("Position not eligible for FLEX slot"),
        POSITION_NOT_ELIGIBLE_FOR_SUPERFLEX("Position not eligible for SUPERFLEX slot"),
        POSITION_LIMIT_EXCEEDED("Position limit exceeded"),
        POSITION_NOT_IN_CONFIGURATION("Position not in roster configuration"),

        // Roster state errors
        ROSTER_NOT_FOUND("Roster not found"),
        ROSTER_SLOT_NOT_FOUND("Roster slot not found"),
        ROSTER_PERMANENTLY_LOCKED("Roster is permanently locked - no changes allowed for entire season"),
        ROSTER_DEADLINE_PASSED("Roster deadline has passed"),
        ROSTER_INCOMPLETE("Roster is incomplete"),
        ROSTER_ALREADY_LOCKED("Roster is already locked"),

        // Lock-related errors
        LOCK_AFTER_GAME_START("Roster lock must be before first game starts"),
        UNLOCK_NOT_ALLOWED("Roster unlock not allowed - one-time draft model"),

        // Draft model errors
        TRADES_NOT_ALLOWED("Trades not available - this is a one-time draft league"),
        WAIVER_NOT_ALLOWED("Waiver wire not available - this is a one-time draft league"),

        // General errors
        NOT_YOUR_TURN("Not your turn to draft"),
        DRAFT_NOT_ACTIVE("Draft is not active"),
        INVALID_OPERATION("Invalid operation");

        private final String defaultMessage;

        ErrorCode(String defaultMessage) {
            this.defaultMessage = defaultMessage;
        }

        public String getDefaultMessage() {
            return defaultMessage;
        }
    }

    public RosterOperationException(ErrorCode errorCode) {
        super(errorCode.getDefaultMessage());
        this.errorCode = errorCode;
        this.details = null;
    }

    public RosterOperationException(ErrorCode errorCode, String details) {
        super(details != null ? details : errorCode.getDefaultMessage());
        this.errorCode = errorCode;
        this.details = details;
    }

    public RosterOperationException(ErrorCode errorCode, String details, Throwable cause) {
        super(details != null ? details : errorCode.getDefaultMessage(), cause);
        this.errorCode = errorCode;
        this.details = details;
    }

    public ErrorCode getErrorCode() {
        return errorCode;
    }

    public String getDetails() {
        return details;
    }

    // Factory methods for common errors
    public static RosterOperationException rosterNotFound() {
        return new RosterOperationException(ErrorCode.ROSTER_NOT_FOUND);
    }

    public static RosterOperationException rosterPermanentlyLocked() {
        return new RosterOperationException(ErrorCode.ROSTER_PERMANENTLY_LOCKED);
    }

    public static RosterOperationException rosterAlreadyLocked() {
        return new RosterOperationException(ErrorCode.ROSTER_ALREADY_LOCKED);
    }

    public static RosterOperationException playerNotFound(Long playerId) {
        return new RosterOperationException(ErrorCode.PLAYER_NOT_FOUND,
                String.format("NFL Player with ID %d not found", playerId));
    }

    public static RosterOperationException playerInactive(String playerName, String status) {
        return new RosterOperationException(ErrorCode.PLAYER_INACTIVE,
                String.format("%s is %s and cannot be drafted", playerName, status));
    }

    public static RosterOperationException playerAlreadyDrafted(String playerName, String existingPosition) {
        return new RosterOperationException(ErrorCode.PLAYER_ALREADY_DRAFTED,
                String.format("%s is already on your roster in position %s", playerName, existingPosition));
    }

    public static RosterOperationException positionMismatch(String playerName, String playerPosition, String slotPosition) {
        return new RosterOperationException(ErrorCode.POSITION_MISMATCH,
                String.format("%s (%s) cannot fill %s slot", playerName, playerPosition, slotPosition));
    }

    public static RosterOperationException notEligibleForFlex(String position) {
        return new RosterOperationException(ErrorCode.POSITION_NOT_ELIGIBLE_FOR_FLEX,
                String.format("%s not eligible for FLEX - only RB, WR, TE allowed", position));
    }

    public static RosterOperationException notEligibleForSuperflex(String position) {
        return new RosterOperationException(ErrorCode.POSITION_NOT_ELIGIBLE_FOR_SUPERFLEX,
                String.format("%s not eligible for SUPERFLEX - only QB, RB, WR, TE allowed", position));
    }

    public static RosterOperationException positionLimitExceeded(String position, int current, int max) {
        return new RosterOperationException(ErrorCode.POSITION_LIMIT_EXCEEDED,
                String.format("%s position limit reached (%d/%d)", position, current, max));
    }

    public static RosterOperationException slotNotFound(String slotId) {
        return new RosterOperationException(ErrorCode.ROSTER_SLOT_NOT_FOUND,
                String.format("Roster slot %s not found", slotId));
    }

    public static RosterOperationException unlockNotAllowed() {
        return new RosterOperationException(ErrorCode.UNLOCK_NOT_ALLOWED,
                "Roster unlock not allowed - this league uses a one-time draft model");
    }

    public static RosterOperationException tradesNotAllowed() {
        return new RosterOperationException(ErrorCode.TRADES_NOT_ALLOWED);
    }

    public static RosterOperationException waiverNotAllowed() {
        return new RosterOperationException(ErrorCode.WAIVER_NOT_ALLOWED);
    }

    public static RosterOperationException lockAfterGameStart() {
        return new RosterOperationException(ErrorCode.LOCK_AFTER_GAME_START);
    }
}

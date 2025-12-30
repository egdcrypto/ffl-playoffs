package com.ffl.playoffs.domain.event;

import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterLockStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Domain event emitted when a roster is locked.
 * This event is raised when the roster lock deadline passes and rosters
 * are permanently locked for the season (one-time draft model).
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RosterLockedEvent {

    /**
     * Unique identifier for this event
     */
    private UUID eventId;

    /**
     * The roster that was locked
     */
    private UUID rosterId;

    /**
     * The league player who owns the roster
     */
    private UUID leaguePlayerId;

    /**
     * The league/game this roster belongs to
     */
    private UUID leagueId;

    /**
     * The resulting lock status (LOCKED or LOCKED_INCOMPLETE)
     */
    private RosterLockStatus lockStatus;

    /**
     * Timestamp when the roster was locked
     */
    private LocalDateTime lockedAt;

    /**
     * List of positions that are missing (empty if roster is complete)
     */
    private List<Position> missingPositions;

    /**
     * Total number of filled slots
     */
    private int filledSlotCount;

    /**
     * Total number of roster slots
     */
    private int totalSlotCount;

    /**
     * Whether the roster was locked at deadline (vs manual lock)
     */
    private boolean lockedAtDeadline;

    /**
     * Creates an event for a complete roster lock
     */
    public static RosterLockedEvent forCompleteLock(
            UUID rosterId,
            UUID leaguePlayerId,
            UUID leagueId,
            LocalDateTime lockedAt,
            int totalSlots,
            boolean atDeadline) {
        return RosterLockedEvent.builder()
                .eventId(UUID.randomUUID())
                .rosterId(rosterId)
                .leaguePlayerId(leaguePlayerId)
                .leagueId(leagueId)
                .lockStatus(RosterLockStatus.LOCKED)
                .lockedAt(lockedAt)
                .missingPositions(List.of())
                .filledSlotCount(totalSlots)
                .totalSlotCount(totalSlots)
                .lockedAtDeadline(atDeadline)
                .build();
    }

    /**
     * Creates an event for an incomplete roster lock
     */
    public static RosterLockedEvent forIncompleteLock(
            UUID rosterId,
            UUID leaguePlayerId,
            UUID leagueId,
            LocalDateTime lockedAt,
            List<Position> missingPositions,
            int filledSlots,
            int totalSlots) {
        return RosterLockedEvent.builder()
                .eventId(UUID.randomUUID())
                .rosterId(rosterId)
                .leaguePlayerId(leaguePlayerId)
                .leagueId(leagueId)
                .lockStatus(RosterLockStatus.LOCKED_INCOMPLETE)
                .lockedAt(lockedAt)
                .missingPositions(missingPositions)
                .filledSlotCount(filledSlots)
                .totalSlotCount(totalSlots)
                .lockedAtDeadline(true) // Incomplete locks only happen at deadline
                .build();
    }

    /**
     * Checks if the roster was locked with missing positions
     */
    public boolean isIncomplete() {
        return lockStatus == RosterLockStatus.LOCKED_INCOMPLETE;
    }

    /**
     * Checks if the roster was locked with all positions filled
     */
    public boolean isComplete() {
        return lockStatus == RosterLockStatus.LOCKED;
    }
}

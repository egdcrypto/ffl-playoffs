package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.exception.RosterOperationException;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterStatus;
import com.ffl.playoffs.domain.port.RosterRepository;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Use case for retrieving roster lock status and countdown information.
 *
 * Provides:
 * - Current lock status (UNLOCKED, LOCKED, LOCKED_INCOMPLETE)
 * - Time until permanent lock (countdown)
 * - Lock warning message for incomplete rosters
 * - Missing positions for incomplete rosters
 */
public class GetRosterLockStatusUseCase {

    private final RosterRepository rosterRepository;

    public GetRosterLockStatusUseCase(RosterRepository rosterRepository) {
        this.rosterRepository = rosterRepository;
    }

    /**
     * Get the lock status for a roster including countdown information.
     *
     * @param command The get status command
     * @return RosterLockStatus with countdown and warnings
     * @throws RosterOperationException if roster not found
     */
    public RosterLockStatus execute(GetStatusCommand command) {
        Roster roster = rosterRepository.findById(command.getRosterId())
                .orElseThrow(RosterOperationException::rosterNotFound);

        LocalDateTime now = command.getCurrentTime() != null
                ? command.getCurrentTime()
                : LocalDateTime.now();

        // Build countdown if applicable
        String countdown = null;
        String lockWarning = null;
        boolean showUrgentWarning = false;

        if (!roster.isLocked() && roster.getRosterDeadline() != null) {
            LocalDateTime deadline = roster.getRosterDeadline();

            if (now.isBefore(deadline)) {
                Duration duration = Duration.between(now, deadline);
                countdown = formatDuration(duration);

                // Show urgent warning if less than 24 hours remain
                if (duration.toHours() < 24) {
                    showUrgentWarning = true;

                    if (!roster.isComplete()) {
                        lockWarning = String.format(
                                "PERMANENT ROSTER LOCK in %s - Complete your roster before first game - NO changes allowed after lock",
                                countdown
                        );
                    } else {
                        lockWarning = String.format("Roster locks in %s", countdown);
                    }
                }
            }
        }

        // Build missing positions message
        List<Position> missingPositions = roster.getMissingPositions();
        String incompleteMessage = null;
        if (!missingPositions.isEmpty()) {
            incompleteMessage = String.format(
                    "Missing positions: %s - you will score 0 points for these positions if roster is locked incomplete",
                    missingPositions
            );
        }

        // Build status message
        String statusMessage = buildStatusMessage(roster);

        return RosterLockStatus.builder()
                .rosterId(roster.getId())
                .status(roster.getStatus())
                .isLocked(roster.isLocked())
                .lockedAt(roster.getLockedAt())
                .rosterDeadline(roster.getRosterDeadline())
                .isComplete(roster.isComplete())
                .filledSlots(roster.getFilledSlotCount())
                .totalSlots(roster.getTotalSlotCount())
                .missingPositions(missingPositions)
                .countdown(countdown)
                .lockWarning(lockWarning)
                .showUrgentWarning(showUrgentWarning)
                .incompleteMessage(incompleteMessage)
                .statusMessage(statusMessage)
                .isOneTimeDraftModel(true)
                .build();
    }

    /**
     * Format duration as human-readable countdown
     */
    private String formatDuration(Duration duration) {
        long days = duration.toDays();
        long hours = duration.toHoursPart();
        long minutes = duration.toMinutesPart();

        if (days > 0) {
            return String.format("%d days %d hours", days, hours);
        } else if (hours > 0) {
            return String.format("%d hours %d minutes", hours, minutes);
        } else {
            return String.format("%d minutes", minutes);
        }
    }

    /**
     * Build status message based on roster state
     */
    private String buildStatusMessage(Roster roster) {
        if (roster.isLocked()) {
            if (roster.isComplete()) {
                return "Roster locked for the season";
            } else {
                return "Roster locked with empty positions - 0 points for missing positions";
            }
        }

        if (roster.isComplete()) {
            return "Roster complete - ready for lock";
        } else {
            int filled = roster.getFilledSlotCount();
            int total = roster.getTotalSlotCount();
            int remaining = total - filled;
            return String.format("Roster incomplete: %d of %d positions filled (%d remaining)",
                    filled, total, remaining);
        }
    }

    /**
     * Command for getting roster lock status
     */
    public static class GetStatusCommand {
        private final UUID rosterId;
        private final LocalDateTime currentTime;

        public GetStatusCommand(UUID rosterId) {
            this(rosterId, null);
        }

        public GetStatusCommand(UUID rosterId, LocalDateTime currentTime) {
            this.rosterId = rosterId;
            this.currentTime = currentTime;
        }

        public UUID getRosterId() {
            return rosterId;
        }

        public LocalDateTime getCurrentTime() {
            return currentTime;
        }
    }

    /**
     * Roster lock status result
     */
    public static class RosterLockStatus {
        private final UUID rosterId;
        private final RosterStatus status;
        private final boolean isLocked;
        private final LocalDateTime lockedAt;
        private final LocalDateTime rosterDeadline;
        private final boolean isComplete;
        private final int filledSlots;
        private final int totalSlots;
        private final List<Position> missingPositions;
        private final String countdown;
        private final String lockWarning;
        private final boolean showUrgentWarning;
        private final String incompleteMessage;
        private final String statusMessage;
        private final boolean isOneTimeDraftModel;

        private RosterLockStatus(Builder builder) {
            this.rosterId = builder.rosterId;
            this.status = builder.status;
            this.isLocked = builder.isLocked;
            this.lockedAt = builder.lockedAt;
            this.rosterDeadline = builder.rosterDeadline;
            this.isComplete = builder.isComplete;
            this.filledSlots = builder.filledSlots;
            this.totalSlots = builder.totalSlots;
            this.missingPositions = builder.missingPositions;
            this.countdown = builder.countdown;
            this.lockWarning = builder.lockWarning;
            this.showUrgentWarning = builder.showUrgentWarning;
            this.incompleteMessage = builder.incompleteMessage;
            this.statusMessage = builder.statusMessage;
            this.isOneTimeDraftModel = builder.isOneTimeDraftModel;
        }

        public UUID getRosterId() {
            return rosterId;
        }

        public RosterStatus getStatus() {
            return status;
        }

        public boolean isLocked() {
            return isLocked;
        }

        public LocalDateTime getLockedAt() {
            return lockedAt;
        }

        public LocalDateTime getRosterDeadline() {
            return rosterDeadline;
        }

        public boolean isComplete() {
            return isComplete;
        }

        public int getFilledSlots() {
            return filledSlots;
        }

        public int getTotalSlots() {
            return totalSlots;
        }

        public String getCompletion() {
            return String.format("%d/%d", filledSlots, totalSlots);
        }

        public List<Position> getMissingPositions() {
            return missingPositions;
        }

        public String getCountdown() {
            return countdown;
        }

        public String getLockWarning() {
            return lockWarning;
        }

        public boolean isShowUrgentWarning() {
            return showUrgentWarning;
        }

        public String getIncompleteMessage() {
            return incompleteMessage;
        }

        public String getStatusMessage() {
            return statusMessage;
        }

        public boolean isOneTimeDraftModel() {
            return isOneTimeDraftModel;
        }

        public static Builder builder() {
            return new Builder();
        }

        public static class Builder {
            private UUID rosterId;
            private RosterStatus status;
            private boolean isLocked;
            private LocalDateTime lockedAt;
            private LocalDateTime rosterDeadline;
            private boolean isComplete;
            private int filledSlots;
            private int totalSlots;
            private List<Position> missingPositions;
            private String countdown;
            private String lockWarning;
            private boolean showUrgentWarning;
            private String incompleteMessage;
            private String statusMessage;
            private boolean isOneTimeDraftModel;

            public Builder rosterId(UUID rosterId) {
                this.rosterId = rosterId;
                return this;
            }

            public Builder status(RosterStatus status) {
                this.status = status;
                return this;
            }

            public Builder isLocked(boolean isLocked) {
                this.isLocked = isLocked;
                return this;
            }

            public Builder lockedAt(LocalDateTime lockedAt) {
                this.lockedAt = lockedAt;
                return this;
            }

            public Builder rosterDeadline(LocalDateTime rosterDeadline) {
                this.rosterDeadline = rosterDeadline;
                return this;
            }

            public Builder isComplete(boolean isComplete) {
                this.isComplete = isComplete;
                return this;
            }

            public Builder filledSlots(int filledSlots) {
                this.filledSlots = filledSlots;
                return this;
            }

            public Builder totalSlots(int totalSlots) {
                this.totalSlots = totalSlots;
                return this;
            }

            public Builder missingPositions(List<Position> missingPositions) {
                this.missingPositions = missingPositions;
                return this;
            }

            public Builder countdown(String countdown) {
                this.countdown = countdown;
                return this;
            }

            public Builder lockWarning(String lockWarning) {
                this.lockWarning = lockWarning;
                return this;
            }

            public Builder showUrgentWarning(boolean showUrgentWarning) {
                this.showUrgentWarning = showUrgentWarning;
                return this;
            }

            public Builder incompleteMessage(String incompleteMessage) {
                this.incompleteMessage = incompleteMessage;
                return this;
            }

            public Builder statusMessage(String statusMessage) {
                this.statusMessage = statusMessage;
                return this;
            }

            public Builder isOneTimeDraftModel(boolean isOneTimeDraftModel) {
                this.isOneTimeDraftModel = isOneTimeDraftModel;
                return this;
            }

            public RosterLockStatus build() {
                return new RosterLockStatus(this);
            }
        }
    }
}

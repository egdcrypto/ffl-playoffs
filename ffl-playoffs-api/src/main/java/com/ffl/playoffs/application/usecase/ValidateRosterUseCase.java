package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterSlot;
import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.exception.RosterOperationException;
import com.ffl.playoffs.domain.port.RosterRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Use case for validating a roster's completeness
 * Checks if all required positions are filled according to roster configuration
 *
 * Key validations:
 * - All roster slots are filled
 * - Returns list of empty positions if incomplete
 * - Returns roster status (READY, INCOMPLETE, INCOMPLETE_LOCKED)
 */
public class ValidateRosterUseCase {

    private final RosterRepository rosterRepository;

    public ValidateRosterUseCase(RosterRepository rosterRepository) {
        this.rosterRepository = rosterRepository;
    }

    /**
     * Validates a roster and returns validation result
     *
     * @param command The validate roster command
     * @return ValidationResult with status and missing positions
     * @throws RosterOperationException if roster not found
     */
    public ValidationResult execute(ValidateRosterCommand command) {
        // Find roster
        Roster roster = rosterRepository.findById(command.getRosterId())
                .orElseThrow(() -> new RosterOperationException(
                        RosterOperationException.ErrorCode.ROSTER_NOT_FOUND,
                        "Roster not found"));

        // Check if roster is complete
        boolean isComplete = roster.isComplete();
        List<Position> missingPositions = roster.getMissingPositions();

        // Get slot labels for empty positions (e.g., "RB2" instead of just "RB")
        List<String> emptySlotLabels = roster.getSlots().stream()
                .filter(RosterSlot::isEmpty)
                .map(RosterSlot::getSlotLabel)
                .collect(Collectors.toList());

        // Determine roster status
        RosterStatus status;
        if (isComplete) {
            status = RosterStatus.READY;
        } else if (roster.isLocked()) {
            status = RosterStatus.INCOMPLETE_LOCKED;
        } else {
            status = RosterStatus.INCOMPLETE;
        }

        // Build warnings
        List<String> warnings = new ArrayList<>();
        if (status == RosterStatus.INCOMPLETE_LOCKED) {
            warnings.add("Your roster is incomplete and permanently locked - you will receive 0 points for empty positions for all weeks");
        }

        // Build message
        int filledSlots = roster.getFilledSlotCount();
        int totalSlots = roster.getTotalSlotCount();
        String message;
        if (isComplete) {
            message = String.format("Roster is complete (%d/%d)", filledSlots, totalSlots);
        } else {
            int remaining = totalSlots - filledSlots;
            message = String.format("Roster incomplete: %d position%s remaining",
                    remaining, remaining == 1 ? "" : "s");
        }

        return new ValidationResult(
                roster.getId(),
                isComplete,
                missingPositions,
                emptySlotLabels,
                roster.isLocked(),
                roster.getRosterDeadline(),
                status,
                message,
                warnings,
                filledSlots,
                totalSlots
        );
    }

    /**
     * Command object for validating roster
     */
    public static class ValidateRosterCommand {
        private final UUID rosterId;

        public ValidateRosterCommand(UUID rosterId) {
            this.rosterId = rosterId;
        }

        public UUID getRosterId() {
            return rosterId;
        }
    }

    /**
     * Roster status enum
     */
    public enum RosterStatus {
        READY,           // Roster is complete and ready
        INCOMPLETE,      // Roster has empty positions (can still be modified)
        INCOMPLETE_LOCKED // Roster is incomplete but locked (will receive 0 for empty slots)
    }

    /**
     * Result object containing validation details
     */
    public static class ValidationResult {
        private final UUID rosterId;
        private final boolean isComplete;
        private final List<Position> missingPositions;
        private final List<String> emptySlotLabels;
        private final boolean isLocked;
        private final java.time.LocalDateTime rosterDeadline;
        private final RosterStatus status;
        private final String message;
        private final List<String> warnings;
        private final int filledSlots;
        private final int totalSlots;

        public ValidationResult(
                UUID rosterId,
                boolean isComplete,
                List<Position> missingPositions,
                List<String> emptySlotLabels,
                boolean isLocked,
                java.time.LocalDateTime rosterDeadline,
                RosterStatus status,
                String message,
                List<String> warnings,
                int filledSlots,
                int totalSlots) {
            this.rosterId = rosterId;
            this.isComplete = isComplete;
            this.missingPositions = missingPositions;
            this.emptySlotLabels = emptySlotLabels;
            this.isLocked = isLocked;
            this.rosterDeadline = rosterDeadline;
            this.status = status;
            this.message = message;
            this.warnings = warnings;
            this.filledSlots = filledSlots;
            this.totalSlots = totalSlots;
        }

        public UUID getRosterId() {
            return rosterId;
        }

        public boolean isComplete() {
            return isComplete;
        }

        public List<Position> getMissingPositions() {
            return missingPositions;
        }

        public List<String> getEmptySlotLabels() {
            return emptySlotLabels;
        }

        public boolean isLocked() {
            return isLocked;
        }

        public java.time.LocalDateTime getRosterDeadline() {
            return rosterDeadline;
        }

        public RosterStatus getStatus() {
            return status;
        }

        public String getMessage() {
            return message;
        }

        public List<String> getWarnings() {
            return warnings;
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

        public boolean canBeLocked() {
            return isComplete && !isLocked;
        }
    }
}

package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.Roster;
import com.ffl.playoffs.domain.port.RosterRepository;

import java.util.List;
import java.util.UUID;

/**
 * Use case for validating a roster's completeness
 * Checks if all required positions are filled according to roster configuration
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
     * @throws IllegalArgumentException if roster not found
     */
    public ValidationResult execute(ValidateRosterCommand command) {
        // Find roster
        Roster roster = rosterRepository.findById(command.getRosterId())
                .orElseThrow(() -> new IllegalArgumentException("Roster not found"));

        // Check if roster is complete
        boolean isComplete = roster.isComplete();
        List<Position> missingPositions = roster.getMissingPositions();

        return new ValidationResult(
                roster.getId(),
                isComplete,
                missingPositions,
                roster.isLocked(),
                roster.getRosterDeadline()
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
     * Result object containing validation details
     */
    public static class ValidationResult {
        private final UUID rosterId;
        private final boolean isComplete;
        private final List<Position> missingPositions;
        private final boolean isLocked;
        private final java.time.LocalDateTime rosterDeadline;

        public ValidationResult(
                UUID rosterId,
                boolean isComplete,
                List<Position> missingPositions,
                boolean isLocked,
                java.time.LocalDateTime rosterDeadline) {
            this.rosterId = rosterId;
            this.isComplete = isComplete;
            this.missingPositions = missingPositions;
            this.isLocked = isLocked;
            this.rosterDeadline = rosterDeadline;
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

        public boolean isLocked() {
            return isLocked;
        }

        public java.time.LocalDateTime getRosterDeadline() {
            return rosterDeadline;
        }

        public boolean canBeLocked() {
            return isComplete && !isLocked;
        }
    }
}

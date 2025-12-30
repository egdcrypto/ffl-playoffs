package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.Week;
import com.ffl.playoffs.domain.model.WeekStatus;
import com.ffl.playoffs.domain.port.WeekRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Use case for updating the pick deadline of a week.
 * Only allows updating deadlines for UPCOMING weeks.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class UpdateWeekDeadlineUseCase {

    private final WeekRepository weekRepository;

    /**
     * Updates the pick deadline for a week.
     *
     * @param command the update command
     * @return the updated week
     * @throws IllegalArgumentException if week not found
     * @throws IllegalStateException if week is not UPCOMING or deadline is in the past
     */
    public Week execute(UpdateWeekDeadlineCommand command) {
        log.info("Updating deadline for week: {}", command.getWeekId());

        // Find the week
        Week week = weekRepository.findById(command.getWeekId())
                .orElseThrow(() -> new IllegalArgumentException("Week not found: " + command.getWeekId()));

        // Validate week status allows deadline change
        if (week.getStatus() != WeekStatus.UPCOMING) {
            throw new IllegalStateException("CANNOT_CHANGE_ACTIVE_WEEK_DEADLINE: " +
                    "Can only change deadline for UPCOMING weeks. Current status: " + week.getStatus());
        }

        // Validate deadline is in the future
        if (command.getNewDeadline() != null && command.getNewDeadline().isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("Pick deadline must be in the future");
        }

        // Update the deadline (Week.setPickDeadline will validate and throw if already active)
        week.setPickDeadline(command.getNewDeadline());

        // Save and return
        Week saved = weekRepository.save(week);
        log.info("Updated deadline for week {} (NFL week {}) to {}",
                saved.getGameWeekNumber(), saved.getNflWeekNumber(), saved.getPickDeadline());

        return saved;
    }

    /**
     * Updates deadlines for multiple weeks.
     *
     * @param leagueId the league ID
     * @param deadlines map of game week number to new deadline
     * @throws IllegalStateException if any week is not UPCOMING
     */
    public void updateMultipleDeadlines(UUID leagueId, java.util.Map<Integer, LocalDateTime> deadlines) {
        log.info("Updating deadlines for {} weeks in league {}", deadlines.size(), leagueId);

        for (var entry : deadlines.entrySet()) {
            Integer gameWeekNumber = entry.getKey();
            LocalDateTime deadline = entry.getValue();

            Week week = weekRepository.findByLeagueIdAndGameWeekNumber(leagueId, gameWeekNumber)
                    .orElseThrow(() -> new IllegalArgumentException(
                            "Week not found: game week " + gameWeekNumber + " in league " + leagueId));

            if (week.getStatus() != WeekStatus.UPCOMING) {
                throw new IllegalStateException("CANNOT_CHANGE_ACTIVE_WEEK_DEADLINE: " +
                        "Week " + gameWeekNumber + " is " + week.getStatus());
            }

            week.setPickDeadline(deadline);
            weekRepository.save(week);
        }

        log.info("Successfully updated {} week deadlines", deadlines.size());
    }

    /**
     * Command for updating a week's deadline
     */
    public static class UpdateWeekDeadlineCommand {
        private final UUID weekId;
        private final LocalDateTime newDeadline;
        private final UUID updatedBy;

        public UpdateWeekDeadlineCommand(UUID weekId, LocalDateTime newDeadline, UUID updatedBy) {
            this.weekId = weekId;
            this.newDeadline = newDeadline;
            this.updatedBy = updatedBy;
        }

        public UUID getWeekId() {
            return weekId;
        }

        public LocalDateTime getNewDeadline() {
            return newDeadline;
        }

        public UUID getUpdatedBy() {
            return updatedBy;
        }
    }
}

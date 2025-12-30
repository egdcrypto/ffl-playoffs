package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.Week;
import com.ffl.playoffs.domain.model.WeekStatus;
import com.ffl.playoffs.domain.port.WeekRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.UUID;

/**
 * Use case for updating the status of a week.
 * Manages the week lifecycle: UPCOMING -> ACTIVE -> LOCKED -> COMPLETED
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class UpdateWeekStatusUseCase {

    private final WeekRepository weekRepository;

    /**
     * Activates a week (UPCOMING -> ACTIVE).
     * Called when the week's NFL games are about to start.
     *
     * @param weekId the week ID
     * @return the updated week
     * @throws IllegalArgumentException if week not found
     * @throws IllegalStateException if week is not in UPCOMING status
     */
    public Week activateWeek(UUID weekId) {
        log.info("Activating week: {}", weekId);

        Week week = weekRepository.findById(weekId)
                .orElseThrow(() -> new IllegalArgumentException("Week not found: " + weekId));

        week.activate(); // Will throw if not UPCOMING

        Week saved = weekRepository.save(week);
        log.info("Week {} (NFL week {}) activated", saved.getGameWeekNumber(), saved.getNflWeekNumber());

        return saved;
    }

    /**
     * Locks a week (ACTIVE -> LOCKED).
     * Called when the pick deadline passes.
     *
     * @param weekId the week ID
     * @return the updated week
     * @throws IllegalArgumentException if week not found
     * @throws IllegalStateException if week is not in ACTIVE status
     */
    public Week lockWeek(UUID weekId) {
        log.info("Locking week: {}", weekId);

        Week week = weekRepository.findById(weekId)
                .orElseThrow(() -> new IllegalArgumentException("Week not found: " + weekId));

        week.lock(); // Will throw if not ACTIVE

        Week saved = weekRepository.save(week);
        log.info("Week {} (NFL week {}) locked", saved.getGameWeekNumber(), saved.getNflWeekNumber());

        return saved;
    }

    /**
     * Completes a week (LOCKED -> COMPLETED).
     * Called when all NFL games for the week are finished and scores are calculated.
     *
     * @param weekId the week ID
     * @return the updated week
     * @throws IllegalArgumentException if week not found
     * @throws IllegalStateException if week is not in LOCKED status
     */
    public Week completeWeek(UUID weekId) {
        log.info("Completing week: {}", weekId);

        Week week = weekRepository.findById(weekId)
                .orElseThrow(() -> new IllegalArgumentException("Week not found: " + weekId));

        week.complete(); // Will throw if not LOCKED

        Week saved = weekRepository.save(week);
        log.info("Week {} (NFL week {}) completed", saved.getGameWeekNumber(), saved.getNflWeekNumber());

        return saved;
    }

    /**
     * Processes week status based on current time and game state.
     * This is called periodically to automatically update week statuses.
     *
     * @param weekId the week ID
     * @return the updated week (may be unchanged if no transition needed)
     */
    public Week processWeekStatus(UUID weekId) {
        log.debug("Processing week status: {}", weekId);

        Week week = weekRepository.findById(weekId)
                .orElseThrow(() -> new IllegalArgumentException("Week not found: " + weekId));

        WeekStatus originalStatus = week.getStatus();

        // Check if ACTIVE week should be locked (deadline passed)
        if (week.isActive() && week.hasDeadlinePassed()) {
            week.lock();
            log.info("Auto-locked week {} (deadline passed)", week.getGameWeekNumber());
        }

        // Check if LOCKED week should be completed (all games finished)
        if (week.isLocked() && week.areAllGamesCompleted()) {
            week.complete();
            log.info("Auto-completed week {} (all games finished)", week.getGameWeekNumber());
        }

        // Save if status changed
        if (week.getStatus() != originalStatus) {
            return weekRepository.save(week);
        }

        return week;
    }

    /**
     * Updates game statistics for a week.
     *
     * @param weekId the week ID
     * @param totalGames total NFL games in the week
     * @param completedGames number of completed games
     * @param inProgressGames number of games in progress
     * @return the updated week
     */
    public Week updateGameStats(UUID weekId, Integer totalGames, Integer completedGames, Integer inProgressGames) {
        log.debug("Updating game stats for week {}: total={}, completed={}, inProgress={}",
                weekId, totalGames, completedGames, inProgressGames);

        Week week = weekRepository.findById(weekId)
                .orElseThrow(() -> new IllegalArgumentException("Week not found: " + weekId));

        week.updateGameStats(totalGames, completedGames, inProgressGames);

        return weekRepository.save(week);
    }

    /**
     * Activates the first week of a league (typically called after league activation).
     *
     * @param leagueId the league ID
     * @return the activated week, or null if no UPCOMING weeks exist
     */
    public Week activateFirstUpcomingWeek(UUID leagueId) {
        log.info("Activating first upcoming week for league: {}", leagueId);

        var upcomingWeeks = weekRepository.findByLeagueIdAndStatus(leagueId, WeekStatus.UPCOMING);

        if (upcomingWeeks.isEmpty()) {
            log.warn("No upcoming weeks found for league: {}", leagueId);
            return null;
        }

        // Get the first week (should be ordered by gameWeekNumber)
        Week firstWeek = upcomingWeeks.stream()
                .min((w1, w2) -> w1.getGameWeekNumber().compareTo(w2.getGameWeekNumber()))
                .get();

        firstWeek.activate();
        Week saved = weekRepository.save(firstWeek);

        log.info("Activated week {} (NFL week {}) for league {}",
                saved.getGameWeekNumber(), saved.getNflWeekNumber(), leagueId);

        return saved;
    }

    /**
     * Advances to the next week after completing the current week.
     * Completes the current week and activates the next UPCOMING week.
     *
     * @param leagueId the league ID
     * @param currentWeekId the current week ID to complete
     * @return the newly activated week, or null if no more weeks
     */
    public Week advanceToNextWeek(UUID leagueId, UUID currentWeekId) {
        log.info("Advancing to next week for league: {}", leagueId);

        // Complete current week
        completeWeek(currentWeekId);

        // Activate next week
        return activateFirstUpcomingWeek(leagueId);
    }
}

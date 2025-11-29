package com.ffl.playoffs.application.service;

import com.ffl.playoffs.domain.model.Week;
import com.ffl.playoffs.domain.model.WeekStatus;
import com.ffl.playoffs.domain.port.WeekRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.DayOfWeek;
import java.time.LocalDateTime;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Service for Week management operations
 * Provides business logic for creating and managing game weeks
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class WeekService {

    private final WeekRepository weekRepository;

    /**
     * Create weeks for a league when it is activated
     * @param leagueId the league ID
     * @param startingNflWeek the starting NFL week (1-22)
     * @param numberOfWeeks the number of weeks in the league
     * @param season the NFL season year
     * @return list of created weeks
     * @throws IllegalStateException if weeks already exist for this league
     */
    public List<Week> createWeeksForLeague(UUID leagueId, Integer startingNflWeek, Integer numberOfWeeks, Integer season) {
        log.info("Creating {} weeks for league {} starting at NFL week {}", numberOfWeeks, leagueId, startingNflWeek);

        // Check if weeks already exist
        if (weekRepository.existsByLeagueId(leagueId)) {
            throw new IllegalStateException("WEEKS_ALREADY_EXIST");
        }

        List<Week> weeks = new ArrayList<>();
        for (int i = 0; i < numberOfWeeks; i++) {
            int gameWeekNumber = i + 1;
            int nflWeekNumber = startingNflWeek + i;

            // Calculate default pick deadline (Sunday 1PM ET for each NFL week)
            LocalDateTime pickDeadline = calculateDefaultPickDeadline(season, nflWeekNumber);

            Week week = new Week(leagueId, gameWeekNumber, nflWeekNumber, pickDeadline);
            weeks.add(week);
        }

        List<Week> savedWeeks = weekRepository.saveAll(weeks);
        log.info("Created {} weeks for league {}", savedWeeks.size(), leagueId);
        return savedWeeks;
    }

    /**
     * Calculate default pick deadline for an NFL week (Sunday 1PM ET)
     * This is a simplified implementation - in production, would use actual NFL schedule
     */
    private LocalDateTime calculateDefaultPickDeadline(Integer season, Integer nflWeekNumber) {
        // For now, use a simplified calculation
        // In production, this would fetch the actual first game time from NFL schedule
        // Week 1 typically starts around September 10th
        LocalDateTime weekOneStart = LocalDateTime.of(season, 9, 10, 13, 0);

        // Add weeks to get to the target week
        LocalDateTime weekStart = weekOneStart.plusWeeks(nflWeekNumber - 1);

        // Adjust to the next Sunday if needed
        if (weekStart.getDayOfWeek() != DayOfWeek.SUNDAY) {
            weekStart = weekStart.with(TemporalAdjusters.next(DayOfWeek.SUNDAY));
        }

        return weekStart.withHour(13).withMinute(0).withSecond(0).withNano(0);
    }

    /**
     * Get all weeks for a league
     * @param leagueId the league ID
     * @return list of weeks ordered by gameWeekNumber
     */
    public List<Week> getWeeksForLeague(UUID leagueId) {
        log.debug("Getting all weeks for league {}", leagueId);
        return weekRepository.findByLeagueId(leagueId);
    }

    /**
     * Get week by game week number
     * @param leagueId the league ID
     * @param gameWeekNumber the game week number
     * @return Optional containing the week if found
     */
    public Optional<Week> getWeekByGameWeekNumber(UUID leagueId, Integer gameWeekNumber) {
        log.debug("Getting week by gameWeekNumber {} for league {}", gameWeekNumber, leagueId);
        return weekRepository.findByLeagueIdAndGameWeekNumber(leagueId, gameWeekNumber);
    }

    /**
     * Get week by NFL week number
     * @param leagueId the league ID
     * @param nflWeekNumber the NFL week number
     * @return Optional containing the week if found
     */
    public Optional<Week> getWeekByNflWeekNumber(UUID leagueId, Integer nflWeekNumber) {
        log.debug("Getting week by nflWeekNumber {} for league {}", nflWeekNumber, leagueId);
        return weekRepository.findByLeagueIdAndNflWeekNumber(leagueId, nflWeekNumber);
    }

    /**
     * Get the current active or locked week for a league
     * @param leagueId the league ID
     * @return Optional containing the current week if found
     */
    public Optional<Week> getCurrentWeek(UUID leagueId) {
        log.debug("Getting current week for league {}", leagueId);
        return weekRepository.findCurrentWeek(leagueId);
    }

    /**
     * Activate a week (move from UPCOMING to ACTIVE)
     * @param weekId the week ID
     * @return the updated week
     */
    public Week activateWeek(UUID weekId) {
        log.info("Activating week {}", weekId);
        Week week = weekRepository.findById(weekId)
                .orElseThrow(() -> new IllegalArgumentException("Week not found: " + weekId));

        week.activate();
        return weekRepository.save(week);
    }

    /**
     * Lock a week after the deadline passes
     * @param weekId the week ID
     * @return the updated week
     */
    public Week lockWeek(UUID weekId) {
        log.info("Locking week {}", weekId);
        Week week = weekRepository.findById(weekId)
                .orElseThrow(() -> new IllegalArgumentException("Week not found: " + weekId));

        week.lock();
        return weekRepository.save(week);
    }

    /**
     * Complete a week after all games are finished
     * @param weekId the week ID
     * @return the updated week
     */
    public Week completeWeek(UUID weekId) {
        log.info("Completing week {}", weekId);
        Week week = weekRepository.findById(weekId)
                .orElseThrow(() -> new IllegalArgumentException("Week not found: " + weekId));

        week.complete();
        return weekRepository.save(week);
    }

    /**
     * Update pick deadline for a week
     * @param weekId the week ID
     * @param pickDeadline the new pick deadline
     * @return the updated week
     * @throws IllegalStateException if week is already active/locked/completed
     */
    public Week updatePickDeadline(UUID weekId, LocalDateTime pickDeadline) {
        log.info("Updating pick deadline for week {} to {}", weekId, pickDeadline);
        Week week = weekRepository.findById(weekId)
                .orElseThrow(() -> new IllegalArgumentException("Week not found: " + weekId));

        week.setPickDeadline(pickDeadline);
        return weekRepository.save(week);
    }

    /**
     * Update game statistics for a week
     * @param weekId the week ID
     * @param totalGames total NFL games for the week
     * @param completed number of completed games
     * @param inProgress number of games in progress
     * @return the updated week
     */
    public Week updateGameStats(UUID weekId, Integer totalGames, Integer completed, Integer inProgress) {
        log.debug("Updating game stats for week {}: total={}, completed={}, inProgress={}",
                weekId, totalGames, completed, inProgress);
        Week week = weekRepository.findById(weekId)
                .orElseThrow(() -> new IllegalArgumentException("Week not found: " + weekId));

        week.updateGameStats(totalGames, completed, inProgress);
        return weekRepository.save(week);
    }

    /**
     * Determine the current game week based on current NFL week
     * @param leagueId the league ID
     * @param currentNflWeek the current NFL week
     * @return the current game week number, or null if not in league range
     */
    public Integer determineCurrentGameWeek(UUID leagueId, Integer currentNflWeek) {
        log.debug("Determining current game week for league {} with NFL week {}", leagueId, currentNflWeek);
        Optional<Week> week = weekRepository.findByLeagueIdAndNflWeekNumber(leagueId, currentNflWeek);
        return week.map(Week::getGameWeekNumber).orElse(null);
    }

    /**
     * Get weeks by status
     * @param leagueId the league ID
     * @param status the week status
     * @return list of weeks with the specified status
     */
    public List<Week> getWeeksByStatus(UUID leagueId, WeekStatus status) {
        log.debug("Getting weeks with status {} for league {}", status, leagueId);
        return weekRepository.findByLeagueIdAndStatus(leagueId, status);
    }

    /**
     * Save a week
     * @param week the week to save
     * @return the saved week
     */
    public Week save(Week week) {
        return weekRepository.save(week);
    }
}

package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.Week;
import com.ffl.playoffs.domain.model.WeekStatus;
import com.ffl.playoffs.domain.port.WeekRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Use case for retrieving week entities.
 * Provides various ways to query weeks for a league.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class GetWeekUseCase {

    private final WeekRepository weekRepository;

    /**
     * Get all weeks for a league, ordered by game week number.
     *
     * @param leagueId the league ID
     * @return list of weeks ordered by gameWeekNumber ascending
     */
    public List<Week> getAllWeeks(UUID leagueId) {
        log.debug("Getting all weeks for league: {}", leagueId);
        return weekRepository.findByLeagueId(leagueId);
    }

    /**
     * Get a week by its ID.
     *
     * @param weekId the week ID
     * @return Optional containing the week if found
     */
    public Optional<Week> getById(UUID weekId) {
        log.debug("Getting week by ID: {}", weekId);
        return weekRepository.findById(weekId);
    }

    /**
     * Get a week by game week number.
     *
     * @param leagueId the league ID
     * @param gameWeekNumber the game week number (1-based)
     * @return Optional containing the week if found
     */
    public Optional<Week> getByGameWeekNumber(UUID leagueId, Integer gameWeekNumber) {
        log.debug("Getting week by game week number {} for league {}", gameWeekNumber, leagueId);
        return weekRepository.findByLeagueIdAndGameWeekNumber(leagueId, gameWeekNumber);
    }

    /**
     * Get a week by NFL week number.
     *
     * @param leagueId the league ID
     * @param nflWeekNumber the NFL week number
     * @return Optional containing the week if found
     */
    public Optional<Week> getByNflWeekNumber(UUID leagueId, Integer nflWeekNumber) {
        log.debug("Getting week by NFL week number {} for league {}", nflWeekNumber, leagueId);
        return weekRepository.findByLeagueIdAndNflWeekNumber(leagueId, nflWeekNumber);
    }

    /**
     * Get the current active or locked week for a league.
     *
     * @param leagueId the league ID
     * @return Optional containing the current week if found
     */
    public Optional<Week> getCurrentWeek(UUID leagueId) {
        log.debug("Getting current week for league: {}", leagueId);
        return weekRepository.findCurrentWeek(leagueId);
    }

    /**
     * Get weeks with a specific status.
     *
     * @param leagueId the league ID
     * @param status the week status
     * @return list of weeks with the specified status
     */
    public List<Week> getByStatus(UUID leagueId, WeekStatus status) {
        log.debug("Getting weeks with status {} for league {}", status, leagueId);
        return weekRepository.findByLeagueIdAndStatus(leagueId, status);
    }

    /**
     * Get all upcoming weeks (not yet started).
     *
     * @param leagueId the league ID
     * @return list of upcoming weeks
     */
    public List<Week> getUpcomingWeeks(UUID leagueId) {
        return getByStatus(leagueId, WeekStatus.UPCOMING);
    }

    /**
     * Get all completed weeks.
     *
     * @param leagueId the league ID
     * @return list of completed weeks
     */
    public List<Week> getCompletedWeeks(UUID leagueId) {
        return getByStatus(leagueId, WeekStatus.COMPLETED);
    }

    /**
     * Count the total number of weeks for a league.
     *
     * @param leagueId the league ID
     * @return the count of weeks
     */
    public long countWeeks(UUID leagueId) {
        return weekRepository.countByLeagueId(leagueId);
    }

    /**
     * Check if weeks exist for a league.
     *
     * @param leagueId the league ID
     * @return true if weeks exist
     */
    public boolean hasWeeks(UUID leagueId) {
        return weekRepository.existsByLeagueId(leagueId);
    }
}

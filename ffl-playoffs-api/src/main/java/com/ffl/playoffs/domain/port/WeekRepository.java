package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.Week;
import com.ffl.playoffs.domain.model.WeekStatus;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Port interface for Week persistence
 * Domain defines the contract, infrastructure implements it
 *
 * IMPORTANT: This is a DOMAIN PORT and must only depend on domain entities.
 * NO dependencies on application layer (DTOs, Page, PageRequest).
 */
public interface WeekRepository {

    /**
     * Save a week
     * @param week the domain entity to save
     * @return the saved domain entity
     */
    Week save(Week week);

    /**
     * Save multiple weeks
     * @param weeks the list of weeks to save
     * @return the list of saved weeks
     */
    List<Week> saveAll(List<Week> weeks);

    /**
     * Find a week by ID
     * @param id the week ID
     * @return Optional containing the domain entity if found
     */
    Optional<Week> findById(UUID id);

    /**
     * Find all weeks for a league
     * @param leagueId the league ID
     * @return list of all weeks for the league, ordered by gameWeekNumber ascending
     */
    List<Week> findByLeagueId(UUID leagueId);

    /**
     * Find week by league ID and game week number
     * @param leagueId the league ID
     * @param gameWeekNumber the game week number
     * @return Optional containing the week if found
     */
    Optional<Week> findByLeagueIdAndGameWeekNumber(UUID leagueId, Integer gameWeekNumber);

    /**
     * Find week by league ID and NFL week number
     * @param leagueId the league ID
     * @param nflWeekNumber the NFL week number
     * @return Optional containing the week if found
     */
    Optional<Week> findByLeagueIdAndNflWeekNumber(UUID leagueId, Integer nflWeekNumber);

    /**
     * Find current active or locked week for a league
     * @param leagueId the league ID
     * @return Optional containing the current week if found
     */
    Optional<Week> findCurrentWeek(UUID leagueId);

    /**
     * Find all weeks with a specific status for a league
     * @param leagueId the league ID
     * @param status the week status
     * @return list of weeks with the specified status
     */
    List<Week> findByLeagueIdAndStatus(UUID leagueId, WeekStatus status);

    /**
     * Check if weeks already exist for a league
     * @param leagueId the league ID
     * @return true if weeks exist, false otherwise
     */
    boolean existsByLeagueId(UUID leagueId);

    /**
     * Count weeks for a league
     * @param leagueId the league ID
     * @return number of weeks
     */
    long countByLeagueId(UUID leagueId);

    /**
     * Delete a week
     * @param id the week ID
     */
    void delete(UUID id);

    /**
     * Delete all weeks for a league
     * @param leagueId the league ID
     */
    void deleteByLeagueId(UUID leagueId);
}

package com.ffl.playoffs.domain.service;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.aggregate.Week;
import com.ffl.playoffs.domain.model.WeekStatus;

import java.time.DayOfWeek;
import java.time.LocalDateTime;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Domain service for creating week entities when a league is activated.
 * Maps game weeks to NFL weeks and sets default pick deadlines.
 */
public class WeekCreationService {

    // Default deadline is Sunday 1PM ET (13:00)
    private static final int DEFAULT_DEADLINE_HOUR = 13;
    private static final int DEFAULT_DEADLINE_MINUTE = 0;

    /**
     * Creates week entities for a league based on its configuration.
     * Maps game week numbers (1, 2, 3...) to corresponding NFL weeks.
     *
     * @param league the league to create weeks for
     * @return list of created week entities
     * @throws IllegalStateException if weeks already exist for the league
     */
    public List<Week> createWeeksForLeague(League league) {
        if (league.getStartingWeek() == null || league.getNumberOfWeeks() == null) {
            throw new IllegalArgumentException("League must have starting week and number of weeks configured");
        }

        List<Week> weeks = new ArrayList<>();
        int startingNflWeek = league.getStartingWeek();
        int numberOfWeeks = league.getNumberOfWeeks();

        for (int i = 0; i < numberOfWeeks; i++) {
            int gameWeekNumber = i + 1; // 1-based game week
            int nflWeekNumber = startingNflWeek + i;

            Week week = new Week(
                    league.getId(),
                    gameWeekNumber,
                    nflWeekNumber
            );

            // Set default pick deadline (Sunday 1PM ET of the NFL week)
            LocalDateTime defaultDeadline = calculateDefaultDeadline(nflWeekNumber, league.getCreatedAt().getYear());
            week.setPickDeadline(defaultDeadline);

            weeks.add(week);
        }

        return weeks;
    }

    /**
     * Calculates the default pick deadline for an NFL week.
     * Default is Sunday 1PM ET of that NFL week.
     *
     * @param nflWeekNumber the NFL week number
     * @param season the season year
     * @return the default pick deadline
     */
    public LocalDateTime calculateDefaultDeadline(int nflWeekNumber, int season) {
        // NFL regular season typically starts first Thursday after Labor Day
        // For simplicity, we calculate based on week number
        // Week 1 is usually early September

        // Base date: First Sunday of September (approximate start of NFL season)
        LocalDateTime baseSunday = LocalDateTime.of(season, 9, 1, DEFAULT_DEADLINE_HOUR, DEFAULT_DEADLINE_MINUTE)
                .with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));

        // Add weeks (NFL week 1 = first Sunday, week 2 = second Sunday, etc.)
        return baseSunday.plusWeeks(nflWeekNumber - 1);
    }

    /**
     * Calculates pick deadline for a specific date.
     * Used when the first game start time is known.
     *
     * @param firstGameStart the first game start time for the week
     * @return deadline set to Sunday 1PM ET of that week, or earlier if first game is earlier
     */
    public LocalDateTime calculateDeadlineFromGameStart(LocalDateTime firstGameStart) {
        // If first game is on Sunday at 1PM or later, deadline is 1PM
        // If first game is earlier (Thursday, Saturday, or early Sunday), deadline is game start
        LocalDateTime sundayDeadline = firstGameStart
                .with(TemporalAdjusters.previousOrSame(DayOfWeek.SUNDAY))
                .withHour(DEFAULT_DEADLINE_HOUR)
                .withMinute(DEFAULT_DEADLINE_MINUTE)
                .withSecond(0)
                .withNano(0);

        // If first game is before the Sunday 1PM deadline, use game start time
        if (firstGameStart.isBefore(sundayDeadline)) {
            return firstGameStart;
        }

        return sundayDeadline;
    }

    /**
     * Validates that a pick deadline is valid.
     * Deadline must be in the future and before games start.
     *
     * @param deadline the proposed deadline
     * @param now current time
     * @return true if deadline is valid
     */
    public boolean isValidDeadline(LocalDateTime deadline, LocalDateTime now) {
        return deadline != null && deadline.isAfter(now);
    }

    /**
     * Determines the current game week for a league based on the current NFL week.
     *
     * @param league the league
     * @param currentNflWeek the current NFL week number
     * @return the current game week number, or null if league is completed or not started
     */
    public Integer getCurrentGameWeek(League league, int currentNflWeek) {
        int startingWeek = league.getStartingWeek();
        int endingWeek = league.getEndingWeek();

        // League hasn't started yet
        if (currentNflWeek < startingWeek) {
            return null;
        }

        // League is completed
        if (currentNflWeek > endingWeek) {
            return null;
        }

        // Calculate game week (1-based)
        return currentNflWeek - startingWeek + 1;
    }

    /**
     * Checks if an NFL week is within the league's range.
     *
     * @param league the league
     * @param nflWeekNumber the NFL week number
     * @return true if the NFL week is covered by this league
     */
    public boolean isNflWeekInLeagueRange(League league, int nflWeekNumber) {
        return nflWeekNumber >= league.getStartingWeek() &&
               nflWeekNumber <= league.getEndingWeek();
    }

    /**
     * Converts an NFL week number to a game week number for a league.
     *
     * @param league the league
     * @param nflWeekNumber the NFL week number
     * @return the game week number, or null if NFL week is not in league range
     */
    public Integer nflWeekToGameWeek(League league, int nflWeekNumber) {
        if (!isNflWeekInLeagueRange(league, nflWeekNumber)) {
            return null;
        }
        return nflWeekNumber - league.getStartingWeek() + 1;
    }

    /**
     * Converts a game week number to an NFL week number for a league.
     *
     * @param league the league
     * @param gameWeekNumber the game week number
     * @return the NFL week number
     */
    public int gameWeekToNflWeek(League league, int gameWeekNumber) {
        return league.getStartingWeek() + gameWeekNumber - 1;
    }
}

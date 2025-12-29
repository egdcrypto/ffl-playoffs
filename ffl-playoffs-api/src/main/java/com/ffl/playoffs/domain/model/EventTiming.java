package com.ffl.playoffs.domain.model;

import java.time.Duration;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;
import java.util.UUID;

/**
 * Value object controlling when an event is active.
 */
public class EventTiming {

    private final TimingType type;
    private final Integer weekStart;
    private final Integer weekEnd;
    private final Duration duration;

    // Game-specific timing
    private final UUID specificGameId;
    private final GamePhase gamePhase;

    // Recurrence
    private final boolean recurring;
    private final RecurrencePattern recurrence;
    private final Set<Integer> recurringWeeks;

    private EventTiming(TimingType type, Integer weekStart, Integer weekEnd, Duration duration,
                        UUID specificGameId, GamePhase gamePhase, boolean recurring,
                        RecurrencePattern recurrence, Set<Integer> recurringWeeks) {
        this.type = type;
        this.weekStart = weekStart;
        this.weekEnd = weekEnd;
        this.duration = duration;
        this.specificGameId = specificGameId;
        this.gamePhase = gamePhase;
        this.recurring = recurring;
        this.recurrence = recurrence;
        this.recurringWeeks = recurringWeeks != null ? new HashSet<>(recurringWeeks) : null;
    }

    // Factory methods

    public static EventTiming singleWeek(int week) {
        return new EventTiming(TimingType.SINGLE_WEEK, week, week, null,
                null, null, false, null, null);
    }

    public static EventTiming weekRange(int start, int end) {
        return new EventTiming(TimingType.MULTI_WEEK, start, end, null,
                null, null, false, null, null);
    }

    public static EventTiming indefinite(int startWeek) {
        return new EventTiming(TimingType.INDEFINITE, startWeek, null, null,
                null, null, false, null, null);
    }

    public static EventTiming forGame(UUID gameId) {
        return new EventTiming(TimingType.SINGLE_GAME, null, null, null,
                gameId, null, false, null, null);
    }

    public static EventTiming restOfSeason(int fromWeek) {
        return new EventTiming(TimingType.INDEFINITE, fromWeek, 18, null,
                null, null, false, null, null);
    }

    public static EventTiming instant() {
        return new EventTiming(TimingType.INSTANT, null, null, null,
                null, null, false, null, null);
    }

    // Business methods

    public boolean isActiveForWeek(int week) {
        if (type == TimingType.INSTANT) {
            return false; // Instant events are processed immediately, not per-week
        }

        if (recurring && recurringWeeks != null) {
            return recurringWeeks.contains(week);
        }

        if (weekStart != null && week < weekStart) {
            return false;
        }

        if (weekEnd != null && week > weekEnd) {
            return false;
        }

        return true;
    }

    public boolean isActiveForGame(UUID gameId) {
        if (type == TimingType.SINGLE_GAME) {
            return specificGameId != null && specificGameId.equals(gameId);
        }
        return true; // Non-game-specific events apply to all games in active weeks
    }

    public int getDurationInWeeks() {
        if (weekStart == null || weekEnd == null) {
            return -1; // Indefinite
        }
        return weekEnd - weekStart + 1;
    }

    // Getters

    public TimingType getType() {
        return type;
    }

    public Integer getWeekStart() {
        return weekStart;
    }

    public Integer getWeekEnd() {
        return weekEnd;
    }

    public Duration getDuration() {
        return duration;
    }

    public UUID getSpecificGameId() {
        return specificGameId;
    }

    public GamePhase getGamePhase() {
        return gamePhase;
    }

    public boolean isRecurring() {
        return recurring;
    }

    public RecurrencePattern getRecurrence() {
        return recurrence;
    }

    public Set<Integer> getRecurringWeeks() {
        return recurringWeeks != null ? new HashSet<>(recurringWeeks) : null;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        EventTiming that = (EventTiming) o;
        return recurring == that.recurring &&
                type == that.type &&
                Objects.equals(weekStart, that.weekStart) &&
                Objects.equals(weekEnd, that.weekEnd) &&
                Objects.equals(specificGameId, that.specificGameId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(type, weekStart, weekEnd, specificGameId, recurring);
    }

    @Override
    public String toString() {
        if (type == TimingType.SINGLE_WEEK) {
            return String.format("Week %d", weekStart);
        } else if (type == TimingType.MULTI_WEEK) {
            return String.format("Weeks %d-%d", weekStart, weekEnd);
        } else if (type == TimingType.SINGLE_GAME) {
            return String.format("Game %s", specificGameId);
        } else if (type == TimingType.INDEFINITE) {
            return String.format("From week %d (indefinite)", weekStart);
        }
        return type.toString();
    }

    public enum GamePhase {
        PRE_GAME,
        IN_GAME,
        POST_GAME
    }

    public enum RecurrencePattern {
        WEEKLY,
        BI_WEEKLY,
        MONTHLY,
        CUSTOM
    }
}

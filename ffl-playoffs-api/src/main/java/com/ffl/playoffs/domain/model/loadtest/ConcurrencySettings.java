package com.ffl.playoffs.domain.model.loadtest;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.ToString;

import java.time.Duration;

/**
 * Immutable value object representing concurrency settings for a load test.
 */
@Getter
@ToString
@EqualsAndHashCode
public final class ConcurrencySettings {
    private final Integer initialUsers;
    private final Integer maxUsers;
    private final Integer rampUpUsers;
    private final Duration rampUpDuration;
    private final Duration holdDuration;
    private final Duration rampDownDuration;
    private final Integer targetRequestsPerSecond;

    private ConcurrencySettings(Integer initialUsers, Integer maxUsers, Integer rampUpUsers,
                                Duration rampUpDuration, Duration holdDuration,
                                Duration rampDownDuration, Integer targetRequestsPerSecond) {
        this.initialUsers = initialUsers != null ? initialUsers : 1;
        this.maxUsers = maxUsers != null ? maxUsers : 10;
        this.rampUpUsers = rampUpUsers != null ? rampUpUsers : 1;
        this.rampUpDuration = rampUpDuration != null ? rampUpDuration : Duration.ofMinutes(1);
        this.holdDuration = holdDuration != null ? holdDuration : Duration.ofMinutes(5);
        this.rampDownDuration = rampDownDuration != null ? rampDownDuration : Duration.ofMinutes(1);
        this.targetRequestsPerSecond = targetRequestsPerSecond;

        if (this.initialUsers < 0) {
            throw new IllegalArgumentException("Initial users cannot be negative");
        }
        if (this.maxUsers < this.initialUsers) {
            throw new IllegalArgumentException("Max users must be >= initial users");
        }
    }

    public static ConcurrencySettings defaultSettings() {
        return new ConcurrencySettings(1, 10, 1,
                Duration.ofMinutes(1), Duration.ofMinutes(5), Duration.ofMinutes(1), null);
    }

    public static ConcurrencySettings forUsers(int maxUsers) {
        return new ConcurrencySettings(1, maxUsers, 1,
                Duration.ofMinutes(1), Duration.ofMinutes(5), Duration.ofMinutes(1), null);
    }

    public static ConcurrencySettings create(Integer initialUsers, Integer maxUsers, Integer rampUpUsers,
                                             Duration rampUpDuration, Duration holdDuration,
                                             Duration rampDownDuration, Integer targetRps) {
        return new ConcurrencySettings(initialUsers, maxUsers, rampUpUsers,
                rampUpDuration, holdDuration, rampDownDuration, targetRps);
    }

    /**
     * Get the total test duration.
     */
    public Duration getTotalDuration() {
        return rampUpDuration.plus(holdDuration).plus(rampDownDuration);
    }

    /**
     * Calculate expected users at a given time into the test.
     */
    public int getUsersAtTime(Duration elapsed) {
        long elapsedSeconds = elapsed.getSeconds();
        long rampUpSeconds = rampUpDuration.getSeconds();
        long holdSeconds = holdDuration.getSeconds();

        if (elapsedSeconds < rampUpSeconds) {
            // Ramp up phase
            double progress = (double) elapsedSeconds / rampUpSeconds;
            return (int) (initialUsers + (maxUsers - initialUsers) * progress);
        } else if (elapsedSeconds < rampUpSeconds + holdSeconds) {
            // Hold phase
            return maxUsers;
        } else {
            // Ramp down phase
            long rampDownElapsed = elapsedSeconds - rampUpSeconds - holdSeconds;
            long rampDownSeconds = rampDownDuration.getSeconds();
            if (rampDownSeconds == 0) return initialUsers;
            double progress = (double) rampDownElapsed / rampDownSeconds;
            return (int) (maxUsers - (maxUsers - initialUsers) * progress);
        }
    }
}

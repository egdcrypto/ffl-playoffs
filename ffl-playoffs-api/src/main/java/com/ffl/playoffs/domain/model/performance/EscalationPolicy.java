package com.ffl.playoffs.domain.model.performance;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.ToString;

import java.time.Duration;
import java.util.*;

/**
 * Immutable value object representing an alert escalation policy.
 */
@Getter
@ToString
@EqualsAndHashCode
public final class EscalationPolicy {
    private final String name;
    private final List<EscalationLevel> levels;

    private EscalationPolicy(String name, List<EscalationLevel> levels) {
        this.name = Objects.requireNonNull(name, "Policy name is required");
        if (levels == null || levels.isEmpty()) {
            throw new IllegalArgumentException("At least one escalation level is required");
        }
        this.levels = Collections.unmodifiableList(new ArrayList<>(levels));
    }

    public static EscalationPolicy of(String name, List<EscalationLevel> levels) {
        return new EscalationPolicy(name, levels);
    }

    public static EscalationPolicy defaultPolicy() {
        return new EscalationPolicy("default", List.of(
                EscalationLevel.of(Duration.ZERO, "on-call-engineer", NotificationChannel.SLACK),
                EscalationLevel.of(Duration.ofMinutes(15), "team-lead", NotificationChannel.SLACK),
                EscalationLevel.of(Duration.ofMinutes(30), "engineering-manager", NotificationChannel.PAGERDUTY),
                EscalationLevel.of(Duration.ofHours(1), "executive-on-call", NotificationChannel.PAGERDUTY)
        ));
    }

    public Optional<EscalationLevel> getLevelForDuration(Duration alertDuration) {
        EscalationLevel matchedLevel = null;
        for (EscalationLevel level : levels) {
            if (alertDuration.compareTo(level.getAfterDuration()) >= 0) {
                matchedLevel = level;
            }
        }
        return Optional.ofNullable(matchedLevel);
    }

    public int getLevelCount() {
        return levels.size();
    }

    @Getter
    @ToString
    @EqualsAndHashCode
    public static final class EscalationLevel {
        private final Duration afterDuration;
        private final String notifyRole;
        private final NotificationChannel channel;

        private EscalationLevel(Duration afterDuration, String notifyRole, NotificationChannel channel) {
            this.afterDuration = Objects.requireNonNull(afterDuration, "Duration is required");
            this.notifyRole = Objects.requireNonNull(notifyRole, "Notify role is required");
            this.channel = Objects.requireNonNull(channel, "Channel is required");
        }

        public static EscalationLevel of(Duration afterDuration, String notifyRole, NotificationChannel channel) {
            return new EscalationLevel(afterDuration, notifyRole, channel);
        }
    }
}

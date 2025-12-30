package com.ffl.playoffs.domain.model.character;

import java.time.LocalDateTime;
import java.util.Objects;
import java.util.UUID;

/**
 * Achievement value object
 * Represents an achievement earned by a character
 */
public final class Achievement {

    private final UUID id;
    private final AchievementType type;
    private final LocalDateTime unlockedAt;
    private final String context; // Additional context (e.g., "Season 2024", "Week 5")
    private final Integer count; // For repeatable achievements

    private Achievement(UUID id, AchievementType type, LocalDateTime unlockedAt, String context, Integer count) {
        this.id = Objects.requireNonNull(id, "Achievement ID is required");
        this.type = Objects.requireNonNull(type, "Achievement type is required");
        this.unlockedAt = Objects.requireNonNull(unlockedAt, "Unlock time is required");
        this.context = context;
        this.count = count != null ? count : 1;
    }

    /**
     * Create a new achievement
     * @param type the achievement type
     * @return new achievement
     */
    public static Achievement create(AchievementType type) {
        return new Achievement(UUID.randomUUID(), type, LocalDateTime.now(), null, 1);
    }

    /**
     * Create a new achievement with context
     * @param type the achievement type
     * @param context additional context
     * @return new achievement
     */
    public static Achievement create(AchievementType type, String context) {
        return new Achievement(UUID.randomUUID(), type, LocalDateTime.now(), context, 1);
    }

    /**
     * Create an achievement from stored data
     * @param id the achievement ID
     * @param type the achievement type
     * @param unlockedAt when it was unlocked
     * @param context additional context
     * @param count times earned (for repeatable)
     * @return reconstructed achievement
     */
    public static Achievement reconstitute(UUID id, AchievementType type, LocalDateTime unlockedAt,
                                           String context, Integer count) {
        return new Achievement(id, type, unlockedAt, context, count);
    }

    /**
     * Increment the count for repeatable achievements
     * @return new achievement with incremented count
     */
    public Achievement incrementCount() {
        if (!type.isRepeatable()) {
            throw new IllegalStateException("Cannot increment count on non-repeatable achievement: " + type);
        }
        return new Achievement(this.id, this.type, this.unlockedAt, this.context, this.count + 1);
    }

    /**
     * Get the XP reward for this achievement
     * @return XP points
     */
    public int getXpReward() {
        return type.getXpReward() * count;
    }

    // Getters

    public UUID getId() {
        return id;
    }

    public AchievementType getType() {
        return type;
    }

    public LocalDateTime getUnlockedAt() {
        return unlockedAt;
    }

    public String getContext() {
        return context;
    }

    public Integer getCount() {
        return count;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Achievement that = (Achievement) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return String.format("Achievement{type=%s, unlockedAt=%s, count=%d}",
                type.getName(), unlockedAt, count);
    }
}

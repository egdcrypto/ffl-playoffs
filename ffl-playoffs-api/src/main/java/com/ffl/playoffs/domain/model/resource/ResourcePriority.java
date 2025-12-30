package com.ffl.playoffs.domain.model.resource;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Priority levels for resource allocation during contention.
 */
@Getter
@RequiredArgsConstructor
public enum ResourcePriority {
    LOW("low", "Low Priority", 1),
    NORMAL("normal", "Normal Priority", 2),
    HIGH("high", "High Priority", 3),
    CRITICAL("critical", "Critical Priority", 4);

    private final String code;
    private final String displayName;
    private final int weight;

    public boolean isHigherThan(ResourcePriority other) {
        return this.weight > other.weight;
    }

    public static ResourcePriority fromCode(String code) {
        for (ResourcePriority priority : values()) {
            if (priority.code.equals(code)) {
                return priority;
            }
        }
        throw new IllegalArgumentException("Unknown resource priority code: " + code);
    }
}

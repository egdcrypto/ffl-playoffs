package com.ffl.playoffs.domain.model.resource;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Types of resources that can be allocated and managed within the platform.
 */
@Getter
@RequiredArgsConstructor
public enum ResourceType {
    COMPUTE_HOURS("compute_hours", "Compute Hours", "hours", true),
    STORAGE_GB("storage_gb", "Storage", "GB", true),
    BANDWIDTH_GB("bandwidth_gb", "Bandwidth", "GB", true),
    AI_TOKENS("ai_tokens", "AI Tokens", "tokens", true),
    CONCURRENT_USERS("concurrent_users", "Concurrent Users", "users", false),
    API_CALLS("api_calls", "API Calls", "calls", true);

    private final String code;
    private final String displayName;
    private final String unit;
    private final boolean consumable;

    /**
     * Whether this resource is consumed over time (vs a concurrent limit).
     */
    public boolean isConsumable() {
        return consumable;
    }

    /**
     * Whether this resource represents a concurrent limit.
     */
    public boolean isConcurrentLimit() {
        return !consumable;
    }

    public static ResourceType fromCode(String code) {
        for (ResourceType type : values()) {
            if (type.code.equals(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown resource type code: " + code);
    }
}

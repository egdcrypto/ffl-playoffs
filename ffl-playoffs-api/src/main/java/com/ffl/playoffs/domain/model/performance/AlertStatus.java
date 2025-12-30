package com.ffl.playoffs.domain.model.performance;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Status of a performance alert.
 */
@Getter
@RequiredArgsConstructor
public enum AlertStatus {
    ACTIVE("active", "Active"),
    ACKNOWLEDGED("acknowledged", "Acknowledged"),
    RESOLVED("resolved", "Resolved"),
    SUPPRESSED("suppressed", "Suppressed");

    private final String code;
    private final String displayName;

    public boolean canTransitionTo(AlertStatus newStatus) {
        return switch (this) {
            case ACTIVE -> newStatus == ACKNOWLEDGED || newStatus == RESOLVED || newStatus == SUPPRESSED;
            case ACKNOWLEDGED -> newStatus == RESOLVED;
            case RESOLVED, SUPPRESSED -> false;
        };
    }

    public static AlertStatus fromCode(String code) {
        for (AlertStatus status : values()) {
            if (status.code.equals(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("Unknown alert status code: " + code);
    }
}

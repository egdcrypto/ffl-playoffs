package com.ffl.playoffs.domain.model.performance;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Severity levels for performance alerts.
 */
@Getter
@RequiredArgsConstructor
public enum AlertSeverity {
    INFO("info", "Informational", 1),
    WARNING("warning", "Warning", 2),
    CRITICAL("critical", "Critical", 3);

    private final String code;
    private final String displayName;
    private final int priority;

    public boolean isMoreSevereThan(AlertSeverity other) {
        return this.priority > other.priority;
    }

    public static AlertSeverity fromCode(String code) {
        for (AlertSeverity severity : values()) {
            if (severity.code.equals(code)) {
                return severity;
            }
        }
        throw new IllegalArgumentException("Unknown alert severity code: " + code);
    }
}

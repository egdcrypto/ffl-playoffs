package com.ffl.playoffs.domain.model.resource;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Behavior when resource limits are exceeded.
 */
@Getter
@RequiredArgsConstructor
public enum OverLimitBehavior {
    THROTTLE("throttle", "Throttle Operations"),
    QUEUE("queue", "Queue Requests"),
    REJECT("reject", "Reject Requests"),
    BURST("burst", "Allow Burst with Overage Charges");

    private final String code;
    private final String displayName;

    public static OverLimitBehavior fromCode(String code) {
        for (OverLimitBehavior behavior : values()) {
            if (behavior.code.equals(code)) {
                return behavior;
            }
        }
        throw new IllegalArgumentException("Unknown over-limit behavior code: " + code);
    }
}

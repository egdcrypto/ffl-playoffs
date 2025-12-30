package com.ffl.playoffs.domain.model.resource;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Actions that can be taken during auto-scaling.
 */
@Getter
@RequiredArgsConstructor
public enum ScalingAction {
    SCALE_UP("scale_up", "Scale Up"),
    SCALE_DOWN("scale_down", "Scale Down"),
    NO_ACTION("no_action", "No Action");

    private final String code;
    private final String displayName;

    public static ScalingAction fromCode(String code) {
        for (ScalingAction action : values()) {
            if (action.code.equals(code)) {
                return action;
            }
        }
        throw new IllegalArgumentException("Unknown scaling action code: " + code);
    }
}

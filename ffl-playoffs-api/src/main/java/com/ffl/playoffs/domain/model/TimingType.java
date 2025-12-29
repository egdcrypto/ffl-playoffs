package com.ffl.playoffs.domain.model;

/**
 * Types of event timing/duration.
 */
public enum TimingType {
    INSTANT("Single moment effect"),
    SINGLE_WEEK("Lasts one NFL week"),
    MULTI_WEEK("Spans multiple weeks"),
    SINGLE_GAME("Affects one game only"),
    INDEFINITE("Until cancelled/expired"),
    CONDITIONAL("Active when conditions met");

    private final String description;

    TimingType(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}

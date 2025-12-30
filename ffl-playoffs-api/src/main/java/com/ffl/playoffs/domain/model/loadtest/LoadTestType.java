package com.ffl.playoffs.domain.model.loadtest;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Types of load tests that can be executed.
 */
@Getter
@RequiredArgsConstructor
public enum LoadTestType {
    STRESS("stress", "Stress Test", "Tests system behavior under extreme load"),
    SOAK("soak", "Soak Test", "Tests system stability over extended periods"),
    SPIKE("spike", "Spike Test", "Tests system response to sudden load increases"),
    VOLUME("volume", "Volume Test", "Tests system with large data volumes"),
    CONCURRENCY("concurrency", "Concurrency Test", "Tests concurrent user handling"),
    ENDURANCE("endurance", "Endurance Test", "Tests long-running stability"),
    SCALABILITY("scalability", "Scalability Test", "Tests horizontal/vertical scaling");

    private final String code;
    private final String displayName;
    private final String description;
}

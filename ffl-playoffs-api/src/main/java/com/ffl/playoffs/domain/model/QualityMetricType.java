package com.ffl.playoffs.domain.model;

/**
 * Quality metric type enumeration
 * Defines the types of quality metrics for conversation evaluation
 */
public enum QualityMetricType {
    /**
     * How relevant the response is to the input
     */
    RELEVANCE,

    /**
     * Logical flow and consistency of the response
     */
    COHERENCE,

    /**
     * How well the character stays in persona
     */
    PERSONALITY_ADHERENCE,

    /**
     * How engaging and interesting the response is
     */
    ENGAGEMENT,

    /**
     * Safety and appropriateness of the response
     */
    SAFETY,

    /**
     * Emotional appropriateness of the response
     */
    EMOTIONAL_TONE
}

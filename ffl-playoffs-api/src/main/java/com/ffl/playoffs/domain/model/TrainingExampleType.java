package com.ffl.playoffs.domain.model;

/**
 * Training example type enumeration
 * Defines whether a conversation is a positive or negative training example
 */
public enum TrainingExampleType {
    /**
     * Positive example - demonstrates desired character behavior
     */
    POSITIVE,

    /**
     * Negative example - demonstrates undesired behavior to avoid
     */
    NEGATIVE
}

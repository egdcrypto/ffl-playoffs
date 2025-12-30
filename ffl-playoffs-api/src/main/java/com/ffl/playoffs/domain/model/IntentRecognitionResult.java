package com.ffl.playoffs.domain.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * Value object representing the result of intent recognition
 * Contains the recognized intent(s) and confidence scores
 */
public class IntentRecognitionResult {
    private final IntentType primaryIntent;
    private final double confidence;
    private final List<IntentType> secondaryIntents;
    private final boolean isAmbiguous;

    public IntentRecognitionResult(IntentType primaryIntent, double confidence) {
        if (confidence < 0.0 || confidence > 1.0) {
            throw new IllegalArgumentException("Confidence must be between 0 and 1");
        }
        this.primaryIntent = primaryIntent;
        this.confidence = confidence;
        this.secondaryIntents = new ArrayList<>();
        this.isAmbiguous = confidence < 0.5;
    }

    public IntentRecognitionResult(IntentType primaryIntent, double confidence, List<IntentType> secondaryIntents) {
        this(primaryIntent, confidence);
        if (secondaryIntents != null) {
            this.secondaryIntents.addAll(secondaryIntents);
        }
    }

    /**
     * Checks if the result is confident (above threshold)
     * @param threshold confidence threshold
     * @return true if confident
     */
    public boolean isConfident(double threshold) {
        return confidence >= threshold;
    }

    /**
     * Checks if multiple intents were recognized
     * @return true if multi-intent
     */
    public boolean isMultiIntent() {
        return !secondaryIntents.isEmpty();
    }

    /**
     * Gets all recognized intents (primary + secondary)
     * @return list of all intents
     */
    public List<IntentType> getAllIntents() {
        List<IntentType> all = new ArrayList<>();
        all.add(primaryIntent);
        all.addAll(secondaryIntents);
        return all;
    }

    /**
     * Checks if the recognized intent matches the expected intent
     * @param expected the expected intent
     * @return true if matching
     */
    public boolean matches(IntentType expected) {
        return primaryIntent == expected || secondaryIntents.contains(expected);
    }

    public IntentType getPrimaryIntent() {
        return primaryIntent;
    }

    public double getConfidence() {
        return confidence;
    }

    public List<IntentType> getSecondaryIntents() {
        return new ArrayList<>(secondaryIntents);
    }

    public boolean isAmbiguous() {
        return isAmbiguous;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        IntentRecognitionResult that = (IntentRecognitionResult) o;
        return Double.compare(that.confidence, confidence) == 0 &&
               primaryIntent == that.primaryIntent &&
               Objects.equals(secondaryIntents, that.secondaryIntents);
    }

    @Override
    public int hashCode() {
        return Objects.hash(primaryIntent, confidence, secondaryIntents);
    }

    @Override
    public String toString() {
        return String.format("IntentRecognitionResult{primary=%s, confidence=%.2f, secondary=%s, ambiguous=%s}",
            primaryIntent, confidence, secondaryIntents, isAmbiguous);
    }
}

package com.ffl.playoffs.domain.model;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/**
 * Value object representing quality scores for a conversation response
 * Contains scores for multiple quality dimensions
 */
public class QualityScore {
    private final double relevance;
    private final double coherence;
    private final double personalityAdherence;
    private final double engagement;
    private final double overall;
    private final Map<String, Double> additionalMetrics;

    public QualityScore(double relevance, double coherence, double personalityAdherence, double engagement) {
        validateScore(relevance, "relevance");
        validateScore(coherence, "coherence");
        validateScore(personalityAdherence, "personalityAdherence");
        validateScore(engagement, "engagement");

        this.relevance = relevance;
        this.coherence = coherence;
        this.personalityAdherence = personalityAdherence;
        this.engagement = engagement;
        this.overall = calculateOverall();
        this.additionalMetrics = new HashMap<>();
    }

    private void validateScore(double score, String name) {
        if (score < 0.0 || score > 1.0) {
            throw new IllegalArgumentException(name + " score must be between 0 and 1");
        }
    }

    private double calculateOverall() {
        // Weighted average of all scores
        return (relevance * 0.3 + coherence * 0.25 + personalityAdherence * 0.25 + engagement * 0.2);
    }

    /**
     * Adds an additional metric to the score
     * @param name metric name
     * @param value metric value (0-1)
     */
    public QualityScore withAdditionalMetric(String name, double value) {
        validateScore(value, name);
        QualityScore copy = new QualityScore(this.relevance, this.coherence, this.personalityAdherence, this.engagement);
        copy.additionalMetrics.putAll(this.additionalMetrics);
        copy.additionalMetrics.put(name, value);
        return copy;
    }

    /**
     * Checks if the overall quality meets a threshold
     * @param threshold minimum acceptable score
     * @return true if quality meets threshold
     */
    public boolean meetsThreshold(double threshold) {
        return overall >= threshold;
    }

    /**
     * Compares this score with another and returns the delta
     * @param other the score to compare with
     * @return quality score representing the difference
     */
    public QualityScore delta(QualityScore other) {
        return new QualityScore(
            this.relevance - other.relevance,
            this.coherence - other.coherence,
            this.personalityAdherence - other.personalityAdherence,
            this.engagement - other.engagement
        );
    }

    public double getRelevance() {
        return relevance;
    }

    public double getCoherence() {
        return coherence;
    }

    public double getPersonalityAdherence() {
        return personalityAdherence;
    }

    public double getEngagement() {
        return engagement;
    }

    public double getOverall() {
        return overall;
    }

    public Map<String, Double> getAdditionalMetrics() {
        return new HashMap<>(additionalMetrics);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        QualityScore that = (QualityScore) o;
        return Double.compare(that.relevance, relevance) == 0 &&
               Double.compare(that.coherence, coherence) == 0 &&
               Double.compare(that.personalityAdherence, personalityAdherence) == 0 &&
               Double.compare(that.engagement, engagement) == 0;
    }

    @Override
    public int hashCode() {
        return Objects.hash(relevance, coherence, personalityAdherence, engagement);
    }

    @Override
    public String toString() {
        return String.format("QualityScore{overall=%.2f, relevance=%.2f, coherence=%.2f, personality=%.2f, engagement=%.2f}",
            overall, relevance, coherence, personalityAdherence, engagement);
    }
}

package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.ABTestStatus;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;

/**
 * A/B test aggregate root
 * Represents an A/B test comparing different character configurations
 */
public class ABTest {
    private UUID id;
    private String name;
    private UUID characterId;
    private List<Variant> variants;
    private String successMetric;
    private int durationDays;
    private ABTestStatus status;
    private LocalDateTime startedAt;
    private LocalDateTime endedAt;
    private String winner;
    private double statisticalSignificance;
    private LocalDateTime createdAt;
    private UUID createdBy;

    public ABTest() {
        this.id = UUID.randomUUID();
        this.variants = new ArrayList<>();
        this.status = ABTestStatus.DRAFT;
        this.createdAt = LocalDateTime.now();
    }

    public ABTest(String name, UUID characterId, String successMetric, int durationDays) {
        this();
        this.name = name;
        this.characterId = characterId;
        this.successMetric = successMetric;
        this.durationDays = durationDays;
    }

    /**
     * Adds a variant to the test
     * @param variant the variant to add
     */
    public void addVariant(Variant variant) {
        Objects.requireNonNull(variant, "Variant cannot be null");
        this.variants.add(variant);
    }

    /**
     * Starts the A/B test
     */
    public void start() {
        if (this.variants.size() < 2) {
            throw new IllegalStateException("A/B test requires at least 2 variants");
        }
        validateWeights();
        this.status = ABTestStatus.RUNNING;
        this.startedAt = LocalDateTime.now();
    }

    /**
     * Pauses the A/B test
     */
    public void pause() {
        if (this.status != ABTestStatus.RUNNING) {
            throw new IllegalStateException("Can only pause a running test");
        }
        this.status = ABTestStatus.PAUSED;
    }

    /**
     * Resumes a paused test
     */
    public void resume() {
        if (this.status != ABTestStatus.PAUSED) {
            throw new IllegalStateException("Can only resume a paused test");
        }
        this.status = ABTestStatus.RUNNING;
    }

    /**
     * Concludes the test with results
     * @param winner the winning variant name
     * @param pValue statistical significance (p-value)
     */
    public void conclude(String winner, double pValue) {
        if (this.status != ABTestStatus.RUNNING) {
            throw new IllegalStateException("Can only conclude a running test");
        }
        this.status = ABTestStatus.CONCLUDED;
        this.winner = winner;
        this.statisticalSignificance = pValue;
        this.endedAt = LocalDateTime.now();
    }

    /**
     * Cancels the test
     */
    public void cancel() {
        this.status = ABTestStatus.CANCELLED;
        this.endedAt = LocalDateTime.now();
    }

    /**
     * Records a sample for a variant
     * @param variantName the variant name
     * @param metricValue the metric value observed
     */
    public void recordSample(String variantName, double metricValue) {
        variants.stream()
            .filter(v -> v.getName().equals(variantName))
            .findFirst()
            .ifPresent(v -> v.recordSample(metricValue));
    }

    /**
     * Gets the variant to assign based on weights
     * @param randomValue random value between 0 and 100
     * @return variant name
     */
    public String assignVariant(double randomValue) {
        double cumulative = 0;
        for (Variant variant : variants) {
            cumulative += variant.getWeight();
            if (randomValue < cumulative) {
                return variant.getName();
            }
        }
        return variants.get(variants.size() - 1).getName();
    }

    /**
     * Checks if the test has sufficient data
     * @param minSamplesPerVariant minimum samples required
     * @return true if sufficient data
     */
    public boolean hasSufficientData(int minSamplesPerVariant) {
        return variants.stream().allMatch(v -> v.getSampleCount() >= minSamplesPerVariant);
    }

    /**
     * Checks if test has reached its scheduled end date
     * @return true if should end
     */
    public boolean isExpired() {
        if (startedAt == null) return false;
        return LocalDateTime.now().isAfter(startedAt.plusDays(durationDays));
    }

    private void validateWeights() {
        int totalWeight = variants.stream().mapToInt(Variant::getWeight).sum();
        if (totalWeight != 100) {
            throw new IllegalStateException("Variant weights must sum to 100");
        }
    }

    // Getters and Setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public UUID getCharacterId() {
        return characterId;
    }

    public void setCharacterId(UUID characterId) {
        this.characterId = characterId;
    }

    public List<Variant> getVariants() {
        return new ArrayList<>(variants);
    }

    public void setVariants(List<Variant> variants) {
        this.variants = variants != null ? new ArrayList<>(variants) : new ArrayList<>();
    }

    public String getSuccessMetric() {
        return successMetric;
    }

    public void setSuccessMetric(String successMetric) {
        this.successMetric = successMetric;
    }

    public int getDurationDays() {
        return durationDays;
    }

    public void setDurationDays(int durationDays) {
        this.durationDays = durationDays;
    }

    public ABTestStatus getStatus() {
        return status;
    }

    public void setStatus(ABTestStatus status) {
        this.status = status;
    }

    public LocalDateTime getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(LocalDateTime startedAt) {
        this.startedAt = startedAt;
    }

    public LocalDateTime getEndedAt() {
        return endedAt;
    }

    public void setEndedAt(LocalDateTime endedAt) {
        this.endedAt = endedAt;
    }

    public String getWinner() {
        return winner;
    }

    public void setWinner(String winner) {
        this.winner = winner;
    }

    public double getStatisticalSignificance() {
        return statisticalSignificance;
    }

    public void setStatisticalSignificance(double statisticalSignificance) {
        this.statisticalSignificance = statisticalSignificance;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public UUID getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(UUID createdBy) {
        this.createdBy = createdBy;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ABTest abTest = (ABTest) o;
        return Objects.equals(id, abTest.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    /**
     * Inner class representing an A/B test variant
     */
    public static class Variant {
        private String name;
        private Map<String, Object> config;
        private int weight;
        private List<Double> samples;
        private double averageMetric;

        public Variant() {
            this.config = new HashMap<>();
            this.samples = new ArrayList<>();
        }

        public Variant(String name, Map<String, Object> config, int weight) {
            this();
            this.name = name;
            this.config = config != null ? new HashMap<>(config) : new HashMap<>();
            this.weight = weight;
        }

        public void recordSample(double value) {
            this.samples.add(value);
            this.averageMetric = samples.stream().mapToDouble(Double::doubleValue).average().orElse(0);
        }

        public int getSampleCount() {
            return samples.size();
        }

        public double getStandardDeviation() {
            if (samples.size() < 2) return 0;
            double mean = averageMetric;
            double variance = samples.stream()
                .mapToDouble(s -> Math.pow(s - mean, 2))
                .average()
                .orElse(0);
            return Math.sqrt(variance);
        }

        // Getters and Setters
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public Map<String, Object> getConfig() { return new HashMap<>(config); }
        public void setConfig(Map<String, Object> config) { this.config = config != null ? new HashMap<>(config) : new HashMap<>(); }
        public int getWeight() { return weight; }
        public void setWeight(int weight) { this.weight = weight; }
        public List<Double> getSamples() { return new ArrayList<>(samples); }
        public void setSamples(List<Double> samples) { this.samples = samples != null ? new ArrayList<>(samples) : new ArrayList<>(); }
        public double getAverageMetric() { return averageMetric; }
        public void setAverageMetric(double averageMetric) { this.averageMetric = averageMetric; }
    }
}

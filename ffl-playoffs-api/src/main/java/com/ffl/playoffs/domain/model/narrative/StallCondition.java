package com.ffl.playoffs.domain.model.narrative;

import lombok.Getter;

import java.time.Instant;
import java.util.*;

/**
 * Represents a detected stall condition in the narrative.
 * Stalls are periods of low engagement or narrative inactivity.
 */
@Getter
public class StallCondition {

    private final UUID id;
    private final UUID leagueId;
    private final StallConditionType type;
    private final String description;
    private final Instant detectedAt;
    private final Instant stallStartedAt;
    private Instant resolvedAt;

    // Severity and impact
    private final StallConditionType.SeverityLevel severity;
    private int stallDurationHours;

    // Context
    private final Set<UUID> affectedPlayerIds;
    private final Map<String, Object> diagnosticData;

    // Resolution
    private boolean resolved;
    private CuratorActionType resolutionAction;
    private String resolutionNotes;

    private StallCondition(Builder builder) {
        this.id = builder.id;
        this.leagueId = Objects.requireNonNull(builder.leagueId, "League ID is required");
        this.type = Objects.requireNonNull(builder.type, "Stall condition type is required");
        this.description = builder.description;
        this.detectedAt = Instant.now();
        this.stallStartedAt = Objects.requireNonNull(builder.stallStartedAt, "Stall start time is required");
        this.severity = type.getSeverity();
        this.stallDurationHours = calculateDurationHours(builder.stallStartedAt);
        this.affectedPlayerIds = new HashSet<>(builder.affectedPlayerIds);
        this.diagnosticData = new HashMap<>(builder.diagnosticData);
        this.resolved = false;
    }

    private int calculateDurationHours(Instant startTime) {
        return (int) java.time.Duration.between(startTime, Instant.now()).toHours();
    }

    /**
     * Create a new stall condition builder
     */
    public static Builder builder() {
        return new Builder();
    }

    /**
     * Detect a stall condition
     */
    public static StallCondition detect(UUID leagueId, StallConditionType type,
                                         Instant stallStartedAt, String description) {
        return builder()
                .leagueId(leagueId)
                .type(type)
                .stallStartedAt(stallStartedAt)
                .description(description)
                .build();
    }

    /**
     * Resolve this stall condition
     */
    public void resolve(CuratorActionType action, String notes) {
        if (resolved) {
            throw new IllegalStateException("Stall condition is already resolved");
        }
        this.resolved = true;
        this.resolvedAt = Instant.now();
        this.resolutionAction = action;
        this.resolutionNotes = notes;
    }

    /**
     * Update the stall duration
     */
    public void updateDuration() {
        if (!resolved) {
            this.stallDurationHours = calculateDurationHours(stallStartedAt);
        }
    }

    /**
     * Add an affected player
     */
    public void addAffectedPlayer(UUID playerId) {
        Objects.requireNonNull(playerId, "Player ID cannot be null");
        this.affectedPlayerIds.add(playerId);
    }

    /**
     * Add diagnostic data
     */
    public void addDiagnosticData(String key, Object value) {
        Objects.requireNonNull(key, "Key cannot be null");
        this.diagnosticData.put(key, value);
    }

    /**
     * Check if this stall exceeds its threshold
     */
    public boolean exceedsThreshold() {
        return stallDurationHours >= type.getDefaultThresholdHours();
    }

    /**
     * Check if this stall requires immediate attention
     */
    public boolean requiresImmediateAttention() {
        return type.requiresImmediateAttention() || exceedsThreshold();
    }

    /**
     * Get the recommended curator action
     */
    public CuratorActionType getRecommendedAction() {
        return type.getRecommendedAction();
    }

    /**
     * Get immutable set of affected player IDs
     */
    public Set<UUID> getAffectedPlayerIds() {
        return Collections.unmodifiableSet(affectedPlayerIds);
    }

    /**
     * Get immutable map of diagnostic data
     */
    public Map<String, Object> getDiagnosticData() {
        return Collections.unmodifiableMap(diagnosticData);
    }

    /**
     * Get hours until threshold is exceeded
     */
    public int getHoursUntilThreshold() {
        int remaining = type.getDefaultThresholdHours() - stallDurationHours;
        return Math.max(0, remaining);
    }

    public static class Builder {
        private UUID id = UUID.randomUUID();
        private UUID leagueId;
        private StallConditionType type;
        private String description;
        private Instant stallStartedAt;
        private Set<UUID> affectedPlayerIds = new HashSet<>();
        private Map<String, Object> diagnosticData = new HashMap<>();

        public Builder id(UUID id) {
            this.id = id;
            return this;
        }

        public Builder leagueId(UUID leagueId) {
            this.leagueId = leagueId;
            return this;
        }

        public Builder type(StallConditionType type) {
            this.type = type;
            return this;
        }

        public Builder description(String description) {
            this.description = description;
            return this;
        }

        public Builder stallStartedAt(Instant stallStartedAt) {
            this.stallStartedAt = stallStartedAt;
            return this;
        }

        public Builder affectedPlayerIds(Set<UUID> affectedPlayerIds) {
            this.affectedPlayerIds = affectedPlayerIds != null ? new HashSet<>(affectedPlayerIds) : new HashSet<>();
            return this;
        }

        public Builder addAffectedPlayerId(UUID playerId) {
            this.affectedPlayerIds.add(playerId);
            return this;
        }

        public Builder diagnosticData(Map<String, Object> diagnosticData) {
            this.diagnosticData = diagnosticData != null ? new HashMap<>(diagnosticData) : new HashMap<>();
            return this;
        }

        public Builder addDiagnosticData(String key, Object value) {
            this.diagnosticData.put(key, value);
            return this;
        }

        public StallCondition build() {
            return new StallCondition(this);
        }
    }
}

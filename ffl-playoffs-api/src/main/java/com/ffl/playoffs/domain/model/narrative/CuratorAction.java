package com.ffl.playoffs.domain.model.narrative;

import lombok.Getter;

import java.time.Instant;
import java.util.*;

/**
 * Represents an action taken by the AI Director or human curator
 * to influence the narrative.
 */
@Getter
public class CuratorAction {

    private final UUID id;
    private final UUID leagueId;
    private final CuratorActionType type;
    private final String description;
    private final boolean automated;
    private final UUID initiatedBy; // null for AI-initiated actions

    // Timing
    private final Instant createdAt;
    private Instant executedAt;
    private Instant completedAt;

    // Status
    private ActionStatus status;
    private String statusMessage;

    // Context
    private final UUID relatedStallConditionId;
    private final UUID relatedStoryArcId;
    private final Set<UUID> targetPlayerIds;
    private final Map<String, Object> parameters;

    // Results
    private Map<String, Object> results;

    /**
     * Status of curator action execution
     */
    public enum ActionStatus {
        PENDING, IN_PROGRESS, COMPLETED, FAILED, CANCELLED
    }

    private CuratorAction(Builder builder) {
        this.id = builder.id;
        this.leagueId = Objects.requireNonNull(builder.leagueId, "League ID is required");
        this.type = Objects.requireNonNull(builder.type, "Action type is required");
        this.description = builder.description;
        this.automated = builder.automated;
        this.initiatedBy = builder.initiatedBy;
        this.createdAt = Instant.now();
        this.status = ActionStatus.PENDING;
        this.relatedStallConditionId = builder.relatedStallConditionId;
        this.relatedStoryArcId = builder.relatedStoryArcId;
        this.targetPlayerIds = new HashSet<>(builder.targetPlayerIds);
        this.parameters = new HashMap<>(builder.parameters);
        this.results = new HashMap<>();
    }

    /**
     * Create a new curator action builder
     */
    public static Builder builder() {
        return new Builder();
    }

    /**
     * Create an automated AI action
     */
    public static CuratorAction createAutomated(UUID leagueId, CuratorActionType type, String description) {
        return builder()
                .leagueId(leagueId)
                .type(type)
                .description(description)
                .automated(true)
                .build();
    }

    /**
     * Create a human curator action
     */
    public static CuratorAction createManual(UUID leagueId, CuratorActionType type,
                                              String description, UUID curatorId) {
        return builder()
                .leagueId(leagueId)
                .type(type)
                .description(description)
                .automated(false)
                .initiatedBy(curatorId)
                .build();
    }

    /**
     * Start execution of this action
     */
    public void startExecution() {
        if (status != ActionStatus.PENDING) {
            throw new IllegalStateException("Can only start execution of pending actions");
        }
        this.status = ActionStatus.IN_PROGRESS;
        this.executedAt = Instant.now();
    }

    /**
     * Complete this action successfully
     */
    public void complete(Map<String, Object> results) {
        if (status != ActionStatus.IN_PROGRESS) {
            throw new IllegalStateException("Can only complete in-progress actions");
        }
        this.status = ActionStatus.COMPLETED;
        this.completedAt = Instant.now();
        this.results = results != null ? new HashMap<>(results) : new HashMap<>();
        this.statusMessage = "Action completed successfully";
    }

    /**
     * Mark this action as failed
     */
    public void fail(String reason) {
        if (status != ActionStatus.IN_PROGRESS && status != ActionStatus.PENDING) {
            throw new IllegalStateException("Cannot fail action in status: " + status);
        }
        this.status = ActionStatus.FAILED;
        this.completedAt = Instant.now();
        this.statusMessage = reason;
    }

    /**
     * Cancel this action
     */
    public void cancel(String reason) {
        if (status != ActionStatus.PENDING) {
            throw new IllegalStateException("Can only cancel pending actions");
        }
        this.status = ActionStatus.CANCELLED;
        this.completedAt = Instant.now();
        this.statusMessage = reason;
    }

    /**
     * Add a result value
     */
    public void addResult(String key, Object value) {
        Objects.requireNonNull(key, "Key cannot be null");
        this.results.put(key, value);
    }

    /**
     * Add a target player
     */
    public void addTargetPlayer(UUID playerId) {
        Objects.requireNonNull(playerId, "Player ID cannot be null");
        this.targetPlayerIds.add(playerId);
    }

    /**
     * Check if this action is complete (successfully or not)
     */
    public boolean isTerminal() {
        return status == ActionStatus.COMPLETED ||
               status == ActionStatus.FAILED ||
               status == ActionStatus.CANCELLED;
    }

    /**
     * Check if this action was successful
     */
    public boolean isSuccessful() {
        return status == ActionStatus.COMPLETED;
    }

    /**
     * Check if this action requires confirmation before execution
     */
    public boolean requiresConfirmation() {
        return type.isRequiresConfirmation() && !automated;
    }

    /**
     * Check if this action targets specific players
     */
    public boolean hasTargetPlayers() {
        return !targetPlayerIds.isEmpty();
    }

    /**
     * Get immutable set of target player IDs
     */
    public Set<UUID> getTargetPlayerIds() {
        return Collections.unmodifiableSet(targetPlayerIds);
    }

    /**
     * Get immutable map of parameters
     */
    public Map<String, Object> getParameters() {
        return Collections.unmodifiableMap(parameters);
    }

    /**
     * Get immutable map of results
     */
    public Map<String, Object> getResults() {
        return Collections.unmodifiableMap(results);
    }

    /**
     * Get execution duration in milliseconds
     */
    public Long getExecutionDurationMs() {
        if (executedAt == null || completedAt == null) {
            return null;
        }
        return java.time.Duration.between(executedAt, completedAt).toMillis();
    }

    public static class Builder {
        private UUID id = UUID.randomUUID();
        private UUID leagueId;
        private CuratorActionType type;
        private String description;
        private boolean automated = false;
        private UUID initiatedBy;
        private UUID relatedStallConditionId;
        private UUID relatedStoryArcId;
        private Set<UUID> targetPlayerIds = new HashSet<>();
        private Map<String, Object> parameters = new HashMap<>();

        public Builder id(UUID id) {
            this.id = id;
            return this;
        }

        public Builder leagueId(UUID leagueId) {
            this.leagueId = leagueId;
            return this;
        }

        public Builder type(CuratorActionType type) {
            this.type = type;
            return this;
        }

        public Builder description(String description) {
            this.description = description;
            return this;
        }

        public Builder automated(boolean automated) {
            this.automated = automated;
            return this;
        }

        public Builder initiatedBy(UUID initiatedBy) {
            this.initiatedBy = initiatedBy;
            return this;
        }

        public Builder relatedStallConditionId(UUID relatedStallConditionId) {
            this.relatedStallConditionId = relatedStallConditionId;
            return this;
        }

        public Builder relatedStoryArcId(UUID relatedStoryArcId) {
            this.relatedStoryArcId = relatedStoryArcId;
            return this;
        }

        public Builder targetPlayerIds(Set<UUID> targetPlayerIds) {
            this.targetPlayerIds = targetPlayerIds != null ? new HashSet<>(targetPlayerIds) : new HashSet<>();
            return this;
        }

        public Builder addTargetPlayerId(UUID playerId) {
            this.targetPlayerIds.add(playerId);
            return this;
        }

        public Builder parameters(Map<String, Object> parameters) {
            this.parameters = parameters != null ? new HashMap<>(parameters) : new HashMap<>();
            return this;
        }

        public Builder addParameter(String key, Object value) {
            this.parameters.put(key, value);
            return this;
        }

        public CuratorAction build() {
            return new CuratorAction(this);
        }
    }
}

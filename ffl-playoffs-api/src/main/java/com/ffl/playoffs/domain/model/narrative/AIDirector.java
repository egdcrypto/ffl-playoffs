package com.ffl.playoffs.domain.model.narrative;

import lombok.Getter;

import java.time.Instant;
import java.util.*;

/**
 * AI Director - The main aggregate for narrative orchestration.
 * Manages the narrative state, story DAG, tension levels, stall detection,
 * and curator controls for a league.
 */
@Getter
public class AIDirector {

    private final UUID id;
    private final UUID leagueId;
    private NarrativePhase currentPhase;
    private TensionLevel currentTensionLevel;
    private int tensionScore; // 0-100

    // State
    private DirectorStatus status;
    private boolean automationEnabled;
    private final Instant createdAt;
    private Instant updatedAt;
    private Instant lastActivityAt;

    // Active elements
    private UUID activeStoryArcId;
    private final Set<UUID> activeStallConditionIds;
    private final Set<UUID> pendingActionIds;

    // Configuration
    private int stallDetectionThresholdHours;
    private int tensionTargetScore;
    private boolean autoGenerateStoryBeats;
    private boolean autoResolveStalls;

    // Metrics
    private int totalStoryBeatsGenerated;
    private int totalStallsDetected;
    private int totalActionsExecuted;

    /**
     * Status of the AI Director
     */
    public enum DirectorStatus {
        ACTIVE("active", "Active", true),
        PAUSED("paused", "Paused", false),
        SUSPENDED("suspended", "Suspended", false);

        @Getter
        private final String code;
        @Getter
        private final String displayName;
        @Getter
        private final boolean operational;

        DirectorStatus(String code, String displayName, boolean operational) {
            this.code = code;
            this.displayName = displayName;
            this.operational = operational;
        }

        public static DirectorStatus fromCode(String code) {
            for (DirectorStatus status : values()) {
                if (status.code.equalsIgnoreCase(code)) {
                    return status;
                }
            }
            throw new IllegalArgumentException("Unknown director status code: " + code);
        }
    }

    private AIDirector(UUID id, UUID leagueId) {
        this.id = id != null ? id : UUID.randomUUID();
        this.leagueId = Objects.requireNonNull(leagueId, "League ID is required");
        this.currentPhase = NarrativePhase.SETUP;
        this.currentTensionLevel = TensionLevel.MODERATE;
        this.tensionScore = 50;
        this.status = DirectorStatus.ACTIVE;
        this.automationEnabled = true;
        this.createdAt = Instant.now();
        this.updatedAt = Instant.now();
        this.lastActivityAt = Instant.now();
        this.activeStallConditionIds = new HashSet<>();
        this.pendingActionIds = new HashSet<>();
        this.stallDetectionThresholdHours = 24;
        this.tensionTargetScore = 60;
        this.autoGenerateStoryBeats = true;
        this.autoResolveStalls = true;
        this.totalStoryBeatsGenerated = 0;
        this.totalStallsDetected = 0;
        this.totalActionsExecuted = 0;
    }

    /**
     * Create a new AI Director for a league
     */
    public static AIDirector create(UUID leagueId) {
        return new AIDirector(null, leagueId);
    }

    /**
     * Reconstitute from persistence
     */
    public static AIDirector reconstitute(
            UUID id, UUID leagueId, NarrativePhase currentPhase,
            TensionLevel currentTensionLevel, int tensionScore,
            DirectorStatus status, boolean automationEnabled,
            Instant createdAt, Instant updatedAt, Instant lastActivityAt,
            UUID activeStoryArcId, Set<UUID> activeStallConditionIds,
            Set<UUID> pendingActionIds, int stallDetectionThresholdHours,
            int tensionTargetScore, boolean autoGenerateStoryBeats,
            boolean autoResolveStalls, int totalStoryBeatsGenerated,
            int totalStallsDetected, int totalActionsExecuted) {

        AIDirector director = new AIDirector(id, leagueId);
        director.currentPhase = currentPhase;
        director.currentTensionLevel = currentTensionLevel;
        director.tensionScore = tensionScore;
        director.status = status;
        director.automationEnabled = automationEnabled;
        director.lastActivityAt = lastActivityAt;
        director.activeStoryArcId = activeStoryArcId;
        director.activeStallConditionIds.clear();
        director.activeStallConditionIds.addAll(activeStallConditionIds);
        director.pendingActionIds.clear();
        director.pendingActionIds.addAll(pendingActionIds);
        director.stallDetectionThresholdHours = stallDetectionThresholdHours;
        director.tensionTargetScore = tensionTargetScore;
        director.autoGenerateStoryBeats = autoGenerateStoryBeats;
        director.autoResolveStalls = autoResolveStalls;
        director.totalStoryBeatsGenerated = totalStoryBeatsGenerated;
        director.totalStallsDetected = totalStallsDetected;
        director.totalActionsExecuted = totalActionsExecuted;
        return director;
    }

    // ==================
    // Tension Management
    // ==================

    /**
     * Update the tension score and level
     */
    public void updateTension(int newScore) {
        if (newScore < 0) newScore = 0;
        if (newScore > 100) newScore = 100;

        this.tensionScore = newScore;
        this.currentTensionLevel = TensionLevel.fromScore(newScore);
        this.updatedAt = Instant.now();
    }

    /**
     * Apply tension impact from a story beat
     */
    public void applyTensionImpact(int impact) {
        int newScore = tensionScore + (int)(impact * currentPhase.getTensionMultiplier());
        updateTension(newScore);
    }

    /**
     * Adjust tension towards target
     */
    public void adjustTensionTowardsTarget() {
        if (tensionScore < tensionTargetScore) {
            updateTension(tensionScore + 1);
        } else if (tensionScore > tensionTargetScore) {
            updateTension(tensionScore - 1);
        }
    }

    /**
     * Check if tension is at critical level
     */
    public boolean isTensionCritical() {
        return currentTensionLevel == TensionLevel.CRITICAL;
    }

    /**
     * Check if tension indicates stall risk
     */
    public boolean isTensionLow() {
        return currentTensionLevel.isStallRisk();
    }

    // ==================
    // Phase Management
    // ==================

    /**
     * Advance to the next narrative phase
     */
    public void advancePhase() {
        if (!status.isOperational()) {
            throw new IllegalStateException("Cannot advance phase when director is not operational");
        }

        NarrativePhase nextPhase = currentPhase.getNextPhase();
        if (nextPhase == null) {
            throw new IllegalStateException("Cannot advance beyond RESOLUTION phase");
        }

        this.currentPhase = nextPhase;
        this.updatedAt = Instant.now();
        recordActivity();
    }

    /**
     * Set the narrative phase directly (curator override)
     */
    public void overridePhase(NarrativePhase phase) {
        Objects.requireNonNull(phase, "Phase cannot be null");
        this.currentPhase = phase;
        this.updatedAt = Instant.now();
        recordActivity();
    }

    // ==================
    // Story Arc Management
    // ==================

    /**
     * Set the active story arc
     */
    public void setActiveStoryArc(UUID storyArcId) {
        this.activeStoryArcId = storyArcId;
        this.updatedAt = Instant.now();
        recordActivity();
    }

    /**
     * Clear the active story arc
     */
    public void clearActiveStoryArc() {
        this.activeStoryArcId = null;
        this.updatedAt = Instant.now();
    }

    /**
     * Check if there is an active story arc
     */
    public boolean hasActiveStoryArc() {
        return activeStoryArcId != null;
    }

    /**
     * Record a new story beat generated
     */
    public void recordStoryBeatGenerated() {
        this.totalStoryBeatsGenerated++;
        this.updatedAt = Instant.now();
        recordActivity();
    }

    // ==================
    // Stall Detection
    // ==================

    /**
     * Register a detected stall condition
     */
    public void registerStallCondition(UUID stallConditionId) {
        Objects.requireNonNull(stallConditionId, "Stall condition ID cannot be null");
        this.activeStallConditionIds.add(stallConditionId);
        this.totalStallsDetected++;
        this.updatedAt = Instant.now();
    }

    /**
     * Resolve a stall condition
     */
    public void resolveStallCondition(UUID stallConditionId) {
        this.activeStallConditionIds.remove(stallConditionId);
        this.updatedAt = Instant.now();
        recordActivity();
    }

    /**
     * Check if there are active stall conditions
     */
    public boolean hasActiveStalls() {
        return !activeStallConditionIds.isEmpty();
    }

    /**
     * Get the count of active stall conditions
     */
    public int getActiveStallCount() {
        return activeStallConditionIds.size();
    }

    // ==================
    // Curator Actions
    // ==================

    /**
     * Queue a pending action
     */
    public void queueAction(UUID actionId) {
        Objects.requireNonNull(actionId, "Action ID cannot be null");
        this.pendingActionIds.add(actionId);
        this.updatedAt = Instant.now();
    }

    /**
     * Complete an action
     */
    public void completeAction(UUID actionId) {
        this.pendingActionIds.remove(actionId);
        this.totalActionsExecuted++;
        this.updatedAt = Instant.now();
        recordActivity();
    }

    /**
     * Check if there are pending actions
     */
    public boolean hasPendingActions() {
        return !pendingActionIds.isEmpty();
    }

    /**
     * Get the count of pending actions
     */
    public int getPendingActionCount() {
        return pendingActionIds.size();
    }

    // ==================
    // Director Controls
    // ==================

    /**
     * Pause the AI Director
     */
    public void pause() {
        if (status != DirectorStatus.ACTIVE) {
            throw new IllegalStateException("Can only pause active director");
        }
        this.status = DirectorStatus.PAUSED;
        this.updatedAt = Instant.now();
    }

    /**
     * Resume the AI Director
     */
    public void resume() {
        if (status != DirectorStatus.PAUSED) {
            throw new IllegalStateException("Can only resume paused director");
        }
        this.status = DirectorStatus.ACTIVE;
        this.updatedAt = Instant.now();
        recordActivity();
    }

    /**
     * Suspend the AI Director
     */
    public void suspend() {
        this.status = DirectorStatus.SUSPENDED;
        this.automationEnabled = false;
        this.updatedAt = Instant.now();
    }

    /**
     * Reactivate a suspended director
     */
    public void reactivate() {
        if (status != DirectorStatus.SUSPENDED) {
            throw new IllegalStateException("Can only reactivate suspended director");
        }
        this.status = DirectorStatus.ACTIVE;
        this.updatedAt = Instant.now();
        recordActivity();
    }

    /**
     * Enable automation
     */
    public void enableAutomation() {
        this.automationEnabled = true;
        this.updatedAt = Instant.now();
    }

    /**
     * Disable automation
     */
    public void disableAutomation() {
        this.automationEnabled = false;
        this.updatedAt = Instant.now();
    }

    /**
     * Check if the director is operational
     */
    public boolean isOperational() {
        return status.isOperational();
    }

    /**
     * Check if automation can run
     */
    public boolean canRunAutomation() {
        return isOperational() && automationEnabled;
    }

    // ==================
    // Configuration
    // ==================

    /**
     * Update stall detection threshold
     */
    public void setStallDetectionThreshold(int hours) {
        if (hours < 1) {
            throw new IllegalArgumentException("Stall detection threshold must be at least 1 hour");
        }
        this.stallDetectionThresholdHours = hours;
        this.updatedAt = Instant.now();
    }

    /**
     * Update tension target score
     */
    public void setTensionTarget(int targetScore) {
        if (targetScore < 0 || targetScore > 100) {
            throw new IllegalArgumentException("Tension target must be between 0 and 100");
        }
        this.tensionTargetScore = targetScore;
        this.updatedAt = Instant.now();
    }

    /**
     * Enable/disable auto story beat generation
     */
    public void setAutoGenerateStoryBeats(boolean enabled) {
        this.autoGenerateStoryBeats = enabled;
        this.updatedAt = Instant.now();
    }

    /**
     * Enable/disable auto stall resolution
     */
    public void setAutoResolveStalls(boolean enabled) {
        this.autoResolveStalls = enabled;
        this.updatedAt = Instant.now();
    }

    // ==================
    // Activity Tracking
    // ==================

    private void recordActivity() {
        this.lastActivityAt = Instant.now();
    }

    /**
     * Get hours since last activity
     */
    public long getHoursSinceLastActivity() {
        return java.time.Duration.between(lastActivityAt, Instant.now()).toHours();
    }

    /**
     * Check if the director has been inactive
     */
    public boolean isInactive() {
        return getHoursSinceLastActivity() >= stallDetectionThresholdHours;
    }

    // ==================
    // Getters for immutable collections
    // ==================

    public Set<UUID> getActiveStallConditionIds() {
        return Collections.unmodifiableSet(activeStallConditionIds);
    }

    public Set<UUID> getPendingActionIds() {
        return Collections.unmodifiableSet(pendingActionIds);
    }
}

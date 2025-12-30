package com.ffl.playoffs.domain.model.narrative;

import lombok.Getter;

import java.time.Instant;
import java.util.*;

/**
 * Represents a cohesive narrative thread or story arc.
 * An arc contains multiple story beats that form a coherent narrative.
 */
@Getter
public class StoryArc {

    private final UUID id;
    private final UUID leagueId;
    private String title;
    private String description;
    private StoryArcStatus status;
    private NarrativePhase currentPhase;
    private final Instant createdAt;
    private Instant updatedAt;
    private Instant completedAt;

    // Arc structure
    private final List<UUID> beatIds;
    private final Set<UUID> involvedPlayerIds;
    private UUID rootBeatId;

    // Metrics
    private int peakTensionLevel;
    private int beatCount;

    private StoryArc(UUID id, UUID leagueId, String title, String description) {
        this.id = id != null ? id : UUID.randomUUID();
        this.leagueId = Objects.requireNonNull(leagueId, "League ID is required");
        this.title = validateTitle(title);
        this.description = description;
        this.status = StoryArcStatus.ACTIVE;
        this.currentPhase = NarrativePhase.SETUP;
        this.createdAt = Instant.now();
        this.updatedAt = Instant.now();
        this.beatIds = new ArrayList<>();
        this.involvedPlayerIds = new HashSet<>();
        this.peakTensionLevel = 0;
        this.beatCount = 0;
    }

    private String validateTitle(String title) {
        if (title == null || title.isBlank()) {
            throw new IllegalArgumentException("Story arc title cannot be blank");
        }
        return title.trim();
    }

    /**
     * Create a new story arc
     */
    public static StoryArc create(UUID leagueId, String title, String description) {
        return new StoryArc(null, leagueId, title, description);
    }

    /**
     * Reconstitute from persistence
     */
    public static StoryArc reconstitute(
            UUID id, UUID leagueId, String title, String description,
            StoryArcStatus status, NarrativePhase currentPhase,
            Instant createdAt, Instant updatedAt, Instant completedAt,
            List<UUID> beatIds, Set<UUID> involvedPlayerIds, UUID rootBeatId,
            int peakTensionLevel, int beatCount) {

        StoryArc arc = new StoryArc(id, leagueId, title, description);
        arc.status = status;
        arc.currentPhase = currentPhase;
        arc.completedAt = completedAt;
        arc.beatIds.clear();
        arc.beatIds.addAll(beatIds);
        arc.involvedPlayerIds.clear();
        arc.involvedPlayerIds.addAll(involvedPlayerIds);
        arc.rootBeatId = rootBeatId;
        arc.peakTensionLevel = peakTensionLevel;
        arc.beatCount = beatCount;
        return arc;
    }

    /**
     * Add a story beat to this arc
     */
    public void addBeat(StoryBeat beat) {
        Objects.requireNonNull(beat, "Story beat cannot be null");

        if (!status.canAddBeats()) {
            throw new IllegalStateException("Cannot add beats to arc in status: " + status);
        }

        if (beatIds.isEmpty()) {
            this.rootBeatId = beat.getId();
        }

        this.beatIds.add(beat.getId());
        this.involvedPlayerIds.addAll(beat.getInvolvedPlayerIds());
        this.beatCount++;

        // Track peak tension
        int newTension = calculateCurrentTension(beat.getTensionImpact());
        if (newTension > peakTensionLevel) {
            this.peakTensionLevel = newTension;
        }

        this.updatedAt = Instant.now();
    }

    private int calculateCurrentTension(int impact) {
        // Simplified tension calculation
        return Math.min(100, Math.max(0, peakTensionLevel + impact));
    }

    /**
     * Advance to the next narrative phase
     */
    public void advancePhase() {
        if (!status.isOngoing()) {
            throw new IllegalStateException("Cannot advance phase for arc in status: " + status);
        }

        NarrativePhase nextPhase = currentPhase.getNextPhase();
        if (nextPhase == null) {
            throw new IllegalStateException("Cannot advance beyond RESOLUTION phase");
        }

        this.currentPhase = nextPhase;
        this.updatedAt = Instant.now();
    }

    /**
     * Set the narrative phase directly
     */
    public void setPhase(NarrativePhase phase) {
        Objects.requireNonNull(phase, "Phase cannot be null");
        if (!status.isOngoing()) {
            throw new IllegalStateException("Cannot set phase for arc in status: " + status);
        }
        this.currentPhase = phase;
        this.updatedAt = Instant.now();
    }

    /**
     * Pause this arc
     */
    public void pause() {
        if (status != StoryArcStatus.ACTIVE) {
            throw new IllegalStateException("Can only pause active arcs");
        }
        this.status = StoryArcStatus.PAUSED;
        this.updatedAt = Instant.now();
    }

    /**
     * Resume this arc
     */
    public void resume() {
        if (!status.canResume()) {
            throw new IllegalStateException("Cannot resume arc in status: " + status);
        }
        this.status = StoryArcStatus.ACTIVE;
        this.updatedAt = Instant.now();
    }

    /**
     * Complete this arc
     */
    public void complete() {
        if (!status.isOngoing()) {
            throw new IllegalStateException("Cannot complete arc in status: " + status);
        }
        this.status = StoryArcStatus.COMPLETED;
        this.completedAt = Instant.now();
        this.updatedAt = Instant.now();
    }

    /**
     * Archive this arc
     */
    public void archive() {
        if (!status.canArchive()) {
            throw new IllegalStateException("Can only archive completed arcs");
        }
        this.status = StoryArcStatus.ARCHIVED;
        this.updatedAt = Instant.now();
    }

    /**
     * Update the title
     */
    public void updateTitle(String title) {
        this.title = validateTitle(title);
        this.updatedAt = Instant.now();
    }

    /**
     * Update the description
     */
    public void updateDescription(String description) {
        this.description = description;
        this.updatedAt = Instant.now();
    }

    /**
     * Add an involved player
     */
    public void addInvolvedPlayer(UUID playerId) {
        Objects.requireNonNull(playerId, "Player ID cannot be null");
        this.involvedPlayerIds.add(playerId);
        this.updatedAt = Instant.now();
    }

    /**
     * Check if a player is involved in this arc
     */
    public boolean involvesPlayer(UUID playerId) {
        return involvedPlayerIds.contains(playerId);
    }

    /**
     * Check if this arc has any beats
     */
    public boolean hasBeats() {
        return !beatIds.isEmpty();
    }

    /**
     * Get immutable list of beat IDs
     */
    public List<UUID> getBeatIds() {
        return Collections.unmodifiableList(beatIds);
    }

    /**
     * Get immutable set of involved player IDs
     */
    public Set<UUID> getInvolvedPlayerIds() {
        return Collections.unmodifiableSet(involvedPlayerIds);
    }

    /**
     * Get the current duration in hours
     */
    public long getDurationHours() {
        Instant end = completedAt != null ? completedAt : Instant.now();
        return java.time.Duration.between(createdAt, end).toHours();
    }
}

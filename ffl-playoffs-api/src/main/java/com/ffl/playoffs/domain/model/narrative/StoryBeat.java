package com.ffl.playoffs.domain.model.narrative;

import lombok.Getter;

import java.time.Instant;
import java.util.*;

/**
 * Represents a node in the Story DAG (Directed Acyclic Graph).
 * Each story beat is a narrative moment that can connect to other beats.
 */
@Getter
public class StoryBeat {

    private final UUID id;
    private final UUID leagueId;
    private final StoryBeatType type;
    private final String title;
    private final String description;
    private final NarrativePhase phase;
    private final int tensionImpact;
    private final Instant occurredAt;
    private final Instant createdAt;

    // DAG connections
    private final Set<UUID> parentBeatIds;
    private final Set<UUID> childBeatIds;

    // Context
    private final UUID storyArcId;
    private final Integer weekNumber;
    private final Set<UUID> involvedPlayerIds;
    private final Map<String, Object> metadata;

    // State
    private boolean published;
    private Instant publishedAt;

    private StoryBeat(Builder builder) {
        this.id = builder.id;
        this.leagueId = Objects.requireNonNull(builder.leagueId, "League ID is required");
        this.type = Objects.requireNonNull(builder.type, "Story beat type is required");
        this.title = validateTitle(builder.title);
        this.description = builder.description;
        this.phase = Objects.requireNonNull(builder.phase, "Narrative phase is required");
        this.tensionImpact = builder.tensionImpact != null ? builder.tensionImpact : type.getTensionImpact();
        this.occurredAt = builder.occurredAt != null ? builder.occurredAt : Instant.now();
        this.createdAt = Instant.now();
        this.parentBeatIds = new HashSet<>(builder.parentBeatIds);
        this.childBeatIds = new HashSet<>(builder.childBeatIds);
        this.storyArcId = builder.storyArcId;
        this.weekNumber = builder.weekNumber;
        this.involvedPlayerIds = new HashSet<>(builder.involvedPlayerIds);
        this.metadata = new HashMap<>(builder.metadata);
        this.published = false;
        this.publishedAt = null;
    }

    private String validateTitle(String title) {
        if (title == null || title.isBlank()) {
            throw new IllegalArgumentException("Story beat title cannot be blank");
        }
        return title.trim();
    }

    /**
     * Create a new story beat
     */
    public static Builder builder() {
        return new Builder();
    }

    /**
     * Publish this story beat to players
     */
    public void publish() {
        if (published) {
            throw new IllegalStateException("Story beat is already published");
        }
        this.published = true;
        this.publishedAt = Instant.now();
    }

    /**
     * Add a parent beat connection (this beat follows the parent)
     */
    public void addParent(UUID parentBeatId) {
        Objects.requireNonNull(parentBeatId, "Parent beat ID cannot be null");
        if (parentBeatId.equals(this.id)) {
            throw new IllegalArgumentException("Cannot add self as parent");
        }
        this.parentBeatIds.add(parentBeatId);
    }

    /**
     * Add a child beat connection (the child follows this beat)
     */
    public void addChild(UUID childBeatId) {
        Objects.requireNonNull(childBeatId, "Child beat ID cannot be null");
        if (childBeatId.equals(this.id)) {
            throw new IllegalArgumentException("Cannot add self as child");
        }
        this.childBeatIds.add(childBeatId);
    }

    /**
     * Remove a parent connection
     */
    public void removeParent(UUID parentBeatId) {
        this.parentBeatIds.remove(parentBeatId);
    }

    /**
     * Remove a child connection
     */
    public void removeChild(UUID childBeatId) {
        this.childBeatIds.remove(childBeatId);
    }

    /**
     * Add an involved player
     */
    public void addInvolvedPlayer(UUID playerId) {
        Objects.requireNonNull(playerId, "Player ID cannot be null");
        this.involvedPlayerIds.add(playerId);
    }

    /**
     * Add metadata
     */
    public void addMetadata(String key, Object value) {
        Objects.requireNonNull(key, "Metadata key cannot be null");
        this.metadata.put(key, value);
    }

    /**
     * Check if this is a root beat (no parents)
     */
    public boolean isRoot() {
        return parentBeatIds.isEmpty();
    }

    /**
     * Check if this is a leaf beat (no children)
     */
    public boolean isLeaf() {
        return childBeatIds.isEmpty();
    }

    /**
     * Check if this beat is part of a story arc
     */
    public boolean isPartOfArc() {
        return storyArcId != null;
    }

    /**
     * Check if a player is involved in this beat
     */
    public boolean involvesPlayer(UUID playerId) {
        return involvedPlayerIds.contains(playerId);
    }

    /**
     * Get immutable copy of parent beat IDs
     */
    public Set<UUID> getParentBeatIds() {
        return Collections.unmodifiableSet(parentBeatIds);
    }

    /**
     * Get immutable copy of child beat IDs
     */
    public Set<UUID> getChildBeatIds() {
        return Collections.unmodifiableSet(childBeatIds);
    }

    /**
     * Get immutable copy of involved player IDs
     */
    public Set<UUID> getInvolvedPlayerIds() {
        return Collections.unmodifiableSet(involvedPlayerIds);
    }

    /**
     * Get immutable copy of metadata
     */
    public Map<String, Object> getMetadata() {
        return Collections.unmodifiableMap(metadata);
    }

    public static class Builder {
        private UUID id = UUID.randomUUID();
        private UUID leagueId;
        private StoryBeatType type;
        private String title;
        private String description;
        private NarrativePhase phase;
        private Integer tensionImpact;
        private Instant occurredAt;
        private Set<UUID> parentBeatIds = new HashSet<>();
        private Set<UUID> childBeatIds = new HashSet<>();
        private UUID storyArcId;
        private Integer weekNumber;
        private Set<UUID> involvedPlayerIds = new HashSet<>();
        private Map<String, Object> metadata = new HashMap<>();

        public Builder id(UUID id) {
            this.id = id;
            return this;
        }

        public Builder leagueId(UUID leagueId) {
            this.leagueId = leagueId;
            return this;
        }

        public Builder type(StoryBeatType type) {
            this.type = type;
            return this;
        }

        public Builder title(String title) {
            this.title = title;
            return this;
        }

        public Builder description(String description) {
            this.description = description;
            return this;
        }

        public Builder phase(NarrativePhase phase) {
            this.phase = phase;
            return this;
        }

        public Builder tensionImpact(int tensionImpact) {
            this.tensionImpact = tensionImpact;
            return this;
        }

        public Builder occurredAt(Instant occurredAt) {
            this.occurredAt = occurredAt;
            return this;
        }

        public Builder parentBeatIds(Set<UUID> parentBeatIds) {
            this.parentBeatIds = parentBeatIds != null ? new HashSet<>(parentBeatIds) : new HashSet<>();
            return this;
        }

        public Builder addParentBeatId(UUID parentBeatId) {
            this.parentBeatIds.add(parentBeatId);
            return this;
        }

        public Builder childBeatIds(Set<UUID> childBeatIds) {
            this.childBeatIds = childBeatIds != null ? new HashSet<>(childBeatIds) : new HashSet<>();
            return this;
        }

        public Builder addChildBeatId(UUID childBeatId) {
            this.childBeatIds.add(childBeatId);
            return this;
        }

        public Builder storyArcId(UUID storyArcId) {
            this.storyArcId = storyArcId;
            return this;
        }

        public Builder weekNumber(Integer weekNumber) {
            this.weekNumber = weekNumber;
            return this;
        }

        public Builder involvedPlayerIds(Set<UUID> involvedPlayerIds) {
            this.involvedPlayerIds = involvedPlayerIds != null ? new HashSet<>(involvedPlayerIds) : new HashSet<>();
            return this;
        }

        public Builder addInvolvedPlayerId(UUID playerId) {
            this.involvedPlayerIds.add(playerId);
            return this;
        }

        public Builder metadata(Map<String, Object> metadata) {
            this.metadata = metadata != null ? new HashMap<>(metadata) : new HashMap<>();
            return this;
        }

        public Builder addMetadata(String key, Object value) {
            this.metadata.put(key, value);
            return this;
        }

        public StoryBeat build() {
            return new StoryBeat(this);
        }
    }
}

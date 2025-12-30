package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.ConversationReplaySettings;
import com.ffl.playoffs.domain.model.QualityScore;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

/**
 * Conversation replay aggregate root
 * Represents a replay of a historical conversation with potentially modified settings
 */
public class ConversationReplay {
    private UUID id;
    private UUID originalConversationId;
    private UUID characterId;
    private ConversationReplaySettings settings;
    private List<String> originalResponses;
    private List<String> newResponses;
    private QualityScore originalQuality;
    private QualityScore newQuality;
    private LocalDateTime replayedAt;
    private UUID replayedBy;

    public ConversationReplay() {
        this.id = UUID.randomUUID();
        this.originalResponses = new ArrayList<>();
        this.newResponses = new ArrayList<>();
        this.replayedAt = LocalDateTime.now();
    }

    public ConversationReplay(UUID originalConversationId, UUID characterId, ConversationReplaySettings settings) {
        this();
        this.originalConversationId = originalConversationId;
        this.characterId = characterId;
        this.settings = settings;
    }

    /**
     * Records the original responses from the historical conversation
     * @param responses the original character responses
     */
    public void recordOriginalResponses(List<String> responses) {
        this.originalResponses = responses != null ? new ArrayList<>(responses) : new ArrayList<>();
    }

    /**
     * Records the new responses generated during replay
     * @param responses the newly generated responses
     */
    public void recordNewResponses(List<String> responses) {
        this.newResponses = responses != null ? new ArrayList<>(responses) : new ArrayList<>();
    }

    /**
     * Records quality scores for comparison
     * @param originalQuality quality of original responses
     * @param newQuality quality of new responses
     */
    public void recordQualityScores(QualityScore originalQuality, QualityScore newQuality) {
        this.originalQuality = originalQuality;
        this.newQuality = newQuality;
    }

    /**
     * Calculates the quality delta between original and new responses
     * @return quality score representing improvement or regression
     */
    public QualityScore getQualityDelta() {
        if (originalQuality == null || newQuality == null) {
            return null;
        }
        return newQuality.delta(originalQuality);
    }

    /**
     * Checks if the new responses are an improvement
     * @return true if new quality is higher than original
     */
    public boolean isImprovement() {
        if (originalQuality == null || newQuality == null) {
            return false;
        }
        return newQuality.getOverall() > originalQuality.getOverall();
    }

    /**
     * Gets the number of responses that changed significantly
     * @return count of changed responses
     */
    public int getChangedResponseCount() {
        if (originalResponses.size() != newResponses.size()) {
            return Math.max(originalResponses.size(), newResponses.size());
        }
        int changed = 0;
        for (int i = 0; i < originalResponses.size(); i++) {
            if (!originalResponses.get(i).equals(newResponses.get(i))) {
                changed++;
            }
        }
        return changed;
    }

    // Getters and Setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getOriginalConversationId() {
        return originalConversationId;
    }

    public void setOriginalConversationId(UUID originalConversationId) {
        this.originalConversationId = originalConversationId;
    }

    public UUID getCharacterId() {
        return characterId;
    }

    public void setCharacterId(UUID characterId) {
        this.characterId = characterId;
    }

    public ConversationReplaySettings getSettings() {
        return settings;
    }

    public void setSettings(ConversationReplaySettings settings) {
        this.settings = settings;
    }

    public List<String> getOriginalResponses() {
        return new ArrayList<>(originalResponses);
    }

    public void setOriginalResponses(List<String> originalResponses) {
        this.originalResponses = originalResponses != null ? new ArrayList<>(originalResponses) : new ArrayList<>();
    }

    public List<String> getNewResponses() {
        return new ArrayList<>(newResponses);
    }

    public void setNewResponses(List<String> newResponses) {
        this.newResponses = newResponses != null ? new ArrayList<>(newResponses) : new ArrayList<>();
    }

    public QualityScore getOriginalQuality() {
        return originalQuality;
    }

    public void setOriginalQuality(QualityScore originalQuality) {
        this.originalQuality = originalQuality;
    }

    public QualityScore getNewQuality() {
        return newQuality;
    }

    public void setNewQuality(QualityScore newQuality) {
        this.newQuality = newQuality;
    }

    public LocalDateTime getReplayedAt() {
        return replayedAt;
    }

    public void setReplayedAt(LocalDateTime replayedAt) {
        this.replayedAt = replayedAt;
    }

    public UUID getReplayedBy() {
        return replayedBy;
    }

    public void setReplayedBy(UUID replayedBy) {
        this.replayedBy = replayedBy;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ConversationReplay that = (ConversationReplay) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}

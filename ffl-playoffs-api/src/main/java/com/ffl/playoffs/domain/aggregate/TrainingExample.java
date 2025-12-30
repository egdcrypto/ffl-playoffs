package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.TrainingExampleType;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

/**
 * Training example aggregate root
 * Represents a conversation marked as a training example (positive or negative)
 */
public class TrainingExample {
    private UUID id;
    private UUID conversationId;
    private UUID characterId;
    private TrainingExampleType type;
    private int qualityRating;
    private List<String> tags;
    private List<String> issues;
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private UUID createdBy;

    public TrainingExample() {
        this.id = UUID.randomUUID();
        this.tags = new ArrayList<>();
        this.issues = new ArrayList<>();
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public TrainingExample(UUID conversationId, UUID characterId, TrainingExampleType type, int qualityRating) {
        this();
        this.conversationId = conversationId;
        this.characterId = characterId;
        this.type = type;
        setQualityRating(qualityRating);
    }

    /**
     * Adds a tag to the training example
     * @param tag the tag to add
     */
    public void addTag(String tag) {
        if (tag != null && !tag.isBlank() && !this.tags.contains(tag)) {
            this.tags.add(tag);
            this.updatedAt = LocalDateTime.now();
        }
    }

    /**
     * Removes a tag from the training example
     * @param tag the tag to remove
     */
    public void removeTag(String tag) {
        if (this.tags.remove(tag)) {
            this.updatedAt = LocalDateTime.now();
        }
    }

    /**
     * Adds an issue (for negative examples)
     * @param issue the issue to add
     */
    public void addIssue(String issue) {
        if (issue != null && !issue.isBlank() && !this.issues.contains(issue)) {
            this.issues.add(issue);
            this.updatedAt = LocalDateTime.now();
        }
    }

    /**
     * Changes the example type
     * @param newType the new type
     */
    public void changeType(TrainingExampleType newType) {
        this.type = newType;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Updates the quality rating
     * @param newRating the new rating (1-5)
     */
    public void updateRating(int newRating) {
        setQualityRating(newRating);
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Checks if this is a positive example
     * @return true if positive
     */
    public boolean isPositive() {
        return this.type == TrainingExampleType.POSITIVE;
    }

    /**
     * Checks if this is a high quality example
     * @return true if rating is 4 or higher
     */
    public boolean isHighQuality() {
        return this.qualityRating >= 4;
    }

    private void setQualityRating(int rating) {
        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException("Quality rating must be between 1 and 5");
        }
        this.qualityRating = rating;
    }

    // Getters and Setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getConversationId() {
        return conversationId;
    }

    public void setConversationId(UUID conversationId) {
        this.conversationId = conversationId;
    }

    public UUID getCharacterId() {
        return characterId;
    }

    public void setCharacterId(UUID characterId) {
        this.characterId = characterId;
    }

    public TrainingExampleType getType() {
        return type;
    }

    public void setType(TrainingExampleType type) {
        this.type = type;
    }

    public int getQualityRating() {
        return qualityRating;
    }

    public List<String> getTags() {
        return new ArrayList<>(tags);
    }

    public void setTags(List<String> tags) {
        this.tags = tags != null ? new ArrayList<>(tags) : new ArrayList<>();
    }

    public List<String> getIssues() {
        return new ArrayList<>(issues);
    }

    public void setIssues(List<String> issues) {
        this.issues = issues != null ? new ArrayList<>(issues) : new ArrayList<>();
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
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
        TrainingExample that = (TrainingExample) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}

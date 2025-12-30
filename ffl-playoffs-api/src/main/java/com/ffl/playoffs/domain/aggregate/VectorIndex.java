package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.vectorsearch.DocumentType;
import com.ffl.playoffs.domain.model.vectorsearch.VectorEmbedding;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;

/**
 * Aggregate root for indexed documents in the vector search system.
 * Represents a document with its vector embedding for similarity search.
 */
public class VectorIndex {

    private UUID id;
    private String sourceId;
    private DocumentType documentType;
    private String content;
    private VectorEmbedding embedding;
    private Map<String, Object> metadata;
    private LocalDateTime indexedAt;
    private LocalDateTime updatedAt;
    private boolean active;

    public VectorIndex() {
        this.id = UUID.randomUUID();
        this.indexedAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        this.metadata = new HashMap<>();
        this.active = true;
    }

    public VectorIndex(String sourceId, DocumentType documentType, String content) {
        this();
        this.sourceId = Objects.requireNonNull(sourceId, "sourceId cannot be null");
        this.documentType = Objects.requireNonNull(documentType, "documentType cannot be null");
        this.content = Objects.requireNonNull(content, "content cannot be null");
    }

    /**
     * Factory method to create a new VectorIndex for an NFL player
     */
    public static VectorIndex forNFLPlayer(Long playerId, String playerName, String position, String team) {
        String content = String.format("%s - %s for %s", playerName, position, team);
        VectorIndex index = new VectorIndex(playerId.toString(), DocumentType.NFL_PLAYER, content);
        index.addMetadata("playerName", playerName);
        index.addMetadata("position", position);
        index.addMetadata("team", team);
        return index;
    }

    /**
     * Factory method to create a new VectorIndex for a league
     */
    public static VectorIndex forLeague(UUID leagueId, String leagueName, String description) {
        String content = String.format("%s: %s", leagueName, description != null ? description : "");
        VectorIndex index = new VectorIndex(leagueId.toString(), DocumentType.LEAGUE, content);
        index.addMetadata("leagueName", leagueName);
        return index;
    }

    /**
     * Factory method to create a new VectorIndex for news
     */
    public static VectorIndex forNews(String newsId, String headline, String body) {
        String content = String.format("%s - %s", headline, body);
        VectorIndex index = new VectorIndex(newsId, DocumentType.NEWS, content);
        index.addMetadata("headline", headline);
        return index;
    }

    // Business methods

    /**
     * Update the embedding for this document
     */
    public void updateEmbedding(VectorEmbedding embedding) {
        this.embedding = Objects.requireNonNull(embedding, "embedding cannot be null");
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Update the content and mark for re-indexing
     */
    public void updateContent(String content) {
        this.content = Objects.requireNonNull(content, "content cannot be null");
        this.embedding = null; // Clear embedding to trigger re-indexing
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Add metadata to the index
     */
    public void addMetadata(String key, Object value) {
        this.metadata.put(key, value);
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Mark the index as inactive (soft delete)
     */
    public void deactivate() {
        this.active = false;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Reactivate a deactivated index
     */
    public void activate() {
        this.active = true;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Check if this index needs re-embedding
     */
    public boolean needsEmbedding() {
        return this.embedding == null;
    }

    /**
     * Check if this index is ready for search
     */
    public boolean isSearchable() {
        return this.active && this.embedding != null;
    }

    // Getters and setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getSourceId() {
        return sourceId;
    }

    public void setSourceId(String sourceId) {
        this.sourceId = sourceId;
    }

    public DocumentType getDocumentType() {
        return documentType;
    }

    public void setDocumentType(DocumentType documentType) {
        this.documentType = documentType;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public VectorEmbedding getEmbedding() {
        return embedding;
    }

    public void setEmbedding(VectorEmbedding embedding) {
        this.embedding = embedding;
    }

    public Map<String, Object> getMetadata() {
        return Collections.unmodifiableMap(metadata);
    }

    public void setMetadata(Map<String, Object> metadata) {
        this.metadata = new HashMap<>(metadata);
    }

    public LocalDateTime getIndexedAt() {
        return indexedAt;
    }

    public void setIndexedAt(LocalDateTime indexedAt) {
        this.indexedAt = indexedAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        VectorIndex that = (VectorIndex) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return "VectorIndex{" +
                "id=" + id +
                ", sourceId='" + sourceId + '\'' +
                ", documentType=" + documentType +
                ", active=" + active +
                ", hasEmbedding=" + (embedding != null) +
                '}';
    }
}

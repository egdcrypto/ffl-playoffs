package com.ffl.playoffs.domain.model.vectorsearch;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/**
 * Value object representing a single result from a vector search.
 * Contains the document reference, score, and optional metadata.
 */
public final class VectorSearchResult {

    private final String documentId;
    private final DocumentType documentType;
    private final double score;
    private final String content;
    private final Map<String, Object> metadata;

    private VectorSearchResult(Builder builder) {
        this.documentId = Objects.requireNonNull(builder.documentId, "documentId cannot be null");
        this.documentType = Objects.requireNonNull(builder.documentType, "documentType cannot be null");
        this.score = builder.score;
        this.content = builder.content;
        this.metadata = Collections.unmodifiableMap(new HashMap<>(builder.metadata));
    }

    public static Builder builder() {
        return new Builder();
    }

    public String getDocumentId() {
        return documentId;
    }

    public DocumentType getDocumentType() {
        return documentType;
    }

    public double getScore() {
        return score;
    }

    public String getContent() {
        return content;
    }

    public Map<String, Object> getMetadata() {
        return metadata;
    }

    /**
     * Check if this result is considered highly relevant (score >= 0.8)
     */
    public boolean isHighlyRelevant() {
        return score >= 0.8;
    }

    /**
     * Check if this result meets a minimum relevance threshold
     */
    public boolean meetsThreshold(double threshold) {
        return score >= threshold;
    }

    /**
     * Get a metadata value by key
     */
    @SuppressWarnings("unchecked")
    public <T> T getMetadataValue(String key, Class<T> type) {
        Object value = metadata.get(key);
        if (value == null) {
            return null;
        }
        if (!type.isInstance(value)) {
            throw new ClassCastException("Metadata value for '" + key + "' is not of type " + type.getName());
        }
        return (T) value;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        VectorSearchResult that = (VectorSearchResult) o;
        return Double.compare(that.score, score) == 0 &&
                Objects.equals(documentId, that.documentId) &&
                documentType == that.documentType;
    }

    @Override
    public int hashCode() {
        return Objects.hash(documentId, documentType, score);
    }

    @Override
    public String toString() {
        return "VectorSearchResult{" +
                "documentId='" + documentId + '\'' +
                ", documentType=" + documentType +
                ", score=" + score +
                '}';
    }

    public static class Builder {
        private String documentId;
        private DocumentType documentType;
        private double score;
        private String content;
        private Map<String, Object> metadata = new HashMap<>();

        public Builder documentId(String documentId) {
            this.documentId = documentId;
            return this;
        }

        public Builder documentType(DocumentType documentType) {
            this.documentType = documentType;
            return this;
        }

        public Builder score(double score) {
            if (score < 0.0 || score > 1.0) {
                throw new IllegalArgumentException("Score must be between 0 and 1");
            }
            this.score = score;
            return this;
        }

        public Builder content(String content) {
            this.content = content;
            return this;
        }

        public Builder metadata(String key, Object value) {
            this.metadata.put(key, value);
            return this;
        }

        public Builder metadata(Map<String, Object> metadata) {
            if (metadata != null) {
                this.metadata.putAll(metadata);
            }
            return this;
        }

        public VectorSearchResult build() {
            return new VectorSearchResult(this);
        }
    }
}

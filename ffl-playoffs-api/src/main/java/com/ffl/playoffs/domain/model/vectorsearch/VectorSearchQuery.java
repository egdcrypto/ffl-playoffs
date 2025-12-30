package com.ffl.playoffs.domain.model.vectorsearch;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/**
 * Value object representing a vector search query.
 * Encapsulates search parameters for vector similarity search.
 */
public final class VectorSearchQuery {

    private final String queryText;
    private final VectorEmbedding queryVector;
    private final DocumentType documentType;
    private final int limit;
    private final double minScore;
    private final Map<String, Object> filters;

    private VectorSearchQuery(Builder builder) {
        this.queryText = builder.queryText;
        this.queryVector = builder.queryVector;
        this.documentType = builder.documentType;
        this.limit = builder.limit;
        this.minScore = builder.minScore;
        this.filters = Collections.unmodifiableMap(new HashMap<>(builder.filters));
    }

    public static Builder builder() {
        return new Builder();
    }

    public String getQueryText() {
        return queryText;
    }

    public VectorEmbedding getQueryVector() {
        return queryVector;
    }

    public DocumentType getDocumentType() {
        return documentType;
    }

    public int getLimit() {
        return limit;
    }

    public double getMinScore() {
        return minScore;
    }

    public Map<String, Object> getFilters() {
        return filters;
    }

    public boolean hasQueryVector() {
        return queryVector != null;
    }

    public boolean hasFilters() {
        return !filters.isEmpty();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        VectorSearchQuery that = (VectorSearchQuery) o;
        return limit == that.limit &&
                Double.compare(that.minScore, minScore) == 0 &&
                Objects.equals(queryText, that.queryText) &&
                Objects.equals(queryVector, that.queryVector) &&
                documentType == that.documentType &&
                Objects.equals(filters, that.filters);
    }

    @Override
    public int hashCode() {
        return Objects.hash(queryText, queryVector, documentType, limit, minScore, filters);
    }

    @Override
    public String toString() {
        return "VectorSearchQuery{" +
                "queryText='" + queryText + '\'' +
                ", documentType=" + documentType +
                ", limit=" + limit +
                ", minScore=" + minScore +
                ", filterCount=" + filters.size() +
                '}';
    }

    public static class Builder {
        private String queryText;
        private VectorEmbedding queryVector;
        private DocumentType documentType;
        private int limit = 10;
        private double minScore = 0.0;
        private Map<String, Object> filters = new HashMap<>();

        public Builder queryText(String queryText) {
            this.queryText = queryText;
            return this;
        }

        public Builder queryVector(VectorEmbedding queryVector) {
            this.queryVector = queryVector;
            return this;
        }

        public Builder documentType(DocumentType documentType) {
            this.documentType = documentType;
            return this;
        }

        public Builder limit(int limit) {
            if (limit <= 0) {
                throw new IllegalArgumentException("Limit must be positive");
            }
            this.limit = limit;
            return this;
        }

        public Builder minScore(double minScore) {
            if (minScore < 0.0 || minScore > 1.0) {
                throw new IllegalArgumentException("Min score must be between 0 and 1");
            }
            this.minScore = minScore;
            return this;
        }

        public Builder filter(String key, Object value) {
            this.filters.put(key, value);
            return this;
        }

        public Builder filters(Map<String, Object> filters) {
            if (filters != null) {
                this.filters.putAll(filters);
            }
            return this;
        }

        public VectorSearchQuery build() {
            if (queryText == null && queryVector == null) {
                throw new IllegalStateException("Either queryText or queryVector must be provided");
            }
            return new VectorSearchQuery(this);
        }
    }
}

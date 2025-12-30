package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.vectorsearch.DocumentType;
import com.ffl.playoffs.domain.model.vectorsearch.VectorEmbedding;
import com.ffl.playoffs.domain.model.vectorsearch.VectorSearchQuery;
import com.ffl.playoffs.domain.model.vectorsearch.VectorSearchResult;
import com.ffl.playoffs.domain.port.VectorSearchRepository;
import com.ffl.playoffs.domain.service.EmbeddingService;

import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * Use case for performing vector similarity search.
 * Converts text queries to vectors and searches for similar documents.
 */
public class VectorSearchUseCase {

    private final VectorSearchRepository vectorSearchRepository;
    private final EmbeddingService embeddingService;

    public VectorSearchUseCase(
            VectorSearchRepository vectorSearchRepository,
            EmbeddingService embeddingService) {
        this.vectorSearchRepository = vectorSearchRepository;
        this.embeddingService = embeddingService;
    }

    /**
     * Execute a text-based vector search
     */
    public SearchResponse execute(SearchCommand command) {
        Objects.requireNonNull(command, "command cannot be null");
        Objects.requireNonNull(command.getQueryText(), "queryText cannot be null");

        // Generate embedding for query text
        VectorEmbedding queryEmbedding = embeddingService.embed(command.getQueryText());

        // Build search query
        VectorSearchQuery.Builder queryBuilder = VectorSearchQuery.builder()
                .queryText(command.getQueryText())
                .queryVector(queryEmbedding)
                .limit(command.getLimit())
                .minScore(command.getMinScore());

        if (command.getDocumentType() != null) {
            queryBuilder.documentType(command.getDocumentType());
        }

        if (command.getFilters() != null) {
            queryBuilder.filters(command.getFilters());
        }

        VectorSearchQuery query = queryBuilder.build();

        // Execute search
        List<VectorSearchResult> results = vectorSearchRepository.searchByVector(query);

        return new SearchResponse(
                command.getQueryText(),
                results,
                results.size(),
                command.getLimit()
        );
    }

    /**
     * Search for NFL players by semantic similarity
     */
    public SearchResponse searchNFLPlayers(String queryText, int limit) {
        SearchCommand command = new SearchCommand(queryText);
        command.setDocumentType(DocumentType.NFL_PLAYER);
        command.setLimit(limit);
        return execute(command);
    }

    /**
     * Search for leagues by semantic similarity
     */
    public SearchResponse searchLeagues(String queryText, int limit) {
        SearchCommand command = new SearchCommand(queryText);
        command.setDocumentType(DocumentType.LEAGUE);
        command.setLimit(limit);
        return execute(command);
    }

    /**
     * Search for news by semantic similarity
     */
    public SearchResponse searchNews(String queryText, int limit) {
        SearchCommand command = new SearchCommand(queryText);
        command.setDocumentType(DocumentType.NEWS);
        command.setLimit(limit);
        return execute(command);
    }

    /**
     * Find similar items based on a source document
     */
    public SearchResponse findSimilar(String sourceId, DocumentType documentType, int limit) {
        // Get the embedding of the source document
        var sourceIndex = vectorSearchRepository.findBySourceIdAndType(sourceId, documentType);
        if (sourceIndex.isEmpty() || sourceIndex.get().getEmbedding() == null) {
            return new SearchResponse(sourceId, List.of(), 0, limit);
        }

        VectorSearchQuery query = VectorSearchQuery.builder()
                .queryVector(sourceIndex.get().getEmbedding())
                .documentType(documentType)
                .limit(limit + 1) // +1 to exclude the source document itself
                .minScore(0.5)
                .build();

        List<VectorSearchResult> results = vectorSearchRepository.searchByVector(query);

        // Filter out the source document
        List<VectorSearchResult> filtered = results.stream()
                .filter(r -> !r.getDocumentId().equals(sourceId))
                .limit(limit)
                .toList();

        return new SearchResponse(sourceId, filtered, filtered.size(), limit);
    }

    /**
     * Command object for search operations
     */
    public static class SearchCommand {
        private final String queryText;
        private DocumentType documentType;
        private int limit = 10;
        private double minScore = 0.0;
        private Map<String, Object> filters;

        public SearchCommand(String queryText) {
            this.queryText = Objects.requireNonNull(queryText, "queryText cannot be null");
        }

        public String getQueryText() {
            return queryText;
        }

        public DocumentType getDocumentType() {
            return documentType;
        }

        public void setDocumentType(DocumentType documentType) {
            this.documentType = documentType;
        }

        public int getLimit() {
            return limit;
        }

        public void setLimit(int limit) {
            if (limit <= 0) {
                throw new IllegalArgumentException("Limit must be positive");
            }
            this.limit = limit;
        }

        public double getMinScore() {
            return minScore;
        }

        public void setMinScore(double minScore) {
            if (minScore < 0.0 || minScore > 1.0) {
                throw new IllegalArgumentException("Min score must be between 0 and 1");
            }
            this.minScore = minScore;
        }

        public Map<String, Object> getFilters() {
            return filters;
        }

        public void setFilters(Map<String, Object> filters) {
            this.filters = filters;
        }
    }

    /**
     * Response object for search operations
     */
    public static class SearchResponse {
        private final String query;
        private final List<VectorSearchResult> results;
        private final int totalResults;
        private final int limit;

        public SearchResponse(
                String query,
                List<VectorSearchResult> results,
                int totalResults,
                int limit) {
            this.query = query;
            this.results = results;
            this.totalResults = totalResults;
            this.limit = limit;
        }

        public String getQuery() {
            return query;
        }

        public List<VectorSearchResult> getResults() {
            return results;
        }

        public int getTotalResults() {
            return totalResults;
        }

        public int getLimit() {
            return limit;
        }

        public boolean hasResults() {
            return !results.isEmpty();
        }

        public VectorSearchResult getTopResult() {
            return results.isEmpty() ? null : results.get(0);
        }
    }
}

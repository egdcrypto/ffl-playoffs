package com.ffl.playoffs.domain.service;

import com.ffl.playoffs.domain.model.vectorsearch.VectorEmbedding;

import java.util.List;

/**
 * Domain service interface for generating vector embeddings.
 * Infrastructure layer provides the implementation.
 */
public interface EmbeddingService {

    /**
     * Generate an embedding for a single text
     * @param text the text to embed
     * @return the generated embedding
     */
    VectorEmbedding embed(String text);

    /**
     * Generate embeddings for multiple texts
     * @param texts the texts to embed
     * @return list of embeddings in the same order as input texts
     */
    List<VectorEmbedding> embedBatch(List<String> texts);

    /**
     * Get the dimension size of embeddings produced by this service
     * @return the embedding dimension
     */
    int getEmbeddingDimension();

    /**
     * Check if the service is available and operational
     * @return true if service is ready
     */
    boolean isAvailable();
}

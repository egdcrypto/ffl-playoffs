package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.VectorIndex;
import com.ffl.playoffs.domain.model.vectorsearch.DocumentType;
import com.ffl.playoffs.domain.model.vectorsearch.VectorSearchQuery;
import com.ffl.playoffs.domain.model.vectorsearch.VectorSearchResult;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Port interface for vector search operations.
 * Domain defines the contract, infrastructure implements it.
 * No framework dependencies in this interface.
 */
public interface VectorSearchRepository {

    /**
     * Save a vector index document
     * @param vectorIndex the index to save
     * @return the saved index
     */
    VectorIndex save(VectorIndex vectorIndex);

    /**
     * Save multiple vector index documents
     * @param vectorIndices the indices to save
     * @return the saved indices
     */
    List<VectorIndex> saveAll(List<VectorIndex> vectorIndices);

    /**
     * Find a vector index by ID
     * @param id the unique identifier
     * @return Optional containing the index if found
     */
    Optional<VectorIndex> findById(UUID id);

    /**
     * Find a vector index by source ID and document type
     * @param sourceId the source document ID
     * @param documentType the document type
     * @return Optional containing the index if found
     */
    Optional<VectorIndex> findBySourceIdAndType(String sourceId, DocumentType documentType);

    /**
     * Find all vector indices by document type
     * @param documentType the document type
     * @return list of indices for that type
     */
    List<VectorIndex> findByDocumentType(DocumentType documentType);

    /**
     * Find all active indices that need embedding
     * @return list of indices without embeddings
     */
    List<VectorIndex> findPendingEmbedding();

    /**
     * Perform vector similarity search
     * @param query the search query
     * @return list of search results ordered by relevance
     */
    List<VectorSearchResult> search(VectorSearchQuery query);

    /**
     * Perform vector similarity search with a pre-computed embedding
     * @param query the search query with embedding
     * @return list of search results ordered by relevance
     */
    List<VectorSearchResult> searchByVector(VectorSearchQuery query);

    /**
     * Delete a vector index by ID
     * @param id the index ID to delete
     */
    void deleteById(UUID id);

    /**
     * Delete all indices for a source document
     * @param sourceId the source document ID
     * @param documentType the document type
     */
    void deleteBySourceIdAndType(String sourceId, DocumentType documentType);

    /**
     * Check if an index exists for a source document
     * @param sourceId the source document ID
     * @param documentType the document type
     * @return true if index exists
     */
    boolean existsBySourceIdAndType(String sourceId, DocumentType documentType);

    /**
     * Count all indices by document type
     * @param documentType the document type
     * @return count of indices
     */
    long countByDocumentType(DocumentType documentType);

    /**
     * Count all active indices
     * @return count of active indices
     */
    long countActive();
}

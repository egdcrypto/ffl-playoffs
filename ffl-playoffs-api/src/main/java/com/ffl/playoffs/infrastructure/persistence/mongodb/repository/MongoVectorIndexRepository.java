package com.ffl.playoffs.infrastructure.persistence.mongodb.repository;

import com.ffl.playoffs.infrastructure.persistence.mongodb.document.VectorIndexDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for VectorIndexDocument.
 */
@Repository
public interface MongoVectorIndexRepository extends MongoRepository<VectorIndexDocument, String> {

    /**
     * Find by source ID and document type
     */
    Optional<VectorIndexDocument> findBySourceIdAndDocumentType(String sourceId, String documentType);

    /**
     * Find all by document type
     */
    List<VectorIndexDocument> findByDocumentType(String documentType);

    /**
     * Find all active indices that need embedding (embedding is null)
     */
    @Query("{ 'active': true, 'embedding': null }")
    List<VectorIndexDocument> findByActiveIsTrueAndEmbeddingIsNull();

    /**
     * Find all active indices
     */
    List<VectorIndexDocument> findByActiveIsTrue();

    /**
     * Delete by source ID and document type
     */
    void deleteBySourceIdAndDocumentType(String sourceId, String documentType);

    /**
     * Check existence by source ID and document type
     */
    boolean existsBySourceIdAndDocumentType(String sourceId, String documentType);

    /**
     * Count by document type
     */
    long countByDocumentType(String documentType);

    /**
     * Count all active indices
     */
    long countByActiveIsTrue();

    /**
     * Find by document type and active status
     */
    List<VectorIndexDocument> findByDocumentTypeAndActiveIsTrue(String documentType);
}

package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Spring Data MongoDB repository for WorldDocument.
 * Infrastructure layer - MongoDB specific operations.
 */
@Repository
public interface WorldMongoRepository extends MongoRepository<WorldDocument, String> {

    /**
     * Find all worlds owned by a user
     * @param ownerId the owner's user ID
     * @return list of world documents
     */
    List<WorldDocument> findByOwnerId(String ownerId);

    /**
     * Find worlds by status
     * @param status the world status
     * @return list of world documents
     */
    List<WorldDocument> findByStatus(String status);

    /**
     * Find all public worlds
     * @param isPublic the public flag
     * @return list of public world documents
     */
    List<WorldDocument> findByIsPublic(Boolean isPublic);

    /**
     * Find all deployed worlds
     * @param isDeployed the deployed flag
     * @return list of deployed world documents
     */
    List<WorldDocument> findByIsDeployed(Boolean isDeployed);

    /**
     * Count worlds by owner
     * @param ownerId the owner's user ID
     * @return the count
     */
    long countByOwnerId(String ownerId);
}

package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldResourcesDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for WorldResourcesDocument.
 */
@Repository
public interface WorldResourcesMongoRepository extends MongoRepository<WorldResourcesDocument, String> {

    /**
     * Find world resources by world ID.
     * @param worldId the world ID
     * @return Optional containing the document if found
     */
    Optional<WorldResourcesDocument> findByWorldId(String worldId);

    /**
     * Find all world resources by owner ID.
     * @param ownerId the owner ID
     * @return list of documents
     */
    List<WorldResourcesDocument> findByOwnerId(String ownerId);

    /**
     * Check if world resources exist for a world.
     * @param worldId the world ID
     * @return true if exists
     */
    boolean existsByWorldId(String worldId);

    /**
     * Delete world resources by world ID.
     * @param worldId the world ID
     */
    void deleteByWorldId(String worldId);
}

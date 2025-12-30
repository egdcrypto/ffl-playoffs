package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.EraProfileDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Spring Data MongoDB repository for EraProfileDocument.
 * Infrastructure layer - MongoDB specific operations.
 */
@Repository
public interface EraProfileMongoRepository extends MongoRepository<EraProfileDocument, String> {

    /**
     * Find all era profiles for a specific world
     * @param worldId the world ID
     * @return list of era profile documents
     */
    List<EraProfileDocument> findByWorldId(String worldId);

    /**
     * Find era profiles by status
     * @param status the era status
     * @return list of era profile documents
     */
    List<EraProfileDocument> findByStatus(String status);

    /**
     * Find era profiles created by a specific user
     * @param createdBy the user ID
     * @return list of era profile documents
     */
    List<EraProfileDocument> findByCreatedBy(String createdBy);

    /**
     * Find locked era profiles for a world
     * @param worldId the world ID
     * @param isLocked the lock status
     * @return list of locked era profile documents
     */
    List<EraProfileDocument> findByWorldIdAndIsLocked(String worldId, Boolean isLocked);

    /**
     * Delete all era profiles for a world
     * @param worldId the world ID
     */
    void deleteByWorldId(String worldId);

    /**
     * Count era profiles by world ID
     * @param worldId the world ID
     * @return the count
     */
    long countByWorldId(String worldId);
}

package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.LeagueDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for LeagueDocument
 * Infrastructure layer - MongoDB specific
 */
@Repository
public interface LeagueMongoRepository extends MongoRepository<LeagueDocument, String> {

    /**
     * Find league by unique code
     * @param code the league code
     * @return Optional containing the league document if found
     */
    Optional<LeagueDocument> findByCode(String code);

    /**
     * Find all leagues created by an admin
     * @param ownerId the admin user ID
     * @return list of league documents
     */
    List<LeagueDocument> findByOwnerId(String ownerId);

    /**
     * Check if league code exists
     * @param code the league code
     * @return true if code exists
     */
    boolean existsByCode(String code);

    /**
     * Find leagues by status
     * @param status the league status (e.g., "ACTIVE")
     * @return list of league documents with the given status
     */
    List<LeagueDocument> findByStatus(String status);
}

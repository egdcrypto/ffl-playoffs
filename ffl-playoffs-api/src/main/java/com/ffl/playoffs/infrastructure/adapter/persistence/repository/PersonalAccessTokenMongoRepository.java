package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.PersonalAccessTokenDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for PersonalAccessTokenDocument
 * Infrastructure layer - MongoDB specific
 */
@Repository
public interface PersonalAccessTokenMongoRepository extends MongoRepository<PersonalAccessTokenDocument, String> {

    /**
     * Find PAT by token identifier
     * @param tokenIdentifier the token identifier
     * @return Optional containing the PAT document if found
     */
    Optional<PersonalAccessTokenDocument> findByTokenIdentifier(String tokenIdentifier);

    /**
     * Find all PATs created by a specific user
     * @param createdBy the user ID
     * @return list of PAT documents
     */
    List<PersonalAccessTokenDocument> findByCreatedBy(String createdBy);

    /**
     * Find all active (non-revoked, non-expired) PATs
     * @return list of active PAT documents
     */
    @Query("{ 'revoked': false, $or: [ { 'expiresAt': null }, { 'expiresAt': { $gt: ?0 } } ] }")
    List<PersonalAccessTokenDocument> findAllActive(LocalDateTime now);

    /**
     * Check if PAT exists by name
     * @param name the PAT name
     * @return true if PAT exists
     */
    boolean existsByName(String name);
}

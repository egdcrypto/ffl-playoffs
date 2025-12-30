package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for World documents.
 */
@Repository
public interface WorldMongoRepository extends MongoRepository<WorldDocument, String> {

    /**
     * Find by unique code.
     */
    Optional<WorldDocument> findByCode(String code);

    /**
     * Find all by primary owner ID.
     */
    List<WorldDocument> findByPrimaryOwnerId(String primaryOwnerId);

    /**
     * Find all by status.
     */
    List<WorldDocument> findByStatus(String status);

    /**
     * Find all by visibility.
     */
    List<WorldDocument> findByVisibility(String visibility);

    /**
     * Check if code exists.
     */
    boolean existsByCode(String code);

    /**
     * Count by primary owner ID.
     */
    long countByPrimaryOwnerId(String primaryOwnerId);

    /**
     * Count by status.
     */
    long countByStatus(String status);

    /**
     * Search by name containing (case-insensitive).
     */
    @Query("{ 'name': { $regex: ?0, $options: 'i' } }")
    List<WorldDocument> searchByNameContaining(String namePart);

    /**
     * Find publicly visible worlds (public or invite_only visibility).
     */
    @Query("{ 'visibility': { $in: ['public', 'invite_only'] }, 'status': 'active' }")
    List<WorldDocument> findPubliclyVisibleWorlds();

    /**
     * Find active worlds with member capacity.
     */
    @Query("{ 'status': 'active', 'settings.invitationsEnabled': true, $expr: { $lt: ['$memberCount', '$settings.maxMembers'] } }")
    List<WorldDocument> findWorldsWithMemberCapacity();
}

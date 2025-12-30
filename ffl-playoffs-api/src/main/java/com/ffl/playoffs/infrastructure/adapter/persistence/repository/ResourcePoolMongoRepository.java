package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.ResourcePoolDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for ResourcePoolDocument.
 */
@Repository
public interface ResourcePoolMongoRepository extends MongoRepository<ResourcePoolDocument, String> {

    /**
     * Find resource pool by owner ID.
     * @param ownerId the owner ID
     * @return Optional containing the document if found
     */
    Optional<ResourcePoolDocument> findByOwnerId(String ownerId);

    /**
     * Find all resource pools by subscription tier.
     * @param subscriptionTier the subscription tier
     * @return list of documents
     */
    List<ResourcePoolDocument> findBySubscriptionTier(String subscriptionTier);

    /**
     * Check if resource pool exists for owner.
     * @param ownerId the owner ID
     * @return true if exists
     */
    boolean existsByOwnerId(String ownerId);
}

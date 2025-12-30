package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.BillingPlanDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for BillingPlanDocument
 * Infrastructure layer - MongoDB specific
 */
@Repository
public interface BillingPlanMongoRepository extends MongoRepository<BillingPlanDocument, String> {

    /**
     * Find billing plan by name
     * @param name the plan name
     * @return Optional containing the plan document if found
     */
    Optional<BillingPlanDocument> findByName(String name);

    /**
     * Find all active billing plans
     * @param active the active status
     * @return list of active plan documents
     */
    List<BillingPlanDocument> findByActive(boolean active);

    /**
     * Find all featured billing plans
     * @param featured the featured status
     * @return list of featured plan documents
     */
    List<BillingPlanDocument> findByFeatured(boolean featured);

    /**
     * Check if plan name exists
     * @param name the plan name
     * @return true if name exists
     */
    boolean existsByName(String name);
}

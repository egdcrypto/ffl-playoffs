package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.SubscriptionDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for SubscriptionDocument
 * Infrastructure layer - MongoDB specific
 */
@Repository
public interface SubscriptionMongoRepository extends MongoRepository<SubscriptionDocument, String> {

    /**
     * Find active subscription for an admin
     * @param adminId the admin user ID
     * @param status the subscription status
     * @return Optional containing the subscription document if found
     */
    Optional<SubscriptionDocument> findByAdminIdAndStatus(String adminId, String status);

    /**
     * Find all subscriptions for an admin
     * @param adminId the admin user ID
     * @return list of subscription documents
     */
    List<SubscriptionDocument> findByAdminId(String adminId);

    /**
     * Find subscriptions by status
     * @param status the subscription status
     * @return list of subscription documents
     */
    List<SubscriptionDocument> findByStatus(String status);

    /**
     * Find subscriptions expiring before a given date
     * @param date the expiry cutoff date
     * @param status the subscription status
     * @return list of subscription documents
     */
    List<SubscriptionDocument> findByEndDateBeforeAndStatus(LocalDateTime date, String status);

    /**
     * Find subscriptions by billing plan
     * @param billingPlanId the billing plan ID
     * @return list of subscription documents
     */
    List<SubscriptionDocument> findByBillingPlanId(String billingPlanId);

    /**
     * Check if admin has active subscription
     * @param adminId the admin user ID
     * @param status the subscription status
     * @return true if admin has an active subscription
     */
    boolean existsByAdminIdAndStatus(String adminId, String status);
}

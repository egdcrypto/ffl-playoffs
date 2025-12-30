package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.Subscription;
import com.ffl.playoffs.domain.model.SubscriptionStatus;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for Subscription aggregate
 * Port in hexagonal architecture
 */
public interface SubscriptionRepository {

    /**
     * Find subscription by ID
     * @param id the subscription ID
     * @return Optional containing the subscription if found
     */
    Optional<Subscription> findById(UUID id);

    /**
     * Find active subscription for an admin
     * @param adminId the admin user ID
     * @return Optional containing the active subscription if found
     */
    Optional<Subscription> findActiveByAdminId(UUID adminId);

    /**
     * Find all subscriptions for an admin
     * @param adminId the admin user ID
     * @return list of subscriptions
     */
    List<Subscription> findByAdminId(UUID adminId);

    /**
     * Find all subscriptions by status
     * @param status the subscription status
     * @return list of subscriptions with given status
     */
    List<Subscription> findByStatus(SubscriptionStatus status);

    /**
     * Find subscriptions expiring before a given date
     * @param date the expiry cutoff date
     * @return list of subscriptions expiring before the date
     */
    List<Subscription> findExpiringBefore(LocalDateTime date);

    /**
     * Find subscriptions by billing plan
     * @param billingPlanId the billing plan ID
     * @return list of subscriptions for the plan
     */
    List<Subscription> findByBillingPlanId(UUID billingPlanId);

    /**
     * Check if admin has active subscription
     * @param adminId the admin user ID
     * @return true if admin has an active subscription
     */
    boolean hasActiveSubscription(UUID adminId);

    /**
     * Save a subscription
     * @param subscription the subscription to save
     * @return the saved subscription
     */
    Subscription save(Subscription subscription);

    /**
     * Delete a subscription
     * @param id the subscription ID
     */
    void deleteById(UUID id);
}

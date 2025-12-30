package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.Subscription;
import com.ffl.playoffs.domain.model.SubscriptionStatus;
import com.ffl.playoffs.domain.port.SubscriptionRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Use case for retrieving subscriptions
 * Application layer for read operations
 */
public class GetSubscriptionUseCase {

    private final SubscriptionRepository subscriptionRepository;

    public GetSubscriptionUseCase(SubscriptionRepository subscriptionRepository) {
        this.subscriptionRepository = subscriptionRepository;
    }

    /**
     * Get subscription by ID
     */
    public Optional<Subscription> getById(UUID subscriptionId) {
        return subscriptionRepository.findById(subscriptionId);
    }

    /**
     * Get active subscription for an admin
     */
    public Optional<Subscription> getActiveForAdmin(UUID adminId) {
        return subscriptionRepository.findActiveByAdminId(adminId);
    }

    /**
     * Get all subscriptions for an admin (history)
     */
    public List<Subscription> getAllForAdmin(UUID adminId) {
        return subscriptionRepository.findByAdminId(adminId);
    }

    /**
     * Get subscriptions by status
     */
    public List<Subscription> getByStatus(SubscriptionStatus status) {
        return subscriptionRepository.findByStatus(status);
    }

    /**
     * Get subscriptions expiring within specified days
     */
    public List<Subscription> getExpiringSoon(int days) {
        LocalDateTime cutoff = LocalDateTime.now().plusDays(days);
        return subscriptionRepository.findExpiringBefore(cutoff);
    }

    /**
     * Get all subscriptions for a billing plan
     */
    public List<Subscription> getByPlan(UUID billingPlanId) {
        return subscriptionRepository.findByBillingPlanId(billingPlanId);
    }

    /**
     * Check if admin has valid subscription
     */
    public boolean hasValidSubscription(UUID adminId) {
        return subscriptionRepository.findActiveByAdminId(adminId)
            .map(Subscription::isValid)
            .orElse(false);
    }
}

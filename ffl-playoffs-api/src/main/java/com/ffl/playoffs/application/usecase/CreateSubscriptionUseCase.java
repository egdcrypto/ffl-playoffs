package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.BillingPlan;
import com.ffl.playoffs.domain.aggregate.Subscription;
import com.ffl.playoffs.domain.port.BillingPlanRepository;
import com.ffl.playoffs.domain.port.SubscriptionRepository;

import java.util.UUID;

/**
 * Use case for creating a new subscription for an admin
 * Application layer orchestrates domain logic
 */
public class CreateSubscriptionUseCase {

    private final SubscriptionRepository subscriptionRepository;
    private final BillingPlanRepository billingPlanRepository;

    public CreateSubscriptionUseCase(
            SubscriptionRepository subscriptionRepository,
            BillingPlanRepository billingPlanRepository) {
        this.subscriptionRepository = subscriptionRepository;
        this.billingPlanRepository = billingPlanRepository;
    }

    /**
     * Creates a new subscription for an admin to a billing plan
     *
     * @param command The create subscription command containing all necessary data
     * @return The newly created Subscription entity
     * @throws IllegalArgumentException if billing plan does not exist
     * @throws IllegalStateException if admin already has an active subscription
     */
    public Subscription execute(CreateSubscriptionCommand command) {
        // Validate admin doesn't already have active subscription
        if (subscriptionRepository.hasActiveSubscription(command.getAdminId())) {
            throw new IllegalStateException("Admin already has an active subscription");
        }

        // Fetch billing plan
        BillingPlan billingPlan = billingPlanRepository.findById(command.getBillingPlanId())
            .orElseThrow(() -> new IllegalArgumentException(
                "Billing plan not found: " + command.getBillingPlanId()));

        // Create subscription entity
        Subscription subscription = new Subscription(command.getAdminId(), billingPlan);

        // Set external payment ID if provided
        if (command.getExternalPaymentId() != null) {
            subscription.setExternalPaymentId(command.getExternalPaymentId());
        }

        // Auto-activate free subscriptions
        if (subscription.isFree()) {
            subscription.activateFree();
        }

        // Persist subscription
        return subscriptionRepository.save(subscription);
    }

    /**
     * Command object containing all data needed to create a subscription
     */
    public static class CreateSubscriptionCommand {
        private final UUID adminId;
        private final UUID billingPlanId;
        private String externalPaymentId;

        public CreateSubscriptionCommand(UUID adminId, UUID billingPlanId) {
            this.adminId = adminId;
            this.billingPlanId = billingPlanId;
        }

        public UUID getAdminId() {
            return adminId;
        }

        public UUID getBillingPlanId() {
            return billingPlanId;
        }

        public String getExternalPaymentId() {
            return externalPaymentId;
        }

        public void setExternalPaymentId(String externalPaymentId) {
            this.externalPaymentId = externalPaymentId;
        }
    }
}

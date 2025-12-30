package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.BillingPlan;
import com.ffl.playoffs.domain.aggregate.Subscription;
import com.ffl.playoffs.domain.port.BillingPlanRepository;
import com.ffl.playoffs.domain.port.SubscriptionRepository;

import java.util.UUID;

/**
 * Use case for managing subscription lifecycle operations
 * Handles activation, cancellation, renewal, and plan changes
 */
public class ManageSubscriptionUseCase {

    private final SubscriptionRepository subscriptionRepository;
    private final BillingPlanRepository billingPlanRepository;

    public ManageSubscriptionUseCase(
            SubscriptionRepository subscriptionRepository,
            BillingPlanRepository billingPlanRepository) {
        this.subscriptionRepository = subscriptionRepository;
        this.billingPlanRepository = billingPlanRepository;
    }

    /**
     * Activate a pending subscription after successful payment
     */
    public Subscription activate(ActivateCommand command) {
        Subscription subscription = findSubscription(command.getSubscriptionId());
        subscription.activate();
        return subscriptionRepository.save(subscription);
    }

    /**
     * Cancel an active subscription
     */
    public Subscription cancel(CancelCommand command) {
        Subscription subscription = findSubscription(command.getSubscriptionId());
        subscription.cancel();
        return subscriptionRepository.save(subscription);
    }

    /**
     * Renew an expiring or expired subscription
     */
    public Subscription renew(RenewCommand command) {
        Subscription subscription = findSubscription(command.getSubscriptionId());
        subscription.renew();
        return subscriptionRepository.save(subscription);
    }

    /**
     * Suspend a subscription
     */
    public Subscription suspend(SuspendCommand command) {
        Subscription subscription = findSubscription(command.getSubscriptionId());
        subscription.suspend();
        return subscriptionRepository.save(subscription);
    }

    /**
     * Resume a suspended subscription
     */
    public Subscription resume(ResumeCommand command) {
        Subscription subscription = findSubscription(command.getSubscriptionId());
        subscription.resume();
        return subscriptionRepository.save(subscription);
    }

    /**
     * Mark subscription as past due (payment failed)
     */
    public Subscription markPastDue(MarkPastDueCommand command) {
        Subscription subscription = findSubscription(command.getSubscriptionId());
        subscription.markPastDue();
        return subscriptionRepository.save(subscription);
    }

    /**
     * Change to a different billing plan (upgrade/downgrade)
     */
    public Subscription changePlan(ChangePlanCommand command) {
        Subscription subscription = findSubscription(command.getSubscriptionId());

        BillingPlan newPlan = billingPlanRepository.findById(command.getNewPlanId())
            .orElseThrow(() -> new IllegalArgumentException(
                "Billing plan not found: " + command.getNewPlanId()));

        subscription.changePlan(newPlan);
        return subscriptionRepository.save(subscription);
    }

    private Subscription findSubscription(UUID subscriptionId) {
        return subscriptionRepository.findById(subscriptionId)
            .orElseThrow(() -> new IllegalArgumentException(
                "Subscription not found: " + subscriptionId));
    }

    // Command classes

    public static class ActivateCommand {
        private final UUID subscriptionId;

        public ActivateCommand(UUID subscriptionId) {
            this.subscriptionId = subscriptionId;
        }

        public UUID getSubscriptionId() {
            return subscriptionId;
        }
    }

    public static class CancelCommand {
        private final UUID subscriptionId;

        public CancelCommand(UUID subscriptionId) {
            this.subscriptionId = subscriptionId;
        }

        public UUID getSubscriptionId() {
            return subscriptionId;
        }
    }

    public static class RenewCommand {
        private final UUID subscriptionId;

        public RenewCommand(UUID subscriptionId) {
            this.subscriptionId = subscriptionId;
        }

        public UUID getSubscriptionId() {
            return subscriptionId;
        }
    }

    public static class SuspendCommand {
        private final UUID subscriptionId;

        public SuspendCommand(UUID subscriptionId) {
            this.subscriptionId = subscriptionId;
        }

        public UUID getSubscriptionId() {
            return subscriptionId;
        }
    }

    public static class ResumeCommand {
        private final UUID subscriptionId;

        public ResumeCommand(UUID subscriptionId) {
            this.subscriptionId = subscriptionId;
        }

        public UUID getSubscriptionId() {
            return subscriptionId;
        }
    }

    public static class MarkPastDueCommand {
        private final UUID subscriptionId;

        public MarkPastDueCommand(UUID subscriptionId) {
            this.subscriptionId = subscriptionId;
        }

        public UUID getSubscriptionId() {
            return subscriptionId;
        }
    }

    public static class ChangePlanCommand {
        private final UUID subscriptionId;
        private final UUID newPlanId;

        public ChangePlanCommand(UUID subscriptionId, UUID newPlanId) {
            this.subscriptionId = subscriptionId;
            this.newPlanId = newPlanId;
        }

        public UUID getSubscriptionId() {
            return subscriptionId;
        }

        public UUID getNewPlanId() {
            return newPlanId;
        }
    }
}

package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.BillingCycle;
import com.ffl.playoffs.domain.model.Price;
import com.ffl.playoffs.domain.model.SubscriptionStatus;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Subscription Aggregate Root
 * Represents an admin's subscription to a billing plan.
 * Tracks subscription lifecycle from creation through cancellation/expiry.
 */
public class Subscription {

    private UUID id;
    private UUID adminId;                // The admin who owns this subscription
    private UUID billingPlanId;          // Reference to the billing plan
    private String billingPlanName;      // Denormalized for display

    // Billing details
    private Price currentPrice;
    private BillingCycle billingCycle;

    // Subscription dates
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private LocalDateTime nextBillingDate;
    private LocalDateTime cancelledAt;

    // Status tracking
    private SubscriptionStatus status;
    private int renewalCount;            // Number of times subscription has renewed

    // Payment info (external reference)
    private String externalPaymentId;    // Stripe/PayPal subscription ID

    // Timestamps
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Default constructor
    public Subscription() {
        this.id = UUID.randomUUID();
        this.status = SubscriptionStatus.PENDING;
        this.renewalCount = 0;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Creates a new subscription for an admin to a billing plan
     */
    public Subscription(UUID adminId, BillingPlan billingPlan) {
        this();
        if (adminId == null) {
            throw new IllegalArgumentException("Admin ID is required");
        }
        if (billingPlan == null) {
            throw new IllegalArgumentException("Billing plan is required");
        }
        if (!billingPlan.canSubscribe()) {
            throw new IllegalStateException("Cannot subscribe to inactive plan");
        }

        this.adminId = adminId;
        this.billingPlanId = billingPlan.getId();
        this.billingPlanName = billingPlan.getName();
        this.currentPrice = billingPlan.getPrice();
        this.billingCycle = billingPlan.getBillingCycle();
        this.startDate = LocalDateTime.now();

        calculateEndDate();
    }

    // Business Methods

    /**
     * Activate the subscription after successful payment
     */
    public void activate() {
        if (this.status != SubscriptionStatus.PENDING) {
            throw new IllegalStateException("Can only activate pending subscriptions");
        }
        this.status = SubscriptionStatus.ACTIVE;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Activate a free subscription immediately (no payment required)
     */
    public void activateFree() {
        if (!currentPrice.isFree()) {
            throw new IllegalStateException("Can only use activateFree for free subscriptions");
        }
        this.status = SubscriptionStatus.ACTIVE;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Mark subscription as past due (payment failed)
     */
    public void markPastDue() {
        if (this.status != SubscriptionStatus.ACTIVE) {
            throw new IllegalStateException("Can only mark active subscriptions as past due");
        }
        this.status = SubscriptionStatus.PAST_DUE;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Suspend the subscription
     */
    public void suspend() {
        if (this.status != SubscriptionStatus.ACTIVE && this.status != SubscriptionStatus.PAST_DUE) {
            throw new IllegalStateException("Can only suspend active or past due subscriptions");
        }
        this.status = SubscriptionStatus.SUSPENDED;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Resume a suspended subscription
     */
    public void resume() {
        if (this.status != SubscriptionStatus.SUSPENDED) {
            throw new IllegalStateException("Can only resume suspended subscriptions");
        }
        this.status = SubscriptionStatus.ACTIVE;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Cancel the subscription
     */
    public void cancel() {
        if (!this.status.canCancel()) {
            throw new IllegalStateException("Cannot cancel subscription in current status: " + status);
        }
        this.status = SubscriptionStatus.CANCELLED;
        this.cancelledAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Expire the subscription (called by scheduled job)
     */
    public void expire() {
        if (this.status == SubscriptionStatus.CANCELLED || this.status == SubscriptionStatus.EXPIRED) {
            throw new IllegalStateException("Subscription is already terminated");
        }
        this.status = SubscriptionStatus.EXPIRED;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Renew the subscription for another billing cycle
     */
    public void renew() {
        if (!this.status.canRenew()) {
            throw new IllegalStateException("Cannot renew subscription in current status: " + status);
        }

        this.renewalCount++;
        this.status = SubscriptionStatus.ACTIVE;
        this.startDate = LocalDateTime.now();
        calculateEndDate();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Update to a new billing plan (upgrade/downgrade)
     */
    public void changePlan(BillingPlan newPlan) {
        if (newPlan == null) {
            throw new IllegalArgumentException("New plan is required");
        }
        if (!newPlan.canSubscribe()) {
            throw new IllegalStateException("Cannot change to inactive plan");
        }

        this.billingPlanId = newPlan.getId();
        this.billingPlanName = newPlan.getName();
        this.currentPrice = newPlan.getPrice();
        this.billingCycle = newPlan.getBillingCycle();
        calculateEndDate();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Check if subscription is currently active and valid
     */
    public boolean isValid() {
        return status == SubscriptionStatus.ACTIVE &&
               (endDate == null || endDate.isAfter(LocalDateTime.now()));
    }

    /**
     * Check if subscription is expiring soon (within 7 days)
     */
    public boolean isExpiringSoon() {
        if (endDate == null || !status.isActive()) {
            return false;
        }
        return endDate.isBefore(LocalDateTime.now().plusDays(7));
    }

    /**
     * Check if this is a free subscription
     */
    public boolean isFree() {
        return currentPrice != null && currentPrice.isFree();
    }

    /**
     * Calculate days remaining in subscription
     */
    public long getDaysRemaining() {
        if (endDate == null) {
            return Long.MAX_VALUE; // One-time/lifetime
        }
        LocalDateTime now = LocalDateTime.now();
        if (endDate.isBefore(now)) {
            return 0;
        }
        return java.time.Duration.between(now, endDate).toDays();
    }

    private void calculateEndDate() {
        if (billingCycle == null || billingCycle == BillingCycle.ONE_TIME) {
            this.endDate = null; // No end date for one-time purchases
            this.nextBillingDate = null;
        } else {
            this.endDate = startDate.plusMonths(billingCycle.getMonthsPerCycle());
            this.nextBillingDate = this.endDate;
        }
    }

    // Getters and Setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getAdminId() {
        return adminId;
    }

    public void setAdminId(UUID adminId) {
        this.adminId = adminId;
    }

    public UUID getBillingPlanId() {
        return billingPlanId;
    }

    public void setBillingPlanId(UUID billingPlanId) {
        this.billingPlanId = billingPlanId;
    }

    public String getBillingPlanName() {
        return billingPlanName;
    }

    public void setBillingPlanName(String billingPlanName) {
        this.billingPlanName = billingPlanName;
    }

    public Price getCurrentPrice() {
        return currentPrice;
    }

    public void setCurrentPrice(Price currentPrice) {
        this.currentPrice = currentPrice;
    }

    public BillingCycle getBillingCycle() {
        return billingCycle;
    }

    public void setBillingCycle(BillingCycle billingCycle) {
        this.billingCycle = billingCycle;
    }

    public LocalDateTime getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDateTime startDate) {
        this.startDate = startDate;
    }

    public LocalDateTime getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDateTime endDate) {
        this.endDate = endDate;
    }

    public LocalDateTime getNextBillingDate() {
        return nextBillingDate;
    }

    public void setNextBillingDate(LocalDateTime nextBillingDate) {
        this.nextBillingDate = nextBillingDate;
    }

    public LocalDateTime getCancelledAt() {
        return cancelledAt;
    }

    public void setCancelledAt(LocalDateTime cancelledAt) {
        this.cancelledAt = cancelledAt;
    }

    public SubscriptionStatus getStatus() {
        return status;
    }

    public void setStatus(SubscriptionStatus status) {
        this.status = status;
    }

    public int getRenewalCount() {
        return renewalCount;
    }

    public void setRenewalCount(int renewalCount) {
        this.renewalCount = renewalCount;
    }

    public String getExternalPaymentId() {
        return externalPaymentId;
    }

    public void setExternalPaymentId(String externalPaymentId) {
        this.externalPaymentId = externalPaymentId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}

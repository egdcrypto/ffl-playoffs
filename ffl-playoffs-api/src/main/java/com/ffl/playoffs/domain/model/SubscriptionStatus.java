package com.ffl.playoffs.domain.model;

/**
 * Status of an admin's subscription.
 * Tracks the lifecycle of a subscription from creation to termination.
 */
public enum SubscriptionStatus {

    /**
     * Subscription is pending activation (awaiting payment)
     */
    PENDING("Pending"),

    /**
     * Subscription is active and in good standing
     */
    ACTIVE("Active"),

    /**
     * Subscription is past due (payment failed)
     */
    PAST_DUE("Past Due"),

    /**
     * Subscription is temporarily suspended
     */
    SUSPENDED("Suspended"),

    /**
     * Subscription was cancelled by admin
     */
    CANCELLED("Cancelled"),

    /**
     * Subscription has expired
     */
    EXPIRED("Expired");

    private final String displayName;

    SubscriptionStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    /**
     * Check if subscription is in a valid/active state
     * @return true if subscription grants access
     */
    public boolean isActive() {
        return this == ACTIVE;
    }

    /**
     * Check if subscription can be renewed
     * @return true if subscription can be renewed
     */
    public boolean canRenew() {
        return this == ACTIVE || this == PAST_DUE || this == EXPIRED;
    }

    /**
     * Check if subscription can be cancelled
     * @return true if subscription can be cancelled
     */
    public boolean canCancel() {
        return this == ACTIVE || this == PAST_DUE || this == PENDING;
    }
}

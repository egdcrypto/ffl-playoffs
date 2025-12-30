package com.ffl.playoffs.domain.model;

/**
 * Billing cycle options for subscription plans.
 * Determines how often billing occurs.
 */
public enum BillingCycle {

    /**
     * One-time payment - no recurring billing
     */
    ONE_TIME("One-Time", 0),

    /**
     * Monthly billing cycle
     */
    MONTHLY("Monthly", 1),

    /**
     * Quarterly billing cycle (every 3 months)
     */
    QUARTERLY("Quarterly", 3),

    /**
     * Annual billing cycle
     */
    ANNUAL("Annual", 12);

    private final String displayName;
    private final int monthsPerCycle;

    BillingCycle(String displayName, int monthsPerCycle) {
        this.displayName = displayName;
        this.monthsPerCycle = monthsPerCycle;
    }

    public String getDisplayName() {
        return displayName;
    }

    public int getMonthsPerCycle() {
        return monthsPerCycle;
    }

    /**
     * Check if this is a recurring billing cycle
     * @return true if billing recurs
     */
    public boolean isRecurring() {
        return this != ONE_TIME;
    }
}

package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.BillingCycle;
import com.ffl.playoffs.domain.model.Price;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * BillingPlan Aggregate Root
 * Represents a subscription plan that admins can subscribe to.
 * Plans define pricing, features, and limits for league management.
 */
public class BillingPlan {

    private UUID id;
    private String name;
    private String description;
    private Price price;
    private BillingCycle billingCycle;

    // Plan features and limits
    private Integer maxLeagues;           // Max leagues admin can create
    private Integer maxPlayersPerLeague;  // Max players per league
    private Boolean advancedScoringEnabled;
    private Boolean customBrandingEnabled;
    private Boolean prioritySupportEnabled;

    // Plan status
    private boolean active;
    private boolean featured;             // Show as recommended plan

    // Timestamps
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Default constructor
    public BillingPlan() {
        this.id = UUID.randomUUID();
        this.active = true;
        this.featured = false;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Creates a new billing plan with required fields
     */
    public BillingPlan(String name, Price price, BillingCycle billingCycle) {
        this();
        if (name == null || name.isBlank()) {
            throw new IllegalArgumentException("Plan name is required");
        }
        if (price == null) {
            throw new IllegalArgumentException("Price is required");
        }
        if (billingCycle == null) {
            throw new IllegalArgumentException("Billing cycle is required");
        }

        this.name = name;
        this.price = price;
        this.billingCycle = billingCycle;

        // Set default limits
        this.maxLeagues = 1;
        this.maxPlayersPerLeague = 10;
        this.advancedScoringEnabled = false;
        this.customBrandingEnabled = false;
        this.prioritySupportEnabled = false;
    }

    // Business Methods

    /**
     * Activate the plan to make it available for subscription
     */
    public void activate() {
        this.active = true;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Deactivate the plan (existing subscriptions remain valid)
     */
    public void deactivate() {
        this.active = false;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Mark plan as featured (recommended)
     */
    public void markAsFeatured() {
        this.featured = true;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Remove featured status
     */
    public void removeFeaturedStatus() {
        this.featured = false;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Update plan limits
     */
    public void updateLimits(Integer maxLeagues, Integer maxPlayersPerLeague) {
        if (maxLeagues != null && maxLeagues < 1) {
            throw new IllegalArgumentException("Max leagues must be at least 1");
        }
        if (maxPlayersPerLeague != null && maxPlayersPerLeague < 2) {
            throw new IllegalArgumentException("Max players per league must be at least 2");
        }

        if (maxLeagues != null) this.maxLeagues = maxLeagues;
        if (maxPlayersPerLeague != null) this.maxPlayersPerLeague = maxPlayersPerLeague;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Update plan features
     */
    public void updateFeatures(Boolean advancedScoring, Boolean customBranding, Boolean prioritySupport) {
        if (advancedScoring != null) this.advancedScoringEnabled = advancedScoring;
        if (customBranding != null) this.customBrandingEnabled = customBranding;
        if (prioritySupport != null) this.prioritySupportEnabled = prioritySupport;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Update price (affects new subscriptions only)
     */
    public void updatePrice(Price newPrice) {
        if (newPrice == null) {
            throw new IllegalArgumentException("Price cannot be null");
        }
        this.price = newPrice;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Check if this plan is a free plan
     */
    public boolean isFree() {
        return price != null && price.isFree();
    }

    /**
     * Check if plan can be subscribed to
     */
    public boolean canSubscribe() {
        return active;
    }

    // Factory methods for common plans

    /**
     * Create a free tier plan
     */
    public static BillingPlan freeTier() {
        BillingPlan plan = new BillingPlan("Free", Price.free(), BillingCycle.ONE_TIME);
        plan.setDescription("Perfect for trying out the platform");
        plan.setMaxLeagues(1);
        plan.setMaxPlayersPerLeague(10);
        return plan;
    }

    /**
     * Create a basic monthly plan
     */
    public static BillingPlan basicMonthly(double priceAmount) {
        BillingPlan plan = new BillingPlan("Basic", Price.usd(priceAmount), BillingCycle.MONTHLY);
        plan.setDescription("Great for casual league managers");
        plan.setMaxLeagues(3);
        plan.setMaxPlayersPerLeague(20);
        plan.setAdvancedScoringEnabled(true);
        return plan;
    }

    /**
     * Create a premium monthly plan
     */
    public static BillingPlan premiumMonthly(double priceAmount) {
        BillingPlan plan = new BillingPlan("Premium", Price.usd(priceAmount), BillingCycle.MONTHLY);
        plan.setDescription("Full features for serious league managers");
        plan.setMaxLeagues(10);
        plan.setMaxPlayersPerLeague(50);
        plan.setAdvancedScoringEnabled(true);
        plan.setCustomBrandingEnabled(true);
        plan.setPrioritySupportEnabled(true);
        plan.markAsFeatured();
        return plan;
    }

    // Getters and Setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
        this.updatedAt = LocalDateTime.now();
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
        this.updatedAt = LocalDateTime.now();
    }

    public Price getPrice() {
        return price;
    }

    public void setPrice(Price price) {
        this.price = price;
    }

    public BillingCycle getBillingCycle() {
        return billingCycle;
    }

    public void setBillingCycle(BillingCycle billingCycle) {
        this.billingCycle = billingCycle;
    }

    public Integer getMaxLeagues() {
        return maxLeagues;
    }

    public void setMaxLeagues(Integer maxLeagues) {
        this.maxLeagues = maxLeagues;
    }

    public Integer getMaxPlayersPerLeague() {
        return maxPlayersPerLeague;
    }

    public void setMaxPlayersPerLeague(Integer maxPlayersPerLeague) {
        this.maxPlayersPerLeague = maxPlayersPerLeague;
    }

    public Boolean getAdvancedScoringEnabled() {
        return advancedScoringEnabled;
    }

    public void setAdvancedScoringEnabled(Boolean advancedScoringEnabled) {
        this.advancedScoringEnabled = advancedScoringEnabled;
    }

    public Boolean getCustomBrandingEnabled() {
        return customBrandingEnabled;
    }

    public void setCustomBrandingEnabled(Boolean customBrandingEnabled) {
        this.customBrandingEnabled = customBrandingEnabled;
    }

    public Boolean getPrioritySupportEnabled() {
        return prioritySupportEnabled;
    }

    public void setPrioritySupportEnabled(Boolean prioritySupportEnabled) {
        this.prioritySupportEnabled = prioritySupportEnabled;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public boolean isFeatured() {
        return featured;
    }

    public void setFeatured(boolean featured) {
        this.featured = featured;
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

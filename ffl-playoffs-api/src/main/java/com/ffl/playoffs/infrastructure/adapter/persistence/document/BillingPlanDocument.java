package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

/**
 * MongoDB document for BillingPlan aggregate
 * Infrastructure layer persistence model
 */
@Document(collection = "billing_plans")
public class BillingPlanDocument {

    @Id
    private String id;

    @Indexed(unique = true)
    private String name;

    private String description;

    // Embedded price document
    private PriceDocument price;

    private String billingCycle;  // ONE_TIME, MONTHLY, QUARTERLY, ANNUAL

    // Plan features and limits
    private Integer maxLeagues;
    private Integer maxPlayersPerLeague;
    private Boolean advancedScoringEnabled;
    private Boolean customBrandingEnabled;
    private Boolean prioritySupportEnabled;

    // Plan status
    private boolean active;
    private boolean featured;

    // Metadata
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public BillingPlanDocument() {
    }

    // Getters and Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public PriceDocument getPrice() {
        return price;
    }

    public void setPrice(PriceDocument price) {
        this.price = price;
    }

    public String getBillingCycle() {
        return billingCycle;
    }

    public void setBillingCycle(String billingCycle) {
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

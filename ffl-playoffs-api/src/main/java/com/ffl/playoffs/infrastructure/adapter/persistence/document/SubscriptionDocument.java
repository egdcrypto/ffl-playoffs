package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

/**
 * MongoDB document for Subscription aggregate
 * Infrastructure layer persistence model
 */
@Document(collection = "subscriptions")
public class SubscriptionDocument {

    @Id
    private String id;

    @Indexed
    private String adminId;

    private String billingPlanId;
    private String billingPlanName;

    // Embedded price document
    private PriceDocument currentPrice;

    private String billingCycle;  // ONE_TIME, MONTHLY, QUARTERLY, ANNUAL

    // Subscription dates
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private LocalDateTime nextBillingDate;
    private LocalDateTime cancelledAt;

    // Status tracking
    @Indexed
    private String status;  // PENDING, ACTIVE, PAST_DUE, SUSPENDED, CANCELLED, EXPIRED
    private int renewalCount;

    // Payment info (external reference)
    private String externalPaymentId;

    // Metadata
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public SubscriptionDocument() {
    }

    // Getters and Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getAdminId() {
        return adminId;
    }

    public void setAdminId(String adminId) {
        this.adminId = adminId;
    }

    public String getBillingPlanId() {
        return billingPlanId;
    }

    public void setBillingPlanId(String billingPlanId) {
        this.billingPlanId = billingPlanId;
    }

    public String getBillingPlanName() {
        return billingPlanName;
    }

    public void setBillingPlanName(String billingPlanName) {
        this.billingPlanName = billingPlanName;
    }

    public PriceDocument getCurrentPrice() {
        return currentPrice;
    }

    public void setCurrentPrice(PriceDocument currentPrice) {
        this.currentPrice = currentPrice;
    }

    public String getBillingCycle() {
        return billingCycle;
    }

    public void setBillingCycle(String billingCycle) {
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
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

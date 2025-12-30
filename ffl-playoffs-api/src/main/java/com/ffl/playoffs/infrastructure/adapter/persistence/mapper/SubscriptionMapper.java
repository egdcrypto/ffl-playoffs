package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.aggregate.Subscription;
import com.ffl.playoffs.domain.model.BillingCycle;
import com.ffl.playoffs.domain.model.Price;
import com.ffl.playoffs.domain.model.SubscriptionStatus;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.PriceDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.SubscriptionDocument;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Mapper to convert between Subscription domain model and SubscriptionDocument
 * Infrastructure layer
 */
@Component
public class SubscriptionMapper {

    /**
     * Converts Subscription domain entity to SubscriptionDocument
     * @param subscription the domain entity
     * @return the MongoDB document
     */
    public SubscriptionDocument toDocument(Subscription subscription) {
        if (subscription == null) {
            return null;
        }

        SubscriptionDocument document = new SubscriptionDocument();
        document.setId(subscription.getId() != null ? subscription.getId().toString() : null);
        document.setAdminId(subscription.getAdminId() != null ? subscription.getAdminId().toString() : null);
        document.setBillingPlanId(subscription.getBillingPlanId() != null ? subscription.getBillingPlanId().toString() : null);
        document.setBillingPlanName(subscription.getBillingPlanName());
        document.setCurrentPrice(toPriceDocument(subscription.getCurrentPrice()));
        document.setBillingCycle(subscription.getBillingCycle() != null ? subscription.getBillingCycle().name() : null);
        document.setStartDate(subscription.getStartDate());
        document.setEndDate(subscription.getEndDate());
        document.setNextBillingDate(subscription.getNextBillingDate());
        document.setCancelledAt(subscription.getCancelledAt());
        document.setStatus(subscription.getStatus() != null ? subscription.getStatus().name() : null);
        document.setRenewalCount(subscription.getRenewalCount());
        document.setExternalPaymentId(subscription.getExternalPaymentId());
        document.setCreatedAt(subscription.getCreatedAt());
        document.setUpdatedAt(subscription.getUpdatedAt());

        return document;
    }

    /**
     * Converts SubscriptionDocument to Subscription domain entity
     * @param document the MongoDB document
     * @return the domain entity
     */
    public Subscription toDomain(SubscriptionDocument document) {
        if (document == null) {
            return null;
        }

        Subscription subscription = new Subscription();
        subscription.setId(document.getId() != null ? UUID.fromString(document.getId()) : null);
        subscription.setAdminId(document.getAdminId() != null ? UUID.fromString(document.getAdminId()) : null);
        subscription.setBillingPlanId(document.getBillingPlanId() != null ? UUID.fromString(document.getBillingPlanId()) : null);
        subscription.setBillingPlanName(document.getBillingPlanName());
        subscription.setCurrentPrice(toPriceDomain(document.getCurrentPrice()));
        subscription.setBillingCycle(document.getBillingCycle() != null ? BillingCycle.valueOf(document.getBillingCycle()) : null);
        subscription.setStartDate(document.getStartDate());
        subscription.setEndDate(document.getEndDate());
        subscription.setNextBillingDate(document.getNextBillingDate());
        subscription.setCancelledAt(document.getCancelledAt());
        subscription.setStatus(document.getStatus() != null ? SubscriptionStatus.valueOf(document.getStatus()) : null);
        subscription.setRenewalCount(document.getRenewalCount());
        subscription.setExternalPaymentId(document.getExternalPaymentId());
        subscription.setCreatedAt(document.getCreatedAt());
        subscription.setUpdatedAt(document.getUpdatedAt());

        return subscription;
    }

    private PriceDocument toPriceDocument(Price price) {
        if (price == null) {
            return null;
        }
        return new PriceDocument(price.getAmount(), price.getCurrency());
    }

    private Price toPriceDomain(PriceDocument document) {
        if (document == null) {
            return null;
        }
        return new Price(document.getAmount(), document.getCurrency());
    }
}

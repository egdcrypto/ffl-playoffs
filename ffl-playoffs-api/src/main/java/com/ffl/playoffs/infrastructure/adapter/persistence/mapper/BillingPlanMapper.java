package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.aggregate.BillingPlan;
import com.ffl.playoffs.domain.model.BillingCycle;
import com.ffl.playoffs.domain.model.Price;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.BillingPlanDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.PriceDocument;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Mapper to convert between BillingPlan domain model and BillingPlanDocument
 * Infrastructure layer
 */
@Component
public class BillingPlanMapper {

    /**
     * Converts BillingPlan domain entity to BillingPlanDocument
     * @param billingPlan the domain entity
     * @return the MongoDB document
     */
    public BillingPlanDocument toDocument(BillingPlan billingPlan) {
        if (billingPlan == null) {
            return null;
        }

        BillingPlanDocument document = new BillingPlanDocument();
        document.setId(billingPlan.getId() != null ? billingPlan.getId().toString() : null);
        document.setName(billingPlan.getName());
        document.setDescription(billingPlan.getDescription());
        document.setPrice(toPriceDocument(billingPlan.getPrice()));
        document.setBillingCycle(billingPlan.getBillingCycle() != null ? billingPlan.getBillingCycle().name() : null);
        document.setMaxLeagues(billingPlan.getMaxLeagues());
        document.setMaxPlayersPerLeague(billingPlan.getMaxPlayersPerLeague());
        document.setAdvancedScoringEnabled(billingPlan.getAdvancedScoringEnabled());
        document.setCustomBrandingEnabled(billingPlan.getCustomBrandingEnabled());
        document.setPrioritySupportEnabled(billingPlan.getPrioritySupportEnabled());
        document.setActive(billingPlan.isActive());
        document.setFeatured(billingPlan.isFeatured());
        document.setCreatedAt(billingPlan.getCreatedAt());
        document.setUpdatedAt(billingPlan.getUpdatedAt());

        return document;
    }

    /**
     * Converts BillingPlanDocument to BillingPlan domain entity
     * @param document the MongoDB document
     * @return the domain entity
     */
    public BillingPlan toDomain(BillingPlanDocument document) {
        if (document == null) {
            return null;
        }

        BillingPlan billingPlan = new BillingPlan();
        billingPlan.setId(document.getId() != null ? UUID.fromString(document.getId()) : null);
        billingPlan.setName(document.getName());
        billingPlan.setDescription(document.getDescription());
        billingPlan.setPrice(toPriceDomain(document.getPrice()));
        billingPlan.setBillingCycle(document.getBillingCycle() != null ? BillingCycle.valueOf(document.getBillingCycle()) : null);
        billingPlan.setMaxLeagues(document.getMaxLeagues());
        billingPlan.setMaxPlayersPerLeague(document.getMaxPlayersPerLeague());
        billingPlan.setAdvancedScoringEnabled(document.getAdvancedScoringEnabled());
        billingPlan.setCustomBrandingEnabled(document.getCustomBrandingEnabled());
        billingPlan.setPrioritySupportEnabled(document.getPrioritySupportEnabled());
        billingPlan.setActive(document.isActive());
        billingPlan.setFeatured(document.isFeatured());
        billingPlan.setCreatedAt(document.getCreatedAt());
        billingPlan.setUpdatedAt(document.getUpdatedAt());

        return billingPlan;
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

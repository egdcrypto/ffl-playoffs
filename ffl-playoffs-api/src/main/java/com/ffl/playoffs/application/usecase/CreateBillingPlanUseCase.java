package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.BillingPlan;
import com.ffl.playoffs.domain.model.BillingCycle;
import com.ffl.playoffs.domain.model.Price;
import com.ffl.playoffs.domain.port.BillingPlanRepository;

import java.math.BigDecimal;

/**
 * Use case for creating a new billing plan
 * Application layer orchestrates domain logic
 */
public class CreateBillingPlanUseCase {

    private final BillingPlanRepository billingPlanRepository;

    public CreateBillingPlanUseCase(BillingPlanRepository billingPlanRepository) {
        this.billingPlanRepository = billingPlanRepository;
    }

    /**
     * Creates a new billing plan with the provided configuration
     *
     * @param command The create billing plan command containing all necessary data
     * @return The newly created BillingPlan entity
     * @throws IllegalArgumentException if plan name already exists
     */
    public BillingPlan execute(CreateBillingPlanCommand command) {
        // Validate unique plan name
        if (billingPlanRepository.existsByName(command.getName())) {
            throw new IllegalArgumentException("Billing plan name already exists: " + command.getName());
        }

        // Create price
        Price price = new Price(command.getPriceAmount(), command.getCurrency());

        // Create billing plan entity with validation
        BillingPlan billingPlan = new BillingPlan(
            command.getName(),
            price,
            command.getBillingCycle()
        );

        // Set optional fields
        if (command.getDescription() != null) {
            billingPlan.setDescription(command.getDescription());
        }

        // Set limits
        if (command.getMaxLeagues() != null) {
            billingPlan.setMaxLeagues(command.getMaxLeagues());
        }
        if (command.getMaxPlayersPerLeague() != null) {
            billingPlan.setMaxPlayersPerLeague(command.getMaxPlayersPerLeague());
        }

        // Set features
        if (command.getAdvancedScoringEnabled() != null) {
            billingPlan.setAdvancedScoringEnabled(command.getAdvancedScoringEnabled());
        }
        if (command.getCustomBrandingEnabled() != null) {
            billingPlan.setCustomBrandingEnabled(command.getCustomBrandingEnabled());
        }
        if (command.getPrioritySupportEnabled() != null) {
            billingPlan.setPrioritySupportEnabled(command.getPrioritySupportEnabled());
        }

        // Set featured status
        if (command.isFeatured()) {
            billingPlan.markAsFeatured();
        }

        // Persist billing plan
        return billingPlanRepository.save(billingPlan);
    }

    /**
     * Command object containing all data needed to create a billing plan
     */
    public static class CreateBillingPlanCommand {
        private final String name;
        private final BigDecimal priceAmount;
        private final String currency;
        private final BillingCycle billingCycle;
        private String description;
        private Integer maxLeagues;
        private Integer maxPlayersPerLeague;
        private Boolean advancedScoringEnabled;
        private Boolean customBrandingEnabled;
        private Boolean prioritySupportEnabled;
        private boolean featured;

        public CreateBillingPlanCommand(
                String name,
                BigDecimal priceAmount,
                String currency,
                BillingCycle billingCycle) {
            this.name = name;
            this.priceAmount = priceAmount;
            this.currency = currency;
            this.billingCycle = billingCycle;
        }

        // Getters
        public String getName() {
            return name;
        }

        public BigDecimal getPriceAmount() {
            return priceAmount;
        }

        public String getCurrency() {
            return currency;
        }

        public BillingCycle getBillingCycle() {
            return billingCycle;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
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

        public boolean isFeatured() {
            return featured;
        }

        public void setFeatured(boolean featured) {
            this.featured = featured;
        }
    }
}

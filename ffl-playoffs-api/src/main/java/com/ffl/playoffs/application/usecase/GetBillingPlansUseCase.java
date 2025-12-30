package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.BillingPlan;
import com.ffl.playoffs.domain.port.BillingPlanRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Use case for retrieving billing plans
 * Application layer for read operations
 */
public class GetBillingPlansUseCase {

    private final BillingPlanRepository billingPlanRepository;

    public GetBillingPlansUseCase(BillingPlanRepository billingPlanRepository) {
        this.billingPlanRepository = billingPlanRepository;
    }

    /**
     * Get all active billing plans available for subscription
     */
    public List<BillingPlan> getActivePlans() {
        return billingPlanRepository.findAllActive();
    }

    /**
     * Get all billing plans (including inactive) - admin view
     */
    public List<BillingPlan> getAllPlans() {
        return billingPlanRepository.findAll();
    }

    /**
     * Get featured billing plans
     */
    public List<BillingPlan> getFeaturedPlans() {
        return billingPlanRepository.findFeatured();
    }

    /**
     * Get a specific billing plan by ID
     */
    public Optional<BillingPlan> getPlanById(UUID planId) {
        return billingPlanRepository.findById(planId);
    }

    /**
     * Get a specific billing plan by name
     */
    public Optional<BillingPlan> getPlanByName(String name) {
        return billingPlanRepository.findByName(name);
    }
}

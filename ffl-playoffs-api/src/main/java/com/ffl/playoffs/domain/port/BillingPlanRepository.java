package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.BillingPlan;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for BillingPlan aggregate
 * Port in hexagonal architecture
 */
public interface BillingPlanRepository {

    /**
     * Find billing plan by ID
     * @param id the plan ID
     * @return Optional containing the plan if found
     */
    Optional<BillingPlan> findById(UUID id);

    /**
     * Find billing plan by name
     * @param name the plan name
     * @return Optional containing the plan if found
     */
    Optional<BillingPlan> findByName(String name);

    /**
     * Find all billing plans
     * @return list of all plans
     */
    List<BillingPlan> findAll();

    /**
     * Find all active billing plans
     * @return list of active plans
     */
    List<BillingPlan> findAllActive();

    /**
     * Find featured billing plans
     * @return list of featured plans
     */
    List<BillingPlan> findFeatured();

    /**
     * Check if plan name exists
     * @param name the plan name
     * @return true if name exists
     */
    boolean existsByName(String name);

    /**
     * Save a billing plan
     * @param billingPlan the plan to save
     * @return the saved plan
     */
    BillingPlan save(BillingPlan billingPlan);

    /**
     * Delete a billing plan
     * @param id the plan ID
     */
    void deleteById(UUID id);
}

package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.AlertRule;
import com.ffl.playoffs.domain.model.AlertSeverity;
import com.ffl.playoffs.domain.model.AlertState;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for AlertRule aggregate
 * Port in hexagonal architecture
 */
public interface AlertRuleRepository {

    /**
     * Find alert rule by ID
     * @param id the rule ID
     * @return Optional containing the rule if found
     */
    Optional<AlertRule> findById(UUID id);

    /**
     * Find alert rule by name
     * @param name the rule name
     * @return Optional containing the rule if found
     */
    Optional<AlertRule> findByName(String name);

    /**
     * Find all alert rules
     * @return list of all rules
     */
    List<AlertRule> findAll();

    /**
     * Find enabled alert rules
     * @return list of enabled rules
     */
    List<AlertRule> findEnabled();

    /**
     * Find alert rules by severity
     * @param severity the severity level
     * @return list of rules with the specified severity
     */
    List<AlertRule> findBySeverity(AlertSeverity severity);

    /**
     * Find alert rules by state
     * @param state the alert state
     * @return list of rules in the specified state
     */
    List<AlertRule> findByState(AlertState state);

    /**
     * Find currently firing rules
     * @return list of firing rules
     */
    List<AlertRule> findFiring();

    /**
     * Save an alert rule
     * @param rule the rule to save
     * @return the saved rule
     */
    AlertRule save(AlertRule rule);

    /**
     * Delete an alert rule
     * @param id the rule ID
     */
    void deleteById(UUID id);
}

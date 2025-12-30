package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.loadtest.*;
import lombok.*;

import java.time.Instant;
import java.util.*;

/**
 * Aggregate root representing a load test scenario definition.
 * A scenario defines what to test and how to test it.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LoadTestScenario {
    private UUID id;
    private UUID worldId;
    private String name;
    private String description;
    private LoadTestType testType;
    private LoadTestConfiguration configuration;
    private List<String> tags;
    private boolean enabled;
    private Integer priority;
    private Instant createdAt;
    private Instant updatedAt;
    private String createdBy;

    /**
     * Create a new load test scenario.
     */
    public static LoadTestScenario create(UUID worldId, String name, LoadTestType testType) {
        Objects.requireNonNull(worldId, "World ID is required");
        Objects.requireNonNull(name, "Name is required");

        LoadTestScenario scenario = new LoadTestScenario();
        scenario.id = UUID.randomUUID();
        scenario.worldId = worldId;
        scenario.name = name;
        scenario.testType = testType != null ? testType : LoadTestType.STRESS;
        scenario.configuration = LoadTestConfiguration.create(name, scenario.testType);
        scenario.tags = new ArrayList<>();
        scenario.enabled = true;
        scenario.priority = 5;
        scenario.createdAt = Instant.now();
        scenario.updatedAt = Instant.now();

        return scenario;
    }

    /**
     * Update the scenario configuration.
     */
    public void updateConfiguration(LoadTestConfiguration configuration) {
        this.configuration = Objects.requireNonNull(configuration, "Configuration is required");
        this.updatedAt = Instant.now();
    }

    /**
     * Enable the scenario.
     */
    public void enable() {
        this.enabled = true;
        this.updatedAt = Instant.now();
    }

    /**
     * Disable the scenario.
     */
    public void disable() {
        this.enabled = false;
        this.updatedAt = Instant.now();
    }

    /**
     * Set priority (1-10, where 1 is highest).
     */
    public void setPriority(Integer priority) {
        if (priority != null && (priority < 1 || priority > 10)) {
            throw new IllegalArgumentException("Priority must be between 1 and 10");
        }
        this.priority = priority;
        this.updatedAt = Instant.now();
    }

    /**
     * Add a tag to the scenario.
     */
    public void addTag(String tag) {
        if (tags == null) {
            tags = new ArrayList<>();
        }
        if (!tags.contains(tag)) {
            tags.add(tag);
            this.updatedAt = Instant.now();
        }
    }

    /**
     * Remove a tag from the scenario.
     */
    public void removeTag(String tag) {
        if (tags != null && tags.remove(tag)) {
            this.updatedAt = Instant.now();
        }
    }

    /**
     * Check if scenario has a specific tag.
     */
    public boolean hasTag(String tag) {
        return tags != null && tags.contains(tag);
    }

    /**
     * Update description.
     */
    public void updateDescription(String description) {
        this.description = description;
        this.updatedAt = Instant.now();
    }
}

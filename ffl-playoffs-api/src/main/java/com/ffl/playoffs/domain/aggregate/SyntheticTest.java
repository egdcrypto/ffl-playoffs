package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.SyntheticTestType;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;

/**
 * Synthetic test aggregate root
 * Represents a synthetic monitoring test configuration
 */
public class SyntheticTest {
    private UUID id;
    private String name;
    private SyntheticTestType type;
    private String url;
    private String method;
    private int intervalSeconds;
    private List<String> locations;
    private List<Map<String, Object>> assertions;
    private List<Map<String, Object>> steps; // For browser tests
    private Map<String, String> headers;
    private boolean enabled;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private UUID createdBy;

    // Current state
    private double uptimePercent;
    private double avgResponseTimeMs;
    private LocalDateTime lastRunAt;
    private boolean lastRunSuccess;
    private String lastRunError;

    public SyntheticTest() {
        this.id = UUID.randomUUID();
        this.locations = new ArrayList<>();
        this.assertions = new ArrayList<>();
        this.steps = new ArrayList<>();
        this.headers = new HashMap<>();
        this.enabled = true;
        this.intervalSeconds = 60;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        this.uptimePercent = 100.0;
    }

    public SyntheticTest(String name, SyntheticTestType type, String url) {
        this();
        this.name = name;
        this.type = type;
        this.url = url;
        this.method = "GET";
    }

    /**
     * Adds a location to run the test from
     * @param location the location identifier
     */
    public void addLocation(String location) {
        if (!this.locations.contains(location)) {
            this.locations.add(location);
            this.updatedAt = LocalDateTime.now();
        }
    }

    /**
     * Removes a location
     * @param location the location to remove
     */
    public void removeLocation(String location) {
        if (this.locations.remove(location)) {
            this.updatedAt = LocalDateTime.now();
        }
    }

    /**
     * Adds an assertion
     * @param type assertion type (status_code, response_time_ms, body_contains, etc.)
     * @param operator comparison operator
     * @param value expected value
     */
    public void addAssertion(String type, String operator, Object value) {
        Map<String, Object> assertion = new HashMap<>();
        assertion.put("type", type);
        assertion.put("operator", operator);
        assertion.put("value", value);
        this.assertions.add(assertion);
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Adds a browser test step
     * @param action the action (navigate, click, fill, etc.)
     * @param selector CSS selector or URL
     * @param value optional value for input
     */
    public void addStep(String action, String selector, String value) {
        Map<String, Object> step = new HashMap<>();
        step.put("action", action);
        step.put("selector", selector);
        if (value != null) {
            step.put("value", value);
        }
        this.steps.add(step);
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Records a test run result
     * @param success whether the test passed
     * @param responseTimeMs response time in milliseconds
     * @param error error message if failed
     */
    public void recordResult(boolean success, double responseTimeMs, String error) {
        this.lastRunAt = LocalDateTime.now();
        this.lastRunSuccess = success;
        this.lastRunError = error;

        // Update rolling average (simplified)
        this.avgResponseTimeMs = (this.avgResponseTimeMs + responseTimeMs) / 2;

        // Update uptime (simplified rolling calculation)
        if (success) {
            this.uptimePercent = Math.min(100.0, this.uptimePercent + 0.1);
        } else {
            this.uptimePercent = Math.max(0.0, this.uptimePercent - 1.0);
        }
    }

    /**
     * Enables the test
     */
    public void enable() {
        this.enabled = true;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Disables the test
     */
    public void disable() {
        this.enabled = false;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Checks if the test is a browser-based test
     * @return true if type is BROWSER
     */
    public boolean isBrowserTest() {
        return this.type == SyntheticTestType.BROWSER;
    }

    /**
     * Checks if the test is healthy (uptime above 99%)
     * @return true if healthy
     */
    public boolean isHealthy() {
        return this.uptimePercent >= 99.0;
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
    }

    public SyntheticTestType getType() {
        return type;
    }

    public void setType(SyntheticTestType type) {
        this.type = type;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public int getIntervalSeconds() {
        return intervalSeconds;
    }

    public void setIntervalSeconds(int intervalSeconds) {
        this.intervalSeconds = intervalSeconds;
    }

    public List<String> getLocations() {
        return new ArrayList<>(locations);
    }

    public void setLocations(List<String> locations) {
        this.locations = locations != null ? new ArrayList<>(locations) : new ArrayList<>();
    }

    public List<Map<String, Object>> getAssertions() {
        return new ArrayList<>(assertions);
    }

    public void setAssertions(List<Map<String, Object>> assertions) {
        this.assertions = assertions != null ? new ArrayList<>(assertions) : new ArrayList<>();
    }

    public List<Map<String, Object>> getSteps() {
        return new ArrayList<>(steps);
    }

    public void setSteps(List<Map<String, Object>> steps) {
        this.steps = steps != null ? new ArrayList<>(steps) : new ArrayList<>();
    }

    public Map<String, String> getHeaders() {
        return new HashMap<>(headers);
    }

    public void setHeaders(Map<String, String> headers) {
        this.headers = headers != null ? new HashMap<>(headers) : new HashMap<>();
    }

    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
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

    public UUID getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(UUID createdBy) {
        this.createdBy = createdBy;
    }

    public double getUptimePercent() {
        return uptimePercent;
    }

    public void setUptimePercent(double uptimePercent) {
        this.uptimePercent = uptimePercent;
    }

    public double getAvgResponseTimeMs() {
        return avgResponseTimeMs;
    }

    public void setAvgResponseTimeMs(double avgResponseTimeMs) {
        this.avgResponseTimeMs = avgResponseTimeMs;
    }

    public LocalDateTime getLastRunAt() {
        return lastRunAt;
    }

    public void setLastRunAt(LocalDateTime lastRunAt) {
        this.lastRunAt = lastRunAt;
    }

    public boolean isLastRunSuccess() {
        return lastRunSuccess;
    }

    public void setLastRunSuccess(boolean lastRunSuccess) {
        this.lastRunSuccess = lastRunSuccess;
    }

    public String getLastRunError() {
        return lastRunError;
    }

    public void setLastRunError(String lastRunError) {
        this.lastRunError = lastRunError;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        SyntheticTest that = (SyntheticTest) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}

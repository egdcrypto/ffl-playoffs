package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.WidgetCategory;
import com.ffl.playoffs.domain.model.WidgetPosition;
import com.ffl.playoffs.domain.model.WidgetSize;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;

/**
 * Dashboard widget entity
 * Represents a configurable widget on the admin dashboard
 */
public class DashboardWidget {
    private String id;
    private String name;
    private WidgetCategory category;
    private WidgetPosition position;
    private WidgetSize size;
    private Map<String, Object> config;

    public DashboardWidget() {
        this.id = UUID.randomUUID().toString();
        this.config = new HashMap<>();
    }

    public DashboardWidget(String id, String name, WidgetCategory category) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.position = new WidgetPosition(0, 0);
        this.size = WidgetSize.MEDIUM;
        this.config = new HashMap<>();
    }

    /**
     * Updates the widget position on the dashboard grid
     * @param position new position
     */
    public void updatePosition(WidgetPosition position) {
        Objects.requireNonNull(position, "Position cannot be null");
        this.position = position;
    }

    /**
     * Updates the widget display size
     * @param size new size
     */
    public void updateSize(WidgetSize size) {
        Objects.requireNonNull(size, "Size cannot be null");
        this.size = size;
    }

    /**
     * Updates widget configuration
     * @param config new configuration map
     */
    public void updateConfig(Map<String, Object> config) {
        this.config = config != null ? new HashMap<>(config) : new HashMap<>();
    }

    /**
     * Sets a specific configuration value
     * @param key configuration key
     * @param value configuration value
     */
    public void setConfigValue(String key, Object value) {
        this.config.put(key, value);
    }

    /**
     * Gets a configuration value
     * @param key configuration key
     * @return configuration value or null
     */
    public Object getConfigValue(String key) {
        return this.config.get(key);
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

    public WidgetCategory getCategory() {
        return category;
    }

    public void setCategory(WidgetCategory category) {
        this.category = category;
    }

    public WidgetPosition getPosition() {
        return position;
    }

    public void setPosition(WidgetPosition position) {
        this.position = position;
    }

    public WidgetSize getSize() {
        return size;
    }

    public void setSize(WidgetSize size) {
        this.size = size;
    }

    public Map<String, Object> getConfig() {
        return new HashMap<>(config);
    }

    public void setConfig(Map<String, Object> config) {
        this.config = config != null ? new HashMap<>(config) : new HashMap<>();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        DashboardWidget that = (DashboardWidget) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}

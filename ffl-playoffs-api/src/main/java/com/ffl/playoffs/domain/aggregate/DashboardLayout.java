package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.DashboardPreferences;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;

/**
 * Dashboard layout aggregate root
 * Manages the admin dashboard configuration and widget layout for a user
 */
public class DashboardLayout {
    private UUID id;
    private UUID adminId;
    private List<DashboardWidget> widgets;
    private DashboardPreferences preferences;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public DashboardLayout() {
        this.id = UUID.randomUUID();
        this.widgets = new ArrayList<>();
        this.preferences = DashboardPreferences.defaultPreferences();
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public DashboardLayout(UUID adminId) {
        this();
        this.adminId = adminId;
    }

    /**
     * Adds a widget to the dashboard
     * @param widget the widget to add
     */
    public void addWidget(DashboardWidget widget) {
        Objects.requireNonNull(widget, "Widget cannot be null");
        if (findWidgetById(widget.getId()).isPresent()) {
            throw new IllegalArgumentException("Widget with id " + widget.getId() + " already exists");
        }
        this.widgets.add(widget);
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Removes a widget from the dashboard
     * @param widgetId the widget id to remove
     * @return true if widget was removed
     */
    public boolean removeWidget(String widgetId) {
        boolean removed = this.widgets.removeIf(w -> w.getId().equals(widgetId));
        if (removed) {
            this.updatedAt = LocalDateTime.now();
        }
        return removed;
    }

    /**
     * Finds a widget by its id
     * @param widgetId the widget id
     * @return optional containing the widget if found
     */
    public Optional<DashboardWidget> findWidgetById(String widgetId) {
        return this.widgets.stream()
                .filter(w -> w.getId().equals(widgetId))
                .findFirst();
    }

    /**
     * Updates the entire widget list
     * @param widgets new widget list
     */
    public void updateWidgets(List<DashboardWidget> widgets) {
        this.widgets = widgets != null ? new ArrayList<>(widgets) : new ArrayList<>();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Updates dashboard preferences
     * @param preferences new preferences
     */
    public void updatePreferences(DashboardPreferences preferences) {
        this.preferences = preferences != null ? preferences : DashboardPreferences.defaultPreferences();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Resets the dashboard to default layout
     */
    public void resetToDefault() {
        this.widgets.clear();
        this.preferences = DashboardPreferences.defaultPreferences();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Gets widget count
     * @return number of widgets on dashboard
     */
    public int getWidgetCount() {
        return this.widgets.size();
    }

    // Getters and Setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getAdminId() {
        return adminId;
    }

    public void setAdminId(UUID adminId) {
        this.adminId = adminId;
    }

    public List<DashboardWidget> getWidgets() {
        return new ArrayList<>(widgets);
    }

    public void setWidgets(List<DashboardWidget> widgets) {
        this.widgets = widgets != null ? new ArrayList<>(widgets) : new ArrayList<>();
    }

    public DashboardPreferences getPreferences() {
        return preferences;
    }

    public void setPreferences(DashboardPreferences preferences) {
        this.preferences = preferences;
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

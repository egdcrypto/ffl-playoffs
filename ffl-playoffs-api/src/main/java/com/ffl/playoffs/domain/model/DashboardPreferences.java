package com.ffl.playoffs.domain.model;

import java.util.Objects;

/**
 * Value object representing admin dashboard preferences
 * Stores user-specific dashboard configuration options
 */
public class DashboardPreferences {
    private final String theme;
    private final String defaultTimeRange;
    private final int refreshIntervalSeconds;
    private final boolean compactMode;
    private final boolean showNotifications;

    public DashboardPreferences(String theme, String defaultTimeRange,
                                 int refreshIntervalSeconds, boolean compactMode,
                                 boolean showNotifications) {
        this.theme = theme != null ? theme : "light";
        this.defaultTimeRange = defaultTimeRange != null ? defaultTimeRange : "7d";
        this.refreshIntervalSeconds = refreshIntervalSeconds > 0 ? refreshIntervalSeconds : 60;
        this.compactMode = compactMode;
        this.showNotifications = showNotifications;
    }

    public static DashboardPreferences defaultPreferences() {
        return new DashboardPreferences("light", "7d", 60, false, true);
    }

    public String getTheme() {
        return theme;
    }

    public String getDefaultTimeRange() {
        return defaultTimeRange;
    }

    public int getRefreshIntervalSeconds() {
        return refreshIntervalSeconds;
    }

    public boolean isCompactMode() {
        return compactMode;
    }

    public boolean isShowNotifications() {
        return showNotifications;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        DashboardPreferences that = (DashboardPreferences) o;
        return refreshIntervalSeconds == that.refreshIntervalSeconds &&
               compactMode == that.compactMode &&
               showNotifications == that.showNotifications &&
               Objects.equals(theme, that.theme) &&
               Objects.equals(defaultTimeRange, that.defaultTimeRange);
    }

    @Override
    public int hashCode() {
        return Objects.hash(theme, defaultTimeRange, refreshIntervalSeconds, compactMode, showNotifications);
    }

    @Override
    public String toString() {
        return "DashboardPreferences{" +
               "theme='" + theme + '\'' +
               ", defaultTimeRange='" + defaultTimeRange + '\'' +
               ", refreshIntervalSeconds=" + refreshIntervalSeconds +
               ", compactMode=" + compactMode +
               ", showNotifications=" + showNotifications +
               '}';
    }
}

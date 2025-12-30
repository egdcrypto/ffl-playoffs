package com.ffl.playoffs.domain.model.character;

import java.util.Objects;
import java.util.regex.Pattern;

/**
 * Team Branding value object
 * Contains customizable visual identity for a character's team
 */
public final class TeamBranding {

    private static final Pattern HEX_COLOR_PATTERN = Pattern.compile("^#[0-9A-Fa-f]{6}$");
    private static final int MAX_TEAM_NAME_LENGTH = 50;
    private static final int MAX_SLOGAN_LENGTH = 100;

    private final String teamName;
    private final String teamSlogan;
    private final String avatarUrl;
    private final String primaryColor;
    private final String secondaryColor;

    private TeamBranding(Builder builder) {
        this.teamName = validateTeamName(builder.teamName);
        this.teamSlogan = builder.teamSlogan;
        this.avatarUrl = builder.avatarUrl;
        this.primaryColor = validateColor(builder.primaryColor, "#1E88E5"); // Default blue
        this.secondaryColor = validateColor(builder.secondaryColor, "#FFC107"); // Default gold
    }

    private String validateTeamName(String name) {
        if (name == null || name.isBlank()) {
            throw new IllegalArgumentException("Team name is required");
        }
        String trimmed = name.trim();
        if (trimmed.length() > MAX_TEAM_NAME_LENGTH) {
            throw new IllegalArgumentException(
                    String.format("Team name cannot exceed %d characters", MAX_TEAM_NAME_LENGTH));
        }
        return trimmed;
    }

    private String validateColor(String color, String defaultColor) {
        if (color == null || color.isBlank()) {
            return defaultColor;
        }
        if (!HEX_COLOR_PATTERN.matcher(color).matches()) {
            throw new IllegalArgumentException("Color must be a valid hex color (e.g., #FF5733)");
        }
        return color.toUpperCase();
    }

    /**
     * Create default branding with just a team name
     * @param teamName the team name
     * @return default branding
     */
    public static TeamBranding defaultBranding(String teamName) {
        return builder()
                .teamName(teamName)
                .build();
    }

    /**
     * Create a copy with updated team name
     * @param newName the new team name
     * @return updated branding
     */
    public TeamBranding withTeamName(String newName) {
        return builder()
                .teamName(newName)
                .teamSlogan(this.teamSlogan)
                .avatarUrl(this.avatarUrl)
                .primaryColor(this.primaryColor)
                .secondaryColor(this.secondaryColor)
                .build();
    }

    /**
     * Create a copy with updated slogan
     * @param newSlogan the new slogan
     * @return updated branding
     */
    public TeamBranding withSlogan(String newSlogan) {
        if (newSlogan != null && newSlogan.length() > MAX_SLOGAN_LENGTH) {
            throw new IllegalArgumentException(
                    String.format("Slogan cannot exceed %d characters", MAX_SLOGAN_LENGTH));
        }
        return builder()
                .teamName(this.teamName)
                .teamSlogan(newSlogan)
                .avatarUrl(this.avatarUrl)
                .primaryColor(this.primaryColor)
                .secondaryColor(this.secondaryColor)
                .build();
    }

    /**
     * Create a copy with updated colors
     * @param primary the primary color
     * @param secondary the secondary color
     * @return updated branding
     */
    public TeamBranding withColors(String primary, String secondary) {
        return builder()
                .teamName(this.teamName)
                .teamSlogan(this.teamSlogan)
                .avatarUrl(this.avatarUrl)
                .primaryColor(primary)
                .secondaryColor(secondary)
                .build();
    }

    /**
     * Create a copy with updated avatar
     * @param newAvatarUrl the new avatar URL
     * @return updated branding
     */
    public TeamBranding withAvatar(String newAvatarUrl) {
        return builder()
                .teamName(this.teamName)
                .teamSlogan(this.teamSlogan)
                .avatarUrl(newAvatarUrl)
                .primaryColor(this.primaryColor)
                .secondaryColor(this.secondaryColor)
                .build();
    }

    // Getters

    public String getTeamName() {
        return teamName;
    }

    public String getTeamSlogan() {
        return teamSlogan;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public String getPrimaryColor() {
        return primaryColor;
    }

    public String getSecondaryColor() {
        return secondaryColor;
    }

    // Builder

    public static Builder builder() {
        return new Builder();
    }

    public static class Builder {
        private String teamName;
        private String teamSlogan;
        private String avatarUrl;
        private String primaryColor;
        private String secondaryColor;

        public Builder teamName(String teamName) {
            this.teamName = teamName;
            return this;
        }

        public Builder teamSlogan(String teamSlogan) {
            this.teamSlogan = teamSlogan;
            return this;
        }

        public Builder avatarUrl(String avatarUrl) {
            this.avatarUrl = avatarUrl;
            return this;
        }

        public Builder primaryColor(String primaryColor) {
            this.primaryColor = primaryColor;
            return this;
        }

        public Builder secondaryColor(String secondaryColor) {
            this.secondaryColor = secondaryColor;
            return this;
        }

        public TeamBranding build() {
            return new TeamBranding(this);
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TeamBranding that = (TeamBranding) o;
        return Objects.equals(teamName, that.teamName) &&
                Objects.equals(teamSlogan, that.teamSlogan) &&
                Objects.equals(avatarUrl, that.avatarUrl) &&
                Objects.equals(primaryColor, that.primaryColor) &&
                Objects.equals(secondaryColor, that.secondaryColor);
    }

    @Override
    public int hashCode() {
        return Objects.hash(teamName, teamSlogan, avatarUrl, primaryColor, secondaryColor);
    }

    @Override
    public String toString() {
        return String.format("TeamBranding{name='%s', colors=%s/%s}",
                teamName, primaryColor, secondaryColor);
    }
}

package com.ffl.playoffs.domain.model.world;

import lombok.*;

/**
 * Configurable settings for a World.
 * This is a value object that contains all world configuration options.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WorldSettings {

    /** Maximum number of leagues allowed in this world */
    @Builder.Default
    private Integer maxLeagues = 10;

    /** Maximum number of owners allowed */
    @Builder.Default
    private Integer maxOwners = 5;

    /** Maximum number of members (players) allowed */
    @Builder.Default
    private Integer maxMembers = 100;

    /** Whether new league creation is enabled */
    @Builder.Default
    private Boolean leagueCreationEnabled = true;

    /** Whether member invitations are enabled */
    @Builder.Default
    private Boolean invitationsEnabled = true;

    /** Whether the world's leaderboard is public */
    @Builder.Default
    private Boolean publicLeaderboard = false;

    /** Default scoring template for new leagues */
    private String defaultScoringTemplate;

    /** Default roster configuration template for new leagues */
    private String defaultRosterTemplate;

    /** Custom branding/theme for the world */
    private String theme;

    /** Custom welcome message for new members */
    private String welcomeMessage;

    /**
     * Create default world settings.
     */
    public static WorldSettings defaults() {
        return WorldSettings.builder().build();
    }

    /**
     * Validate the settings.
     */
    public void validate() {
        if (maxLeagues != null && maxLeagues < 1) {
            throw new IllegalArgumentException("Max leagues must be at least 1");
        }
        if (maxOwners != null && maxOwners < 1) {
            throw new IllegalArgumentException("Max owners must be at least 1");
        }
        if (maxMembers != null && maxMembers < 1) {
            throw new IllegalArgumentException("Max members must be at least 1");
        }
    }

    /**
     * Check if more leagues can be added.
     */
    public boolean canAddLeague(int currentCount) {
        return leagueCreationEnabled && (maxLeagues == null || currentCount < maxLeagues);
    }

    /**
     * Check if more owners can be added.
     */
    public boolean canAddOwner(int currentCount) {
        return maxOwners == null || currentCount < maxOwners;
    }

    /**
     * Check if more members can be added.
     */
    public boolean canAddMember(int currentCount) {
        return invitationsEnabled && (maxMembers == null || currentCount < maxMembers);
    }
}

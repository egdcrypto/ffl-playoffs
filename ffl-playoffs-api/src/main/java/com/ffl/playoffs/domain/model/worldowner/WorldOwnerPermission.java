package com.ffl.playoffs.domain.model.worldowner;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.util.EnumSet;
import java.util.Set;

/**
 * Defines specific permissions for world owners.
 */
@Getter
@RequiredArgsConstructor
public enum WorldOwnerPermission {
    // Player management
    VIEW_PLAYERS("view_players", "View Players", "Can view all players in the world"),
    ADD_PLAYERS("add_players", "Add Players", "Can add new players to the world"),
    REMOVE_PLAYERS("remove_players", "Remove Players", "Can remove players from the world"),
    EDIT_PLAYERS("edit_players", "Edit Players", "Can edit player information"),

    // Roster management
    VIEW_ROSTERS("view_rosters", "View Rosters", "Can view all rosters"),
    MANAGE_ROSTERS("manage_rosters", "Manage Rosters", "Can create and modify rosters"),

    // League management
    VIEW_LEAGUES("view_leagues", "View Leagues", "Can view leagues in the world"),
    CREATE_LEAGUES("create_leagues", "Create Leagues", "Can create new leagues"),
    MANAGE_LEAGUES("manage_leagues", "Manage Leagues", "Can manage league settings"),
    DELETE_LEAGUES("delete_leagues", "Delete Leagues", "Can delete leagues"),

    // Settings and analytics
    VIEW_SETTINGS("view_settings", "View Settings", "Can view world settings"),
    MODIFY_SETTINGS("modify_settings", "Modify Settings", "Can change world settings"),
    VIEW_ANALYTICS("view_analytics", "View Analytics", "Can view world analytics"),

    // Owner management
    INVITE_OWNERS("invite_owners", "Invite Owners", "Can invite new owners"),
    MANAGE_OWNERS("manage_owners", "Manage Owners", "Can modify owner roles and permissions"),
    REMOVE_OWNERS("remove_owners", "Remove Owners", "Can remove owners from the world"),

    // Scoring
    VIEW_SCORES("view_scores", "View Scores", "Can view all scores"),
    MANAGE_SCORES("manage_scores", "Manage Scores", "Can modify scoring rules");

    private final String code;
    private final String displayName;
    private final String description;

    /**
     * Get default permissions for a given ownership role.
     */
    public static Set<WorldOwnerPermission> getPermissionsForRole(OwnershipRole role) {
        return switch (role) {
            case MANAGER -> EnumSet.of(
                    VIEW_PLAYERS, ADD_PLAYERS, EDIT_PLAYERS,
                    VIEW_ROSTERS, MANAGE_ROSTERS,
                    VIEW_LEAGUES,
                    VIEW_SETTINGS,
                    VIEW_SCORES
            );
            case CO_OWNER -> EnumSet.of(
                    VIEW_PLAYERS, ADD_PLAYERS, REMOVE_PLAYERS, EDIT_PLAYERS,
                    VIEW_ROSTERS, MANAGE_ROSTERS,
                    VIEW_LEAGUES, CREATE_LEAGUES, MANAGE_LEAGUES,
                    VIEW_SETTINGS, MODIFY_SETTINGS,
                    VIEW_ANALYTICS,
                    INVITE_OWNERS,
                    VIEW_SCORES, MANAGE_SCORES
            );
            case PRIMARY_OWNER -> EnumSet.allOf(WorldOwnerPermission.class);
        };
    }

    public static WorldOwnerPermission fromCode(String code) {
        for (WorldOwnerPermission permission : values()) {
            if (permission.code.equalsIgnoreCase(code)) {
                return permission;
            }
        }
        throw new IllegalArgumentException("Unknown world owner permission code: " + code);
    }
}

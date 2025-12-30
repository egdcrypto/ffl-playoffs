package com.ffl.playoffs.domain.model.accesscontrol;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.util.EnumSet;
import java.util.Set;

/**
 * Defines specific permissions within a World context.
 * Permissions are granular actions that can be performed.
 */
@Getter
@RequiredArgsConstructor
public enum WorldPermission {
    // Read permissions
    VIEW_WORLD("view_world", "View World", "Can view world details"),
    VIEW_MEMBERS("view_members", "View Members", "Can view member list"),
    VIEW_SETTINGS("view_settings", "View Settings", "Can view world settings"),

    // Write permissions
    EDIT_CONTENT("edit_content", "Edit Content", "Can edit world content"),
    CREATE_RESOURCES("create_resources", "Create Resources", "Can create new resources"),
    DELETE_RESOURCES("delete_resources", "Delete Resources", "Can delete resources"),

    // Member management
    INVITE_MEMBERS("invite_members", "Invite Members", "Can invite new members"),
    REMOVE_MEMBERS("remove_members", "Remove Members", "Can remove members"),
    CHANGE_MEMBER_ROLES("change_member_roles", "Change Roles", "Can change member roles"),

    // Admin permissions
    MODIFY_SETTINGS("modify_settings", "Modify Settings", "Can change world settings"),
    MANAGE_ACCESS("manage_access", "Manage Access", "Can manage access control rules"),

    // Owner permissions
    TRANSFER_OWNERSHIP("transfer_ownership", "Transfer Ownership", "Can transfer world ownership"),
    DELETE_WORLD("delete_world", "Delete World", "Can delete the world");

    private final String code;
    private final String displayName;
    private final String description;

    /**
     * Get default permissions for a given role.
     */
    public static Set<WorldPermission> getPermissionsForRole(WorldRole role) {
        return switch (role) {
            case VIEWER -> EnumSet.of(VIEW_WORLD, VIEW_MEMBERS);
            case EDITOR -> EnumSet.of(
                    VIEW_WORLD, VIEW_MEMBERS, VIEW_SETTINGS,
                    EDIT_CONTENT, CREATE_RESOURCES
            );
            case MODERATOR -> EnumSet.of(
                    VIEW_WORLD, VIEW_MEMBERS, VIEW_SETTINGS,
                    EDIT_CONTENT, CREATE_RESOURCES, DELETE_RESOURCES,
                    INVITE_MEMBERS, REMOVE_MEMBERS
            );
            case ADMIN -> EnumSet.of(
                    VIEW_WORLD, VIEW_MEMBERS, VIEW_SETTINGS,
                    EDIT_CONTENT, CREATE_RESOURCES, DELETE_RESOURCES,
                    INVITE_MEMBERS, REMOVE_MEMBERS, CHANGE_MEMBER_ROLES,
                    MODIFY_SETTINGS, MANAGE_ACCESS
            );
            case OWNER -> EnumSet.allOf(WorldPermission.class);
        };
    }

    public static WorldPermission fromCode(String code) {
        for (WorldPermission permission : values()) {
            if (permission.code.equalsIgnoreCase(code)) {
                return permission;
            }
        }
        throw new IllegalArgumentException("Unknown world permission code: " + code);
    }
}

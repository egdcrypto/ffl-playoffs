package com.ffl.playoffs.domain.model.accesscontrol;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("WorldRole Enum Tests")
class WorldRoleTest {

    @Test
    @DisplayName("should have correct hierarchy")
    void shouldHaveCorrectHierarchy() {
        assertThat(WorldRole.OWNER.getLevel()).isGreaterThan(WorldRole.ADMIN.getLevel());
        assertThat(WorldRole.ADMIN.getLevel()).isGreaterThan(WorldRole.MODERATOR.getLevel());
        assertThat(WorldRole.MODERATOR.getLevel()).isGreaterThan(WorldRole.EDITOR.getLevel());
        assertThat(WorldRole.EDITOR.getLevel()).isGreaterThan(WorldRole.VIEWER.getLevel());
    }

    @Test
    @DisplayName("should check permission correctly")
    void shouldCheckPermissionCorrectly() {
        // Owner has all permissions
        assertThat(WorldRole.OWNER.hasPermission(WorldRole.OWNER)).isTrue();
        assertThat(WorldRole.OWNER.hasPermission(WorldRole.VIEWER)).isTrue();

        // Viewer only has viewer permission
        assertThat(WorldRole.VIEWER.hasPermission(WorldRole.VIEWER)).isTrue();
        assertThat(WorldRole.VIEWER.hasPermission(WorldRole.EDITOR)).isFalse();
    }

    @Test
    @DisplayName("should check grant role permission")
    void shouldCheckGrantRolePermission() {
        // Owner can grant all roles except owner
        assertThat(WorldRole.OWNER.canGrantRole(WorldRole.ADMIN)).isTrue();
        assertThat(WorldRole.OWNER.canGrantRole(WorldRole.OWNER)).isFalse();

        // Admin can grant roles lower than admin
        assertThat(WorldRole.ADMIN.canGrantRole(WorldRole.MODERATOR)).isTrue();
        assertThat(WorldRole.ADMIN.canGrantRole(WorldRole.ADMIN)).isFalse();

        // Viewer cannot grant any roles
        assertThat(WorldRole.VIEWER.canGrantRole(WorldRole.VIEWER)).isFalse();
    }

    @Test
    @DisplayName("should check member management permission")
    void shouldCheckMemberManagementPermission() {
        assertThat(WorldRole.OWNER.canManageMembers()).isTrue();
        assertThat(WorldRole.ADMIN.canManageMembers()).isTrue();
        assertThat(WorldRole.MODERATOR.canManageMembers()).isTrue();
        assertThat(WorldRole.EDITOR.canManageMembers()).isFalse();
        assertThat(WorldRole.VIEWER.canManageMembers()).isFalse();
    }

    @Test
    @DisplayName("should check settings modification permission")
    void shouldCheckSettingsModificationPermission() {
        assertThat(WorldRole.OWNER.canModifySettings()).isTrue();
        assertThat(WorldRole.ADMIN.canModifySettings()).isTrue();
        assertThat(WorldRole.MODERATOR.canModifySettings()).isFalse();
    }

    @Test
    @DisplayName("should identify owner role")
    void shouldIdentifyOwnerRole() {
        assertThat(WorldRole.OWNER.isOwner()).isTrue();
        assertThat(WorldRole.ADMIN.isOwner()).isFalse();
    }

    @Test
    @DisplayName("should parse from code")
    void shouldParseFromCode() {
        assertThat(WorldRole.fromCode("owner")).isEqualTo(WorldRole.OWNER);
        assertThat(WorldRole.fromCode("admin")).isEqualTo(WorldRole.ADMIN);
        assertThat(WorldRole.fromCode("VIEWER")).isEqualTo(WorldRole.VIEWER);
    }

    @Test
    @DisplayName("should throw for unknown code")
    void shouldThrowForUnknownCode() {
        assertThatIllegalArgumentException()
                .isThrownBy(() -> WorldRole.fromCode("unknown"))
                .withMessageContaining("Unknown world role code");
    }
}

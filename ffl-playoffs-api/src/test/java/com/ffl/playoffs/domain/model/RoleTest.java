package com.ffl.playoffs.domain.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("Role Enum Tests")
class RoleTest {

    @Test
    @DisplayName("should have exactly three roles")
    void shouldHaveExactlyThreeRoles() {
        assertThat(Role.values()).hasSize(3);
    }

    @Test
    @DisplayName("should have PLAYER role")
    void shouldHavePlayerRole() {
        assertThat(Role.PLAYER).isNotNull();
        assertThat(Role.valueOf("PLAYER")).isEqualTo(Role.PLAYER);
    }

    @Test
    @DisplayName("should have ADMIN role")
    void shouldHaveAdminRole() {
        assertThat(Role.ADMIN).isNotNull();
        assertThat(Role.valueOf("ADMIN")).isEqualTo(Role.ADMIN);
    }

    @Test
    @DisplayName("should have SUPER_ADMIN role")
    void shouldHaveSuperAdminRole() {
        assertThat(Role.SUPER_ADMIN).isNotNull();
        assertThat(Role.valueOf("SUPER_ADMIN")).isEqualTo(Role.SUPER_ADMIN);
    }

    @Test
    @DisplayName("roles should maintain consistent ordering")
    void rolesShouldMaintainConsistentOrdering() {
        Role[] roles = Role.values();
        assertThat(roles[0]).isEqualTo(Role.PLAYER);
        assertThat(roles[1]).isEqualTo(Role.ADMIN);
        assertThat(roles[2]).isEqualTo(Role.SUPER_ADMIN);
    }
}

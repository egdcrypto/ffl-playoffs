package com.ffl.playoffs.domain.model.worldowner;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("OwnershipRole Enum Tests")
class OwnershipRoleTest {

    @Test
    @DisplayName("should have exactly three roles")
    void shouldHaveExactlyThreeRoles() {
        assertThat(OwnershipRole.values()).hasSize(3);
    }

    @Test
    @DisplayName("roles should maintain correct ordering by level")
    void rolesShouldMaintainCorrectOrderingByLevel() {
        assertThat(OwnershipRole.MANAGER.getLevel()).isEqualTo(1);
        assertThat(OwnershipRole.CO_OWNER.getLevel()).isEqualTo(2);
        assertThat(OwnershipRole.PRIMARY_OWNER.getLevel()).isEqualTo(3);
    }

    @Test
    @DisplayName("should have correct codes")
    void shouldHaveCorrectCodes() {
        assertThat(OwnershipRole.MANAGER.getCode()).isEqualTo("manager");
        assertThat(OwnershipRole.CO_OWNER.getCode()).isEqualTo("co_owner");
        assertThat(OwnershipRole.PRIMARY_OWNER.getCode()).isEqualTo("primary_owner");
    }

    @Test
    @DisplayName("should resolve from code")
    void shouldResolveFromCode() {
        assertThat(OwnershipRole.fromCode("manager")).isEqualTo(OwnershipRole.MANAGER);
        assertThat(OwnershipRole.fromCode("co_owner")).isEqualTo(OwnershipRole.CO_OWNER);
        assertThat(OwnershipRole.fromCode("primary_owner")).isEqualTo(OwnershipRole.PRIMARY_OWNER);
    }

    @Test
    @DisplayName("should resolve from code case insensitively")
    void shouldResolveFromCodeCaseInsensitively() {
        assertThat(OwnershipRole.fromCode("MANAGER")).isEqualTo(OwnershipRole.MANAGER);
        assertThat(OwnershipRole.fromCode("Co_Owner")).isEqualTo(OwnershipRole.CO_OWNER);
    }

    @Test
    @DisplayName("should throw exception for unknown code")
    void shouldThrowExceptionForUnknownCode() {
        assertThatThrownBy(() -> OwnershipRole.fromCode("unknown"))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Unknown ownership role code");
    }

    @Nested
    @DisplayName("hasPermission tests")
    class HasPermissionTests {

        @Test
        @DisplayName("PRIMARY_OWNER should have permission for all roles")
        void primaryOwnerShouldHavePermissionForAllRoles() {
            assertThat(OwnershipRole.PRIMARY_OWNER.hasPermission(OwnershipRole.MANAGER)).isTrue();
            assertThat(OwnershipRole.PRIMARY_OWNER.hasPermission(OwnershipRole.CO_OWNER)).isTrue();
            assertThat(OwnershipRole.PRIMARY_OWNER.hasPermission(OwnershipRole.PRIMARY_OWNER)).isTrue();
        }

        @Test
        @DisplayName("CO_OWNER should have permission for MANAGER and CO_OWNER")
        void coOwnerShouldHavePermissionForManagerAndCoOwner() {
            assertThat(OwnershipRole.CO_OWNER.hasPermission(OwnershipRole.MANAGER)).isTrue();
            assertThat(OwnershipRole.CO_OWNER.hasPermission(OwnershipRole.CO_OWNER)).isTrue();
            assertThat(OwnershipRole.CO_OWNER.hasPermission(OwnershipRole.PRIMARY_OWNER)).isFalse();
        }

        @Test
        @DisplayName("MANAGER should only have permission for MANAGER")
        void managerShouldOnlyHavePermissionForManager() {
            assertThat(OwnershipRole.MANAGER.hasPermission(OwnershipRole.MANAGER)).isTrue();
            assertThat(OwnershipRole.MANAGER.hasPermission(OwnershipRole.CO_OWNER)).isFalse();
            assertThat(OwnershipRole.MANAGER.hasPermission(OwnershipRole.PRIMARY_OWNER)).isFalse();
        }
    }

    @Nested
    @DisplayName("canGrantRole tests")
    class CanGrantRoleTests {

        @Test
        @DisplayName("PRIMARY_OWNER can grant MANAGER and CO_OWNER")
        void primaryOwnerCanGrantManagerAndCoOwner() {
            assertThat(OwnershipRole.PRIMARY_OWNER.canGrantRole(OwnershipRole.MANAGER)).isTrue();
            assertThat(OwnershipRole.PRIMARY_OWNER.canGrantRole(OwnershipRole.CO_OWNER)).isTrue();
        }

        @Test
        @DisplayName("PRIMARY_OWNER cannot grant PRIMARY_OWNER")
        void primaryOwnerCannotGrantPrimaryOwner() {
            assertThat(OwnershipRole.PRIMARY_OWNER.canGrantRole(OwnershipRole.PRIMARY_OWNER)).isFalse();
        }

        @Test
        @DisplayName("CO_OWNER cannot grant any role")
        void coOwnerCannotGrantAnyRole() {
            assertThat(OwnershipRole.CO_OWNER.canGrantRole(OwnershipRole.MANAGER)).isFalse();
            assertThat(OwnershipRole.CO_OWNER.canGrantRole(OwnershipRole.CO_OWNER)).isFalse();
        }

        @Test
        @DisplayName("MANAGER cannot grant any role")
        void managerCannotGrantAnyRole() {
            assertThat(OwnershipRole.MANAGER.canGrantRole(OwnershipRole.MANAGER)).isFalse();
            assertThat(OwnershipRole.MANAGER.canGrantRole(OwnershipRole.CO_OWNER)).isFalse();
        }
    }

    @Nested
    @DisplayName("capability tests")
    class CapabilityTests {

        @Test
        @DisplayName("only PRIMARY_OWNER can manage owners")
        void onlyPrimaryOwnerCanManageOwners() {
            assertThat(OwnershipRole.PRIMARY_OWNER.canManageOwners()).isTrue();
            assertThat(OwnershipRole.CO_OWNER.canManageOwners()).isFalse();
            assertThat(OwnershipRole.MANAGER.canManageOwners()).isFalse();
        }

        @Test
        @DisplayName("CO_OWNER and PRIMARY_OWNER can manage settings")
        void coOwnerAndPrimaryOwnerCanManageSettings() {
            assertThat(OwnershipRole.PRIMARY_OWNER.canManageSettings()).isTrue();
            assertThat(OwnershipRole.CO_OWNER.canManageSettings()).isTrue();
            assertThat(OwnershipRole.MANAGER.canManageSettings()).isFalse();
        }

        @Test
        @DisplayName("all roles can manage players")
        void allRolesCanManagePlayers() {
            assertThat(OwnershipRole.PRIMARY_OWNER.canManagePlayers()).isTrue();
            assertThat(OwnershipRole.CO_OWNER.canManagePlayers()).isTrue();
            assertThat(OwnershipRole.MANAGER.canManagePlayers()).isTrue();
        }

        @Test
        @DisplayName("isPrimaryOwner should return correct value")
        void isPrimaryOwnerShouldReturnCorrectValue() {
            assertThat(OwnershipRole.PRIMARY_OWNER.isPrimaryOwner()).isTrue();
            assertThat(OwnershipRole.CO_OWNER.isPrimaryOwner()).isFalse();
            assertThat(OwnershipRole.MANAGER.isPrimaryOwner()).isFalse();
        }
    }
}

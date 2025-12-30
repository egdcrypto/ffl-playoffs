package com.ffl.playoffs.domain.model.worldowner;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("WorldOwnerPlayer Tests")
class WorldOwnerPlayerTest {

    private UUID userId;
    private UUID worldId;
    private UUID grantedBy;

    @BeforeEach
    void setUp() {
        userId = UUID.randomUUID();
        worldId = UUID.randomUUID();
        grantedBy = UUID.randomUUID();
    }

    @Nested
    @DisplayName("createInvitation tests")
    class CreateInvitationTests {

        @Test
        @DisplayName("should create invitation with correct properties")
        void shouldCreateInvitationWithCorrectProperties() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.CO_OWNER, grantedBy);

            assertThat(player.getId()).isNotNull();
            assertThat(player.getUserId()).isEqualTo(userId);
            assertThat(player.getWorldId()).isEqualTo(worldId);
            assertThat(player.getRole()).isEqualTo(OwnershipRole.CO_OWNER);
            assertThat(player.getStatus()).isEqualTo(OwnershipStatus.INVITED);
            assertThat(player.getGrantedBy()).isEqualTo(grantedBy);
            assertThat(player.getInvitationToken()).isNotNull();
            assertThat(player.getInvitationExpiresAt()).isAfter(Instant.now());
        }

        @Test
        @DisplayName("should set correct permissions for role")
        void shouldSetCorrectPermissionsForRole() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.MANAGER, grantedBy);

            assertThat(player.getPermissions())
                    .containsAll(WorldOwnerPermission.getPermissionsForRole(OwnershipRole.MANAGER));
        }

        @Test
        @DisplayName("should throw exception when inviting as PRIMARY_OWNER")
        void shouldThrowExceptionWhenInvitingAsPrimaryOwner() {
            assertThatThrownBy(() -> WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.PRIMARY_OWNER, grantedBy))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Cannot invite as PRIMARY_OWNER");
        }

        @Test
        @DisplayName("should throw exception for null userId")
        void shouldThrowExceptionForNullUserId() {
            assertThatThrownBy(() -> WorldOwnerPlayer.createInvitation(null, worldId, OwnershipRole.CO_OWNER, grantedBy))
                    .isInstanceOf(NullPointerException.class);
        }

        @Test
        @DisplayName("should throw exception for null worldId")
        void shouldThrowExceptionForNullWorldId() {
            assertThatThrownBy(() -> WorldOwnerPlayer.createInvitation(userId, null, OwnershipRole.CO_OWNER, grantedBy))
                    .isInstanceOf(NullPointerException.class);
        }
    }

    @Nested
    @DisplayName("createPrimaryOwner tests")
    class CreatePrimaryOwnerTests {

        @Test
        @DisplayName("should create primary owner with correct properties")
        void shouldCreatePrimaryOwnerWithCorrectProperties() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createPrimaryOwner(userId, worldId);

            assertThat(player.getId()).isNotNull();
            assertThat(player.getUserId()).isEqualTo(userId);
            assertThat(player.getWorldId()).isEqualTo(worldId);
            assertThat(player.getRole()).isEqualTo(OwnershipRole.PRIMARY_OWNER);
            assertThat(player.getStatus()).isEqualTo(OwnershipStatus.ACTIVE);
            assertThat(player.getGrantedBy()).isEqualTo(userId);
            assertThat(player.getJoinedAt()).isNotNull();
        }

        @Test
        @DisplayName("should have all PRIMARY_OWNER permissions")
        void shouldHaveAllPrimaryOwnerPermissions() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createPrimaryOwner(userId, worldId);

            assertThat(player.getPermissions())
                    .containsAll(WorldOwnerPermission.getPermissionsForRole(OwnershipRole.PRIMARY_OWNER));
        }
    }

    @Nested
    @DisplayName("acceptInvitation tests")
    class AcceptInvitationTests {

        @Test
        @DisplayName("should accept invitation with valid token")
        void shouldAcceptInvitationWithValidToken() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.CO_OWNER, grantedBy);
            String token = player.getInvitationToken();

            player.acceptInvitation(token);

            assertThat(player.getStatus()).isEqualTo(OwnershipStatus.ACTIVE);
            assertThat(player.getJoinedAt()).isNotNull();
            assertThat(player.getInvitationToken()).isNull();
            assertThat(player.getInvitationExpiresAt()).isNull();
        }

        @Test
        @DisplayName("should throw exception for invalid token")
        void shouldThrowExceptionForInvalidToken() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.CO_OWNER, grantedBy);

            assertThatThrownBy(() -> player.acceptInvitation("wrong-token"))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Invalid invitation token");
        }

        @Test
        @DisplayName("should throw exception when not in INVITED status")
        void shouldThrowExceptionWhenNotInInvitedStatus() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createPrimaryOwner(userId, worldId);

            assertThatThrownBy(() -> player.acceptInvitation("token"))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot accept invitation in status");
        }

        @Test
        @DisplayName("should throw exception for expired invitation")
        void shouldThrowExceptionForExpiredInvitation() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.CO_OWNER, grantedBy);
            String token = player.getInvitationToken();
            // Set expiration to the past
            player.setInvitationExpiresAt(Instant.now().minus(1, ChronoUnit.DAYS));

            assertThatThrownBy(() -> player.acceptInvitation(token))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Invitation has expired");
        }
    }

    @Nested
    @DisplayName("declineInvitation tests")
    class DeclineInvitationTests {

        @Test
        @DisplayName("should decline invitation")
        void shouldDeclineInvitation() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.CO_OWNER, grantedBy);

            player.declineInvitation();

            assertThat(player.getStatus()).isEqualTo(OwnershipStatus.DECLINED);
            assertThat(player.getInvitationToken()).isNull();
        }

        @Test
        @DisplayName("should throw exception when not in INVITED status")
        void shouldThrowExceptionWhenNotInInvitedStatus() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createPrimaryOwner(userId, worldId);

            assertThatThrownBy(() -> player.declineInvitation())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot decline invitation in status");
        }
    }

    @Nested
    @DisplayName("deactivate tests")
    class DeactivateTests {

        @Test
        @DisplayName("should deactivate active owner")
        void shouldDeactivateActiveOwner() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.CO_OWNER, grantedBy);
            player.acceptInvitation(player.getInvitationToken());

            player.deactivate();

            assertThat(player.getStatus()).isEqualTo(OwnershipStatus.INACTIVE);
        }

        @Test
        @DisplayName("should throw exception when not in ACTIVE status")
        void shouldThrowExceptionWhenNotInActiveStatus() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.CO_OWNER, grantedBy);

            assertThatThrownBy(() -> player.deactivate())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot deactivate owner in status");
        }

        @Test
        @DisplayName("should throw exception when deactivating PRIMARY_OWNER")
        void shouldThrowExceptionWhenDeactivatingPrimaryOwner() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createPrimaryOwner(userId, worldId);

            assertThatThrownBy(() -> player.deactivate())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot deactivate PRIMARY_OWNER");
        }
    }

    @Nested
    @DisplayName("reactivate tests")
    class ReactivateTests {

        @Test
        @DisplayName("should reactivate inactive owner")
        void shouldReactivateInactiveOwner() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.CO_OWNER, grantedBy);
            player.acceptInvitation(player.getInvitationToken());
            player.deactivate();

            player.reactivate();

            assertThat(player.getStatus()).isEqualTo(OwnershipStatus.ACTIVE);
            assertThat(player.getLastActiveAt()).isNotNull();
        }

        @Test
        @DisplayName("should throw exception when not in INACTIVE status")
        void shouldThrowExceptionWhenNotInInactiveStatus() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createPrimaryOwner(userId, worldId);

            assertThatThrownBy(() -> player.reactivate())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot reactivate owner in status");
        }
    }

    @Nested
    @DisplayName("remove tests")
    class RemoveTests {

        @Test
        @DisplayName("should remove owner")
        void shouldRemoveOwner() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.CO_OWNER, grantedBy);
            player.acceptInvitation(player.getInvitationToken());

            player.remove();

            assertThat(player.getStatus()).isEqualTo(OwnershipStatus.REMOVED);
            assertThat(player.getPermissions()).isEmpty();
        }

        @Test
        @DisplayName("should throw exception when removing PRIMARY_OWNER")
        void shouldThrowExceptionWhenRemovingPrimaryOwner() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createPrimaryOwner(userId, worldId);

            assertThatThrownBy(() -> player.remove())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot remove PRIMARY_OWNER");
        }
    }

    @Nested
    @DisplayName("updateRole tests")
    class UpdateRoleTests {

        @Test
        @DisplayName("should update role from MANAGER to CO_OWNER")
        void shouldUpdateRoleFromManagerToCoOwner() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.MANAGER, grantedBy);
            player.acceptInvitation(player.getInvitationToken());

            player.updateRole(OwnershipRole.CO_OWNER);

            assertThat(player.getRole()).isEqualTo(OwnershipRole.CO_OWNER);
            assertThat(player.getPermissions())
                    .containsAll(WorldOwnerPermission.getPermissionsForRole(OwnershipRole.CO_OWNER));
        }

        @Test
        @DisplayName("should throw exception when demoting PRIMARY_OWNER")
        void shouldThrowExceptionWhenDemotingPrimaryOwner() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createPrimaryOwner(userId, worldId);

            assertThatThrownBy(() -> player.updateRole(OwnershipRole.CO_OWNER))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot demote PRIMARY_OWNER");
        }

        @Test
        @DisplayName("should throw exception when promoting to PRIMARY_OWNER")
        void shouldThrowExceptionWhenPromotingToPrimaryOwner() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.CO_OWNER, grantedBy);
            player.acceptInvitation(player.getInvitationToken());

            assertThatThrownBy(() -> player.updateRole(OwnershipRole.PRIMARY_OWNER))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot promote to PRIMARY_OWNER");
        }
    }

    @Nested
    @DisplayName("ownership transfer tests")
    class OwnershipTransferTests {

        @Test
        @DisplayName("should promote to primary owner")
        void shouldPromoteToPrimaryOwner() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.CO_OWNER, grantedBy);
            player.acceptInvitation(player.getInvitationToken());

            player.promoteToPrimaryOwner();

            assertThat(player.getRole()).isEqualTo(OwnershipRole.PRIMARY_OWNER);
            assertThat(player.getPermissions())
                    .containsAll(WorldOwnerPermission.getPermissionsForRole(OwnershipRole.PRIMARY_OWNER));
        }

        @Test
        @DisplayName("should throw exception when promoting non-active owner")
        void shouldThrowExceptionWhenPromotingNonActiveOwner() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.CO_OWNER, grantedBy);

            assertThatThrownBy(() -> player.promoteToPrimaryOwner())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Can only promote active owners");
        }

        @Test
        @DisplayName("should demote from primary owner")
        void shouldDemoteFromPrimaryOwner() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createPrimaryOwner(userId, worldId);

            player.demoteFromPrimaryOwner(OwnershipRole.CO_OWNER);

            assertThat(player.getRole()).isEqualTo(OwnershipRole.CO_OWNER);
        }

        @Test
        @DisplayName("should throw exception when demoting non-primary owner")
        void shouldThrowExceptionWhenDemotingNonPrimaryOwner() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.CO_OWNER, grantedBy);
            player.acceptInvitation(player.getInvitationToken());

            assertThatThrownBy(() -> player.demoteFromPrimaryOwner(OwnershipRole.MANAGER))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Can only demote a PRIMARY_OWNER");
        }

        @Test
        @DisplayName("should throw exception when demoting to PRIMARY_OWNER")
        void shouldThrowExceptionWhenDemotingToPrimaryOwner() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createPrimaryOwner(userId, worldId);

            assertThatThrownBy(() -> player.demoteFromPrimaryOwner(OwnershipRole.PRIMARY_OWNER))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("New role cannot be PRIMARY_OWNER");
        }
    }

    @Nested
    @DisplayName("permission tests")
    class PermissionTests {

        @Test
        @DisplayName("should grant permission")
        void shouldGrantPermission() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.MANAGER, grantedBy);
            player.acceptInvitation(player.getInvitationToken());

            player.grantPermission(WorldOwnerPermission.DELETE_LEAGUES);

            assertThat(player.hasPermission(WorldOwnerPermission.DELETE_LEAGUES)).isTrue();
        }

        @Test
        @DisplayName("should revoke permission")
        void shouldRevokePermission() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.CO_OWNER, grantedBy);
            player.acceptInvitation(player.getInvitationToken());

            player.revokePermission(WorldOwnerPermission.MANAGE_LEAGUES);

            assertThat(player.hasPermission(WorldOwnerPermission.MANAGE_LEAGUES)).isFalse();
        }

        @Test
        @DisplayName("inactive owner should not have permissions")
        void inactiveOwnerShouldNotHavePermissions() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.CO_OWNER, grantedBy);
            player.acceptInvitation(player.getInvitationToken());
            player.deactivate();

            assertThat(player.hasPermission(WorldOwnerPermission.VIEW_PLAYERS)).isFalse();
            assertThat(player.getEffectivePermissions()).isEmpty();
        }
    }

    @Nested
    @DisplayName("utility method tests")
    class UtilityMethodTests {

        @Test
        @DisplayName("isActive should return correct value")
        void isActiveShouldReturnCorrectValue() {
            WorldOwnerPlayer activePlayer = WorldOwnerPlayer.createPrimaryOwner(userId, worldId);
            WorldOwnerPlayer invitedPlayer = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.CO_OWNER, grantedBy);

            assertThat(activePlayer.isActive()).isTrue();
            assertThat(invitedPlayer.isActive()).isFalse();
        }

        @Test
        @DisplayName("isPrimaryOwner should return correct value")
        void isPrimaryOwnerShouldReturnCorrectValue() {
            WorldOwnerPlayer primaryOwner = WorldOwnerPlayer.createPrimaryOwner(userId, worldId);
            WorldOwnerPlayer coOwner = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.CO_OWNER, grantedBy);

            assertThat(primaryOwner.isPrimaryOwner()).isTrue();
            assertThat(coOwner.isPrimaryOwner()).isFalse();
        }

        @Test
        @DisplayName("recordActivity should update lastActiveAt")
        void recordActivityShouldUpdateLastActiveAt() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createPrimaryOwner(userId, worldId);
            Instant before = player.getLastActiveAt();

            player.recordActivity();

            assertThat(player.getLastActiveAt()).isAfterOrEqualTo(before);
        }

        @Test
        @DisplayName("isInvitationExpired should return correct value")
        void isInvitationExpiredShouldReturnCorrectValue() {
            WorldOwnerPlayer player = WorldOwnerPlayer.createInvitation(userId, worldId, OwnershipRole.CO_OWNER, grantedBy);
            assertThat(player.isInvitationExpired()).isFalse();

            player.setInvitationExpiresAt(Instant.now().minus(1, ChronoUnit.DAYS));
            assertThat(player.isInvitationExpired()).isTrue();
        }
    }
}

package com.ffl.playoffs.domain.model.accesscontrol;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.Instant;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("WorldMember Value Object Tests")
class WorldMemberTest {

    @Test
    @DisplayName("should create member with required fields")
    void shouldCreateMemberWithRequiredFields() {
        UUID userId = UUID.randomUUID();
        UUID grantedBy = UUID.randomUUID();

        WorldMember member = WorldMember.create(userId, WorldRole.EDITOR, grantedBy);

        assertThat(member.getUserId()).isEqualTo(userId);
        assertThat(member.getRole()).isEqualTo(WorldRole.EDITOR);
        assertThat(member.getStatus()).isEqualTo(MembershipStatus.PENDING);
        assertThat(member.getGrantedBy()).isEqualTo(grantedBy);
        assertThat(member.getGrantedAt()).isNotNull();
        assertThat(member.getInvitationToken()).isNotNull();
        assertThat(member.hasAccess()).isFalse();
    }

    @Test
    @DisplayName("should create owner member as active")
    void shouldCreateOwnerMemberAsActive() {
        UUID userId = UUID.randomUUID();

        WorldMember owner = WorldMember.createOwner(userId);

        assertThat(owner.getUserId()).isEqualTo(userId);
        assertThat(owner.getRole()).isEqualTo(WorldRole.OWNER);
        assertThat(owner.getStatus()).isEqualTo(MembershipStatus.ACTIVE);
        assertThat(owner.hasAccess()).isTrue();
        assertThat(owner.getInvitationToken()).isNull();
    }

    @Test
    @DisplayName("should activate pending membership")
    void shouldActivatePendingMembership() {
        WorldMember member = createMember(WorldRole.VIEWER);

        member.activate();

        assertThat(member.getStatus()).isEqualTo(MembershipStatus.ACTIVE);
        assertThat(member.hasAccess()).isTrue();
        assertThat(member.getInvitationToken()).isNull();
    }

    @Test
    @DisplayName("should throw when activating non-pending membership")
    void shouldThrowWhenActivatingNonPendingMembership() {
        WorldMember member = WorldMember.createOwner(UUID.randomUUID());

        assertThatIllegalStateException()
                .isThrownBy(member::activate)
                .withMessageContaining("Cannot activate membership");
    }

    @Test
    @DisplayName("should suspend active membership")
    void shouldSuspendActiveMembership() {
        WorldMember member = createMember(WorldRole.EDITOR);
        member.activate();

        member.suspend();

        assertThat(member.getStatus()).isEqualTo(MembershipStatus.SUSPENDED);
        assertThat(member.hasAccess()).isFalse();
    }

    @Test
    @DisplayName("should throw when suspending owner")
    void shouldThrowWhenSuspendingOwner() {
        WorldMember owner = WorldMember.createOwner(UUID.randomUUID());

        assertThatIllegalStateException()
                .isThrownBy(owner::suspend)
                .withMessageContaining("Cannot suspend owner");
    }

    @Test
    @DisplayName("should revoke membership")
    void shouldRevokeMembership() {
        WorldMember member = createMember(WorldRole.VIEWER);
        member.activate();

        member.revoke();

        assertThat(member.getStatus()).isEqualTo(MembershipStatus.REVOKED);
        assertThat(member.hasAccess()).isFalse();
    }

    @Test
    @DisplayName("should throw when revoking owner")
    void shouldThrowWhenRevokingOwner() {
        WorldMember owner = WorldMember.createOwner(UUID.randomUUID());

        assertThatIllegalStateException()
                .isThrownBy(owner::revoke)
                .withMessageContaining("Cannot revoke owner");
    }

    @Test
    @DisplayName("should decline pending invitation")
    void shouldDeclinePendingInvitation() {
        WorldMember member = createMember(WorldRole.VIEWER);

        member.decline();

        assertThat(member.getStatus()).isEqualTo(MembershipStatus.DECLINED);
        assertThat(member.getInvitationToken()).isNull();
    }

    @Test
    @DisplayName("should update role")
    void shouldUpdateRole() {
        WorldMember member = createMember(WorldRole.VIEWER);
        member.activate();

        member.updateRole(WorldRole.EDITOR, UUID.randomUUID());

        assertThat(member.getRole()).isEqualTo(WorldRole.EDITOR);
    }

    @Test
    @DisplayName("should throw when updating owner role")
    void shouldThrowWhenUpdatingOwnerRole() {
        WorldMember owner = WorldMember.createOwner(UUID.randomUUID());

        assertThatIllegalStateException()
                .isThrownBy(() -> owner.updateRole(WorldRole.ADMIN, UUID.randomUUID()))
                .withMessageContaining("Cannot change owner role");
    }

    @Test
    @DisplayName("should throw when promoting to owner")
    void shouldThrowWhenPromotingToOwner() {
        WorldMember member = createMember(WorldRole.ADMIN);
        member.activate();

        assertThatIllegalStateException()
                .isThrownBy(() -> member.updateRole(WorldRole.OWNER, UUID.randomUUID()))
                .withMessageContaining("Cannot promote to owner");
    }

    @Test
    @DisplayName("should have role-based permissions")
    void shouldHaveRoleBasedPermissions() {
        WorldMember viewer = createMember(WorldRole.VIEWER);
        viewer.activate();

        assertThat(viewer.hasPermission(WorldPermission.VIEW_WORLD)).isTrue();
        assertThat(viewer.hasPermission(WorldPermission.EDIT_CONTENT)).isFalse();
    }

    @Test
    @DisplayName("should have additional permissions")
    void shouldHaveAdditionalPermissions() {
        WorldMember member = createMember(WorldRole.VIEWER);
        member.activate();

        member.addPermission(WorldPermission.EDIT_CONTENT);

        assertThat(member.hasPermission(WorldPermission.EDIT_CONTENT)).isTrue();
    }

    @Test
    @DisplayName("should get effective permissions")
    void shouldGetEffectivePermissions() {
        WorldMember member = createMember(WorldRole.VIEWER);
        member.activate();
        member.addPermission(WorldPermission.EDIT_CONTENT);

        var permissions = member.getEffectivePermissions();

        assertThat(permissions).contains(
                WorldPermission.VIEW_WORLD,
                WorldPermission.VIEW_MEMBERS,
                WorldPermission.EDIT_CONTENT
        );
    }

    @Test
    @DisplayName("should check expiration")
    void shouldCheckExpiration() {
        WorldMember member = createMember(WorldRole.VIEWER);
        member.activate();

        // Not expired by default
        assertThat(member.isExpired()).isFalse();
        assertThat(member.hasAccess()).isTrue();

        // Set past expiration
        member.setExpiration(Instant.now().minusSeconds(3600));
        assertThat(member.isExpired()).isTrue();
        assertThat(member.hasAccess()).isFalse();
    }

    @Test
    @DisplayName("should record access time")
    void shouldRecordAccessTime() {
        WorldMember member = createMember(WorldRole.VIEWER);
        member.activate();
        Instant before = Instant.now();

        member.recordAccess();

        assertThat(member.getLastAccessAt()).isAfterOrEqualTo(before);
    }

    private WorldMember createMember(WorldRole role) {
        return WorldMember.create(UUID.randomUUID(), role, UUID.randomUUID());
    }
}

package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.accesscontrol.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("WorldAccessControl Aggregate Tests")
class WorldAccessControlTest {

    @Test
    @DisplayName("should create world access control with owner")
    void shouldCreateWorldAccessControlWithOwner() {
        UUID worldId = UUID.randomUUID();
        UUID ownerId = UUID.randomUUID();

        WorldAccessControl accessControl = WorldAccessControl.create(worldId, ownerId);

        assertThat(accessControl.getId()).isNotNull();
        assertThat(accessControl.getWorldId()).isEqualTo(worldId);
        assertThat(accessControl.getOwnerId()).isEqualTo(ownerId);
        assertThat(accessControl.isPublic()).isFalse();
        assertThat(accessControl.isRequiresApproval()).isTrue();
        assertThat(accessControl.getMembers()).hasSize(1);
        assertThat(accessControl.isOwner(ownerId)).isTrue();
        assertThat(accessControl.hasAccess(ownerId)).isTrue();
    }

    @Test
    @DisplayName("should throw when creating with null world ID")
    void shouldThrowWhenCreatingWithNullWorldId() {
        assertThatNullPointerException()
                .isThrownBy(() -> WorldAccessControl.create(null, UUID.randomUUID()))
                .withMessage("World ID is required");
    }

    @Test
    @DisplayName("should throw when creating with null owner ID")
    void shouldThrowWhenCreatingWithNullOwnerId() {
        assertThatNullPointerException()
                .isThrownBy(() -> WorldAccessControl.create(UUID.randomUUID(), null))
                .withMessage("Owner ID is required");
    }

    @Test
    @DisplayName("should add member with role")
    void shouldAddMemberWithRole() {
        WorldAccessControl accessControl = createAccessControl();
        UUID userId = UUID.randomUUID();

        WorldMember member = accessControl.addMember(userId, WorldRole.EDITOR, accessControl.getOwnerId());

        assertThat(member).isNotNull();
        assertThat(member.getUserId()).isEqualTo(userId);
        assertThat(member.getRole()).isEqualTo(WorldRole.EDITOR);
        assertThat(member.getStatus()).isEqualTo(MembershipStatus.PENDING);
        assertThat(accessControl.isMember(userId)).isTrue();
    }

    @Test
    @DisplayName("should throw when adding member as owner")
    void shouldThrowWhenAddingMemberAsOwner() {
        WorldAccessControl accessControl = createAccessControl();

        assertThatIllegalArgumentException()
                .isThrownBy(() -> accessControl.addMember(UUID.randomUUID(), WorldRole.OWNER, accessControl.getOwnerId()))
                .withMessageContaining("Cannot add member as owner");
    }

    @Test
    @DisplayName("should throw when adding duplicate member")
    void shouldThrowWhenAddingDuplicateMember() {
        WorldAccessControl accessControl = createAccessControl();
        UUID userId = UUID.randomUUID();
        accessControl.addMember(userId, WorldRole.VIEWER, accessControl.getOwnerId());

        assertThatIllegalStateException()
                .isThrownBy(() -> accessControl.addMember(userId, WorldRole.EDITOR, accessControl.getOwnerId()))
                .withMessageContaining("already a member");
    }

    @Test
    @DisplayName("should remove member")
    void shouldRemoveMember() {
        WorldAccessControl accessControl = createAccessControl();
        UUID userId = UUID.randomUUID();
        accessControl.addMember(userId, WorldRole.VIEWER, accessControl.getOwnerId());

        accessControl.removeMember(userId, accessControl.getOwnerId());

        WorldMember member = accessControl.getMember(userId).orElseThrow();
        assertThat(member.getStatus()).isEqualTo(MembershipStatus.REVOKED);
        assertThat(member.hasAccess()).isFalse();
    }

    @Test
    @DisplayName("should throw when removing owner")
    void shouldThrowWhenRemovingOwner() {
        WorldAccessControl accessControl = createAccessControl();

        assertThatIllegalStateException()
                .isThrownBy(() -> accessControl.removeMember(accessControl.getOwnerId(), accessControl.getOwnerId()))
                .withMessageContaining("Cannot remove owner");
    }

    @Test
    @DisplayName("should update member role")
    void shouldUpdateMemberRole() {
        WorldAccessControl accessControl = createAccessControl();
        UUID userId = UUID.randomUUID();
        WorldMember member = accessControl.addMember(userId, WorldRole.VIEWER, accessControl.getOwnerId());
        member.activate();

        accessControl.updateMemberRole(userId, WorldRole.EDITOR, accessControl.getOwnerId());

        assertThat(accessControl.getMember(userId).orElseThrow().getRole()).isEqualTo(WorldRole.EDITOR);
    }

    @Test
    @DisplayName("should transfer ownership")
    void shouldTransferOwnership() {
        WorldAccessControl accessControl = createAccessControl();
        UUID originalOwnerId = accessControl.getOwnerId();
        UUID newOwnerId = UUID.randomUUID();

        accessControl.addMember(newOwnerId, WorldRole.ADMIN, originalOwnerId);
        accessControl.getMember(newOwnerId).orElseThrow().activate();

        accessControl.transferOwnership(newOwnerId, originalOwnerId);

        assertThat(accessControl.getOwnerId()).isEqualTo(newOwnerId);
        assertThat(accessControl.isOwner(newOwnerId)).isTrue();
        assertThat(accessControl.isOwner(originalOwnerId)).isFalse();
        assertThat(accessControl.getMember(newOwnerId).orElseThrow().getRole()).isEqualTo(WorldRole.OWNER);
        assertThat(accessControl.getMember(originalOwnerId).orElseThrow().getRole()).isEqualTo(WorldRole.ADMIN);
    }

    @Test
    @DisplayName("should throw when non-owner tries to transfer ownership")
    void shouldThrowWhenNonOwnerTriesToTransferOwnership() {
        WorldAccessControl accessControl = createAccessControl();
        UUID nonOwner = UUID.randomUUID();

        assertThatIllegalStateException()
                .isThrownBy(() -> accessControl.transferOwnership(UUID.randomUUID(), nonOwner))
                .withMessageContaining("Only the current owner can transfer ownership");
    }

    @Test
    @DisplayName("should accept invitation with token")
    void shouldAcceptInvitationWithToken() {
        WorldAccessControl accessControl = createAccessControl();
        UUID userId = UUID.randomUUID();
        WorldMember member = accessControl.addMember(userId, WorldRole.VIEWER, accessControl.getOwnerId());
        String token = member.getInvitationToken();

        accessControl.acceptInvitation(userId, token);

        assertThat(member.getStatus()).isEqualTo(MembershipStatus.ACTIVE);
        assertThat(member.hasAccess()).isTrue();
    }

    @Test
    @DisplayName("should throw when accepting with invalid token")
    void shouldThrowWhenAcceptingWithInvalidToken() {
        WorldAccessControl accessControl = createAccessControl();
        UUID userId = UUID.randomUUID();
        accessControl.addMember(userId, WorldRole.VIEWER, accessControl.getOwnerId());

        assertThatIllegalArgumentException()
                .isThrownBy(() -> accessControl.acceptInvitation(userId, "wrong-token"))
                .withMessageContaining("Invalid invitation token");
    }

    @Test
    @DisplayName("should decline invitation")
    void shouldDeclineInvitation() {
        WorldAccessControl accessControl = createAccessControl();
        UUID userId = UUID.randomUUID();
        accessControl.addMember(userId, WorldRole.VIEWER, accessControl.getOwnerId());

        accessControl.declineInvitation(userId);

        WorldMember member = accessControl.getMember(userId).orElseThrow();
        assertThat(member.getStatus()).isEqualTo(MembershipStatus.DECLINED);
        assertThat(member.hasAccess()).isFalse();
    }

    @Test
    @DisplayName("should check permission correctly")
    void shouldCheckPermissionCorrectly() {
        WorldAccessControl accessControl = createAccessControl();
        UUID viewerId = UUID.randomUUID();
        WorldMember viewer = accessControl.addMember(viewerId, WorldRole.VIEWER, accessControl.getOwnerId());
        viewer.activate();

        // Owner should have all permissions
        assertThat(accessControl.hasPermission(accessControl.getOwnerId(), WorldPermission.DELETE_WORLD)).isTrue();

        // Viewer should not have delete permission
        assertThat(accessControl.hasPermission(viewerId, WorldPermission.DELETE_WORLD)).isFalse();

        // Viewer should have view permission
        assertThat(accessControl.hasPermission(viewerId, WorldPermission.VIEW_WORLD)).isTrue();
    }

    @Test
    @DisplayName("should get active members only")
    void shouldGetActiveMembersOnly() {
        WorldAccessControl accessControl = createAccessControl();
        UUID activeUserId = UUID.randomUUID();
        UUID pendingUserId = UUID.randomUUID();

        WorldMember activeMember = accessControl.addMember(activeUserId, WorldRole.VIEWER, accessControl.getOwnerId());
        activeMember.activate();
        accessControl.addMember(pendingUserId, WorldRole.VIEWER, accessControl.getOwnerId());

        assertThat(accessControl.getActiveMembers()).hasSize(2); // owner + active member
        assertThat(accessControl.getActiveMemberCount()).isEqualTo(2);
    }

    @Test
    @DisplayName("should set public visibility")
    void shouldSetPublicVisibility() {
        WorldAccessControl accessControl = createAccessControl();

        accessControl.setPublic(true, accessControl.getOwnerId());

        assertThat(accessControl.isPublic()).isTrue();
    }

    @Test
    @DisplayName("should grant additional permission")
    void shouldGrantAdditionalPermission() {
        WorldAccessControl accessControl = createAccessControl();
        UUID userId = UUID.randomUUID();
        WorldMember member = accessControl.addMember(userId, WorldRole.VIEWER, accessControl.getOwnerId());
        member.activate();

        accessControl.grantAdditionalPermission(userId, WorldPermission.EDIT_CONTENT, accessControl.getOwnerId());

        assertThat(member.hasPermission(WorldPermission.EDIT_CONTENT)).isTrue();
    }

    private WorldAccessControl createAccessControl() {
        return WorldAccessControl.create(UUID.randomUUID(), UUID.randomUUID());
    }
}

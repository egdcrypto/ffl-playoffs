package com.ffl.playoffs.domain.model.invitation;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("AdminInvitation Tests")
class AdminInvitationTest {

    private UUID invitedBy;

    @BeforeEach
    void setUp() {
        invitedBy = UUID.randomUUID();
    }

    @Nested
    @DisplayName("create tests")
    class CreateTests {

        @Test
        @DisplayName("should create invitation with valid parameters")
        void shouldCreateInvitationWithValidParameters() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "New Admin", invitedBy);

            assertThat(invitation.getId()).isNotNull();
            assertThat(invitation.getEmail()).isEqualTo("admin@example.com");
            assertThat(invitation.getName()).isEqualTo("New Admin");
            assertThat(invitation.getInvitedBy()).isEqualTo(invitedBy);
            assertThat(invitation.getStatus()).isEqualTo(AdminInvitationStatus.PENDING);
            assertThat(invitation.getInvitationToken()).isNotNull();
            assertThat(invitation.getExpiresAt()).isAfter(Instant.now());
            assertThat(invitation.getResendCount()).isZero();
        }

        @Test
        @DisplayName("should lowercase email")
        void shouldLowercaseEmail() {
            AdminInvitation invitation = AdminInvitation.create("Admin@Example.COM", "Admin", invitedBy);
            assertThat(invitation.getEmail()).isEqualTo("admin@example.com");
        }

        @Test
        @DisplayName("should trim name")
        void shouldTrimName() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "  Admin Name  ", invitedBy);
            assertThat(invitation.getName()).isEqualTo("Admin Name");
        }

        @Test
        @DisplayName("should throw exception for null email")
        void shouldThrowExceptionForNullEmail() {
            assertThatThrownBy(() -> AdminInvitation.create(null, "Admin", invitedBy))
                    .isInstanceOf(NullPointerException.class);
        }

        @Test
        @DisplayName("should throw exception for blank email")
        void shouldThrowExceptionForBlankEmail() {
            assertThatThrownBy(() -> AdminInvitation.create("   ", "Admin", invitedBy))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Email cannot be blank");
        }

        @Test
        @DisplayName("should throw exception for blank name")
        void shouldThrowExceptionForBlankName() {
            assertThatThrownBy(() -> AdminInvitation.create("admin@example.com", "   ", invitedBy))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Name cannot be blank");
        }
    }

    @Nested
    @DisplayName("accept tests")
    class AcceptTests {

        @Test
        @DisplayName("should accept invitation with valid token")
        void shouldAcceptInvitationWithValidToken() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "Admin", invitedBy);
            String token = invitation.getInvitationToken();
            UUID userId = UUID.randomUUID();

            invitation.accept(token, userId);

            assertThat(invitation.getStatus()).isEqualTo(AdminInvitationStatus.ACCEPTED);
            assertThat(invitation.getAcceptedAt()).isNotNull();
            assertThat(invitation.getAcceptedUserId()).isEqualTo(userId);
            assertThat(invitation.getInvitationToken()).isNull();
        }

        @Test
        @DisplayName("should throw exception for invalid token")
        void shouldThrowExceptionForInvalidToken() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "Admin", invitedBy);
            UUID userId = UUID.randomUUID();

            assertThatThrownBy(() -> invitation.accept("wrong-token", userId))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Invalid invitation token");
        }

        @Test
        @DisplayName("should throw exception when already accepted")
        void shouldThrowExceptionWhenAlreadyAccepted() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "Admin", invitedBy);
            String token = invitation.getInvitationToken();
            UUID userId = UUID.randomUUID();
            invitation.accept(token, userId);

            assertThatThrownBy(() -> invitation.accept(token, userId))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot accept invitation in status");
        }

        @Test
        @DisplayName("should throw exception for expired invitation")
        void shouldThrowExceptionForExpiredInvitation() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "Admin", invitedBy);
            String token = invitation.getInvitationToken();
            invitation.setExpiresAt(Instant.now().minus(1, ChronoUnit.DAYS));
            UUID userId = UUID.randomUUID();

            assertThatThrownBy(() -> invitation.accept(token, userId))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Invitation has expired");
        }
    }

    @Nested
    @DisplayName("decline tests")
    class DeclineTests {

        @Test
        @DisplayName("should decline pending invitation")
        void shouldDeclinePendingInvitation() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "Admin", invitedBy);

            invitation.decline();

            assertThat(invitation.getStatus()).isEqualTo(AdminInvitationStatus.DECLINED);
            assertThat(invitation.getInvitationToken()).isNull();
        }

        @Test
        @DisplayName("should throw exception when already accepted")
        void shouldThrowExceptionWhenAlreadyAccepted() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "Admin", invitedBy);
            invitation.accept(invitation.getInvitationToken(), UUID.randomUUID());

            assertThatThrownBy(() -> invitation.decline())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot decline invitation in status");
        }
    }

    @Nested
    @DisplayName("revoke tests")
    class RevokeTests {

        @Test
        @DisplayName("should revoke pending invitation")
        void shouldRevokePendingInvitation() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "Admin", invitedBy);

            invitation.revoke("No longer needed");

            assertThat(invitation.getStatus()).isEqualTo(AdminInvitationStatus.REVOKED);
            assertThat(invitation.getRevokeReason()).isEqualTo("No longer needed");
            assertThat(invitation.getRevokedAt()).isNotNull();
            assertThat(invitation.getInvitationToken()).isNull();
        }

        @Test
        @DisplayName("should throw exception when already accepted")
        void shouldThrowExceptionWhenAlreadyAccepted() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "Admin", invitedBy);
            invitation.accept(invitation.getInvitationToken(), UUID.randomUUID());

            assertThatThrownBy(() -> invitation.revoke("reason"))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot revoke invitation in status");
        }
    }

    @Nested
    @DisplayName("resend tests")
    class ResendTests {

        @Test
        @DisplayName("should resend pending invitation")
        void shouldResendPendingInvitation() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "Admin", invitedBy);
            String originalToken = invitation.getInvitationToken();
            Instant originalExpiry = invitation.getExpiresAt();

            invitation.resend();

            assertThat(invitation.getInvitationToken()).isNotEqualTo(originalToken);
            assertThat(invitation.getExpiresAt()).isAfter(originalExpiry);
            assertThat(invitation.getResendCount()).isEqualTo(1);
            assertThat(invitation.getStatus()).isEqualTo(AdminInvitationStatus.PENDING);
        }

        @Test
        @DisplayName("should resend expired invitation")
        void shouldResendExpiredInvitation() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "Admin", invitedBy);
            invitation.setExpiresAt(Instant.now().minus(1, ChronoUnit.DAYS));
            invitation.markExpired();

            invitation.resend();

            assertThat(invitation.getStatus()).isEqualTo(AdminInvitationStatus.PENDING);
            assertThat(invitation.getExpiresAt()).isAfter(Instant.now());
        }

        @Test
        @DisplayName("should throw exception when already accepted")
        void shouldThrowExceptionWhenAlreadyAccepted() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "Admin", invitedBy);
            invitation.accept(invitation.getInvitationToken(), UUID.randomUUID());

            assertThatThrownBy(() -> invitation.resend())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Can only resend pending or expired invitations");
        }
    }

    @Nested
    @DisplayName("validation tests")
    class ValidationTests {

        @Test
        @DisplayName("isValid should return true for pending non-expired invitation")
        void isValidShouldReturnTrueForPendingNonExpired() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "Admin", invitedBy);
            assertThat(invitation.isValid()).isTrue();
        }

        @Test
        @DisplayName("isValid should return false for expired invitation")
        void isValidShouldReturnFalseForExpired() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "Admin", invitedBy);
            invitation.setExpiresAt(Instant.now().minus(1, ChronoUnit.DAYS));
            assertThat(invitation.isValid()).isFalse();
        }

        @Test
        @DisplayName("validateToken should return true for valid token")
        void validateTokenShouldReturnTrueForValidToken() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "Admin", invitedBy);
            assertThat(invitation.validateToken(invitation.getInvitationToken())).isTrue();
        }

        @Test
        @DisplayName("validateToken should return false for invalid token")
        void validateTokenShouldReturnFalseForInvalidToken() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "Admin", invitedBy);
            assertThat(invitation.validateToken("wrong-token")).isFalse();
        }
    }

    @Nested
    @DisplayName("utility tests")
    class UtilityTests {

        @Test
        @DisplayName("getRemainingHours should return positive value for valid invitation")
        void getRemainingHoursShouldReturnPositiveForValid() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "Admin", invitedBy);
            assertThat(invitation.getRemainingHours()).isPositive();
        }

        @Test
        @DisplayName("getRemainingHours should return zero for expired invitation")
        void getRemainingHoursShouldReturnZeroForExpired() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "Admin", invitedBy);
            invitation.setExpiresAt(Instant.now().minus(1, ChronoUnit.DAYS));
            assertThat(invitation.getRemainingHours()).isZero();
        }

        @Test
        @DisplayName("isAccepted should return true after acceptance")
        void isAcceptedShouldReturnTrueAfterAcceptance() {
            AdminInvitation invitation = AdminInvitation.create("admin@example.com", "Admin", invitedBy);
            assertThat(invitation.isAccepted()).isFalse();

            invitation.accept(invitation.getInvitationToken(), UUID.randomUUID());
            assertThat(invitation.isAccepted()).isTrue();
        }
    }
}

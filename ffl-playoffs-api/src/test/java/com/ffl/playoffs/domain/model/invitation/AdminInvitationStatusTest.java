package com.ffl.playoffs.domain.model.invitation;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("AdminInvitationStatus Enum Tests")
class AdminInvitationStatusTest {

    @Test
    @DisplayName("should have exactly five statuses")
    void shouldHaveExactlyFiveStatuses() {
        assertThat(AdminInvitationStatus.values()).hasSize(5);
    }

    @Test
    @DisplayName("should have correct codes")
    void shouldHaveCorrectCodes() {
        assertThat(AdminInvitationStatus.PENDING.getCode()).isEqualTo("pending");
        assertThat(AdminInvitationStatus.ACCEPTED.getCode()).isEqualTo("accepted");
        assertThat(AdminInvitationStatus.DECLINED.getCode()).isEqualTo("declined");
        assertThat(AdminInvitationStatus.EXPIRED.getCode()).isEqualTo("expired");
        assertThat(AdminInvitationStatus.REVOKED.getCode()).isEqualTo("revoked");
    }

    @Test
    @DisplayName("should resolve from code")
    void shouldResolveFromCode() {
        assertThat(AdminInvitationStatus.fromCode("pending")).isEqualTo(AdminInvitationStatus.PENDING);
        assertThat(AdminInvitationStatus.fromCode("accepted")).isEqualTo(AdminInvitationStatus.ACCEPTED);
        assertThat(AdminInvitationStatus.fromCode("declined")).isEqualTo(AdminInvitationStatus.DECLINED);
        assertThat(AdminInvitationStatus.fromCode("expired")).isEqualTo(AdminInvitationStatus.EXPIRED);
        assertThat(AdminInvitationStatus.fromCode("revoked")).isEqualTo(AdminInvitationStatus.REVOKED);
    }

    @Test
    @DisplayName("should resolve from code case insensitively")
    void shouldResolveFromCodeCaseInsensitively() {
        assertThat(AdminInvitationStatus.fromCode("PENDING")).isEqualTo(AdminInvitationStatus.PENDING);
        assertThat(AdminInvitationStatus.fromCode("Accepted")).isEqualTo(AdminInvitationStatus.ACCEPTED);
    }

    @Test
    @DisplayName("should throw exception for unknown code")
    void shouldThrowExceptionForUnknownCode() {
        assertThatThrownBy(() -> AdminInvitationStatus.fromCode("unknown"))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Unknown admin invitation status code");
    }

    @Nested
    @DisplayName("isPending tests")
    class IsPendingTests {

        @Test
        @DisplayName("only PENDING should return true")
        void onlyPendingShouldReturnTrue() {
            assertThat(AdminInvitationStatus.PENDING.isPending()).isTrue();
            assertThat(AdminInvitationStatus.ACCEPTED.isPending()).isFalse();
            assertThat(AdminInvitationStatus.DECLINED.isPending()).isFalse();
            assertThat(AdminInvitationStatus.EXPIRED.isPending()).isFalse();
            assertThat(AdminInvitationStatus.REVOKED.isPending()).isFalse();
        }
    }

    @Nested
    @DisplayName("canAccept tests")
    class CanAcceptTests {

        @Test
        @DisplayName("only PENDING can be accepted")
        void onlyPendingCanBeAccepted() {
            assertThat(AdminInvitationStatus.PENDING.canAccept()).isTrue();
            assertThat(AdminInvitationStatus.ACCEPTED.canAccept()).isFalse();
            assertThat(AdminInvitationStatus.DECLINED.canAccept()).isFalse();
            assertThat(AdminInvitationStatus.EXPIRED.canAccept()).isFalse();
            assertThat(AdminInvitationStatus.REVOKED.canAccept()).isFalse();
        }
    }

    @Nested
    @DisplayName("canDecline tests")
    class CanDeclineTests {

        @Test
        @DisplayName("only PENDING can be declined")
        void onlyPendingCanBeDeclined() {
            assertThat(AdminInvitationStatus.PENDING.canDecline()).isTrue();
            assertThat(AdminInvitationStatus.ACCEPTED.canDecline()).isFalse();
        }
    }

    @Nested
    @DisplayName("canRevoke tests")
    class CanRevokeTests {

        @Test
        @DisplayName("only PENDING can be revoked")
        void onlyPendingCanBeRevoked() {
            assertThat(AdminInvitationStatus.PENDING.canRevoke()).isTrue();
            assertThat(AdminInvitationStatus.ACCEPTED.canRevoke()).isFalse();
        }
    }

    @Nested
    @DisplayName("isTerminal tests")
    class IsTerminalTests {

        @Test
        @DisplayName("ACCEPTED, DECLINED, EXPIRED, REVOKED are terminal")
        void terminalStatuses() {
            assertThat(AdminInvitationStatus.PENDING.isTerminal()).isFalse();
            assertThat(AdminInvitationStatus.ACCEPTED.isTerminal()).isTrue();
            assertThat(AdminInvitationStatus.DECLINED.isTerminal()).isTrue();
            assertThat(AdminInvitationStatus.EXPIRED.isTerminal()).isTrue();
            assertThat(AdminInvitationStatus.REVOKED.isTerminal()).isTrue();
        }
    }

    @Nested
    @DisplayName("isSuccessful tests")
    class IsSuccessfulTests {

        @Test
        @DisplayName("only ACCEPTED is successful")
        void onlyAcceptedIsSuccessful() {
            assertThat(AdminInvitationStatus.ACCEPTED.isSuccessful()).isTrue();
            assertThat(AdminInvitationStatus.PENDING.isSuccessful()).isFalse();
            assertThat(AdminInvitationStatus.DECLINED.isSuccessful()).isFalse();
        }
    }
}

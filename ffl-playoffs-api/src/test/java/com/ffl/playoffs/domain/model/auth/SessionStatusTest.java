package com.ffl.playoffs.domain.model.auth;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("SessionStatus Enum Tests")
class SessionStatusTest {

    @Test
    @DisplayName("should have exactly five statuses")
    void shouldHaveExactlyFiveStatuses() {
        assertThat(SessionStatus.values()).hasSize(5);
    }

    @Test
    @DisplayName("should have correct codes")
    void shouldHaveCorrectCodes() {
        assertThat(SessionStatus.ACTIVE.getCode()).isEqualTo("active");
        assertThat(SessionStatus.EXPIRED.getCode()).isEqualTo("expired");
        assertThat(SessionStatus.INVALIDATED.getCode()).isEqualTo("invalidated");
        assertThat(SessionStatus.REVOKED.getCode()).isEqualTo("revoked");
        assertThat(SessionStatus.REFRESHED.getCode()).isEqualTo("refreshed");
    }

    @Nested
    @DisplayName("fromCode tests")
    class FromCodeTests {

        @Test
        @DisplayName("should resolve from code")
        void shouldResolveFromCode() {
            assertThat(SessionStatus.fromCode("active")).isEqualTo(SessionStatus.ACTIVE);
            assertThat(SessionStatus.fromCode("expired")).isEqualTo(SessionStatus.EXPIRED);
            assertThat(SessionStatus.fromCode("invalidated")).isEqualTo(SessionStatus.INVALIDATED);
            assertThat(SessionStatus.fromCode("revoked")).isEqualTo(SessionStatus.REVOKED);
            assertThat(SessionStatus.fromCode("refreshed")).isEqualTo(SessionStatus.REFRESHED);
        }

        @Test
        @DisplayName("should resolve from code case insensitively")
        void shouldResolveFromCodeCaseInsensitively() {
            assertThat(SessionStatus.fromCode("ACTIVE")).isEqualTo(SessionStatus.ACTIVE);
            assertThat(SessionStatus.fromCode("Expired")).isEqualTo(SessionStatus.EXPIRED);
        }

        @Test
        @DisplayName("should throw exception for unknown code")
        void shouldThrowExceptionForUnknownCode() {
            assertThatThrownBy(() -> SessionStatus.fromCode("unknown"))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Unknown session status code");
        }
    }

    @Nested
    @DisplayName("isActive tests")
    class IsActiveTests {

        @Test
        @DisplayName("only ACTIVE should return true")
        void onlyActiveShouldReturnTrue() {
            assertThat(SessionStatus.ACTIVE.isActive()).isTrue();
            assertThat(SessionStatus.EXPIRED.isActive()).isFalse();
            assertThat(SessionStatus.INVALIDATED.isActive()).isFalse();
            assertThat(SessionStatus.REVOKED.isActive()).isFalse();
            assertThat(SessionStatus.REFRESHED.isActive()).isFalse();
        }
    }

    @Nested
    @DisplayName("isTerminal tests")
    class IsTerminalTests {

        @Test
        @DisplayName("terminal statuses should return true")
        void terminalStatusesShouldReturnTrue() {
            assertThat(SessionStatus.ACTIVE.isTerminal()).isFalse();
            assertThat(SessionStatus.EXPIRED.isTerminal()).isTrue();
            assertThat(SessionStatus.INVALIDATED.isTerminal()).isTrue();
            assertThat(SessionStatus.REVOKED.isTerminal()).isTrue();
            assertThat(SessionStatus.REFRESHED.isTerminal()).isTrue();
        }
    }

    @Nested
    @DisplayName("canRefresh tests")
    class CanRefreshTests {

        @Test
        @DisplayName("only ACTIVE can be refreshed")
        void onlyActiveCanBeRefreshed() {
            assertThat(SessionStatus.ACTIVE.canRefresh()).isTrue();
            assertThat(SessionStatus.EXPIRED.canRefresh()).isFalse();
            assertThat(SessionStatus.INVALIDATED.canRefresh()).isFalse();
            assertThat(SessionStatus.REVOKED.canRefresh()).isFalse();
            assertThat(SessionStatus.REFRESHED.canRefresh()).isFalse();
        }
    }

    @Nested
    @DisplayName("canInvalidate tests")
    class CanInvalidateTests {

        @Test
        @DisplayName("only ACTIVE can be invalidated")
        void onlyActiveCanBeInvalidated() {
            assertThat(SessionStatus.ACTIVE.canInvalidate()).isTrue();
            assertThat(SessionStatus.EXPIRED.canInvalidate()).isFalse();
            assertThat(SessionStatus.INVALIDATED.canInvalidate()).isFalse();
            assertThat(SessionStatus.REVOKED.canInvalidate()).isFalse();
            assertThat(SessionStatus.REFRESHED.canInvalidate()).isFalse();
        }
    }

    @Nested
    @DisplayName("canRevoke tests")
    class CanRevokeTests {

        @Test
        @DisplayName("only ACTIVE can be revoked")
        void onlyActiveCanBeRevoked() {
            assertThat(SessionStatus.ACTIVE.canRevoke()).isTrue();
            assertThat(SessionStatus.EXPIRED.canRevoke()).isFalse();
            assertThat(SessionStatus.INVALIDATED.canRevoke()).isFalse();
            assertThat(SessionStatus.REVOKED.canRevoke()).isFalse();
            assertThat(SessionStatus.REFRESHED.canRevoke()).isFalse();
        }
    }

    @Nested
    @DisplayName("display name tests")
    class DisplayNameTests {

        @Test
        @DisplayName("should have display names")
        void shouldHaveDisplayNames() {
            assertThat(SessionStatus.ACTIVE.getDisplayName()).isEqualTo("Active");
            assertThat(SessionStatus.EXPIRED.getDisplayName()).isEqualTo("Expired");
            assertThat(SessionStatus.INVALIDATED.getDisplayName()).isEqualTo("Invalidated");
            assertThat(SessionStatus.REVOKED.getDisplayName()).isEqualTo("Revoked");
            assertThat(SessionStatus.REFRESHED.getDisplayName()).isEqualTo("Refreshed");
        }
    }

    @Nested
    @DisplayName("description tests")
    class DescriptionTests {

        @Test
        @DisplayName("should have descriptions")
        void shouldHaveDescriptions() {
            assertThat(SessionStatus.ACTIVE.getDescription()).contains("active");
            assertThat(SessionStatus.EXPIRED.getDescription()).contains("expired");
            assertThat(SessionStatus.INVALIDATED.getDescription()).contains("invalidated");
            assertThat(SessionStatus.REVOKED.getDescription()).contains("revoked");
            assertThat(SessionStatus.REFRESHED.getDescription()).contains("refreshed");
        }
    }
}

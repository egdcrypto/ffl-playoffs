package com.ffl.playoffs.domain.model.worldowner;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("OwnershipStatus Enum Tests")
class OwnershipStatusTest {

    @Test
    @DisplayName("should have exactly five statuses")
    void shouldHaveExactlyFiveStatuses() {
        assertThat(OwnershipStatus.values()).hasSize(5);
    }

    @Test
    @DisplayName("should have correct codes")
    void shouldHaveCorrectCodes() {
        assertThat(OwnershipStatus.INVITED.getCode()).isEqualTo("invited");
        assertThat(OwnershipStatus.ACTIVE.getCode()).isEqualTo("active");
        assertThat(OwnershipStatus.INACTIVE.getCode()).isEqualTo("inactive");
        assertThat(OwnershipStatus.REMOVED.getCode()).isEqualTo("removed");
        assertThat(OwnershipStatus.DECLINED.getCode()).isEqualTo("declined");
    }

    @Test
    @DisplayName("should resolve from code")
    void shouldResolveFromCode() {
        assertThat(OwnershipStatus.fromCode("invited")).isEqualTo(OwnershipStatus.INVITED);
        assertThat(OwnershipStatus.fromCode("active")).isEqualTo(OwnershipStatus.ACTIVE);
        assertThat(OwnershipStatus.fromCode("inactive")).isEqualTo(OwnershipStatus.INACTIVE);
        assertThat(OwnershipStatus.fromCode("removed")).isEqualTo(OwnershipStatus.REMOVED);
        assertThat(OwnershipStatus.fromCode("declined")).isEqualTo(OwnershipStatus.DECLINED);
    }

    @Test
    @DisplayName("should resolve from code case insensitively")
    void shouldResolveFromCodeCaseInsensitively() {
        assertThat(OwnershipStatus.fromCode("ACTIVE")).isEqualTo(OwnershipStatus.ACTIVE);
        assertThat(OwnershipStatus.fromCode("Invited")).isEqualTo(OwnershipStatus.INVITED);
    }

    @Test
    @DisplayName("should throw exception for unknown code")
    void shouldThrowExceptionForUnknownCode() {
        assertThatThrownBy(() -> OwnershipStatus.fromCode("unknown"))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Unknown ownership status code");
    }

    @Nested
    @DisplayName("isActive tests")
    class IsActiveTests {

        @Test
        @DisplayName("only ACTIVE status should be active")
        void onlyActiveStatusShouldBeActive() {
            assertThat(OwnershipStatus.ACTIVE.isActive()).isTrue();
            assertThat(OwnershipStatus.INVITED.isActive()).isFalse();
            assertThat(OwnershipStatus.INACTIVE.isActive()).isFalse();
            assertThat(OwnershipStatus.REMOVED.isActive()).isFalse();
            assertThat(OwnershipStatus.DECLINED.isActive()).isFalse();
        }
    }

    @Nested
    @DisplayName("canActivate tests")
    class CanActivateTests {

        @Test
        @DisplayName("INVITED and INACTIVE can activate")
        void invitedAndInactiveCanActivate() {
            assertThat(OwnershipStatus.INVITED.canActivate()).isTrue();
            assertThat(OwnershipStatus.INACTIVE.canActivate()).isTrue();
        }

        @Test
        @DisplayName("ACTIVE, REMOVED, and DECLINED cannot activate")
        void activeRemovedAndDeclinedCannotActivate() {
            assertThat(OwnershipStatus.ACTIVE.canActivate()).isFalse();
            assertThat(OwnershipStatus.REMOVED.canActivate()).isFalse();
            assertThat(OwnershipStatus.DECLINED.canActivate()).isFalse();
        }
    }

    @Nested
    @DisplayName("isTerminal tests")
    class IsTerminalTests {

        @Test
        @DisplayName("REMOVED and DECLINED are terminal")
        void removedAndDeclinedAreTerminal() {
            assertThat(OwnershipStatus.REMOVED.isTerminal()).isTrue();
            assertThat(OwnershipStatus.DECLINED.isTerminal()).isTrue();
        }

        @Test
        @DisplayName("INVITED, ACTIVE, and INACTIVE are not terminal")
        void invitedActiveAndInactiveAreNotTerminal() {
            assertThat(OwnershipStatus.INVITED.isTerminal()).isFalse();
            assertThat(OwnershipStatus.ACTIVE.isTerminal()).isFalse();
            assertThat(OwnershipStatus.INACTIVE.isTerminal()).isFalse();
        }
    }

    @Nested
    @DisplayName("canReactivate tests")
    class CanReactivateTests {

        @Test
        @DisplayName("only INACTIVE can reactivate")
        void onlyInactiveCanReactivate() {
            assertThat(OwnershipStatus.INACTIVE.canReactivate()).isTrue();
        }

        @Test
        @DisplayName("other statuses cannot reactivate")
        void otherStatusesCannotReactivate() {
            assertThat(OwnershipStatus.INVITED.canReactivate()).isFalse();
            assertThat(OwnershipStatus.ACTIVE.canReactivate()).isFalse();
            assertThat(OwnershipStatus.REMOVED.canReactivate()).isFalse();
            assertThat(OwnershipStatus.DECLINED.canReactivate()).isFalse();
        }
    }
}

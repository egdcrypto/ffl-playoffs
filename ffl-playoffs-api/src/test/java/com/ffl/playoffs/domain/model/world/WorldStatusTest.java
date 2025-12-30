package com.ffl.playoffs.domain.model.world;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("WorldStatus Enum Tests")
class WorldStatusTest {

    @Test
    @DisplayName("should have exactly five statuses")
    void shouldHaveExactlyFiveStatuses() {
        assertThat(WorldStatus.values()).hasSize(5);
    }

    @Test
    @DisplayName("should have correct codes")
    void shouldHaveCorrectCodes() {
        assertThat(WorldStatus.DRAFT.getCode()).isEqualTo("draft");
        assertThat(WorldStatus.ACTIVE.getCode()).isEqualTo("active");
        assertThat(WorldStatus.SUSPENDED.getCode()).isEqualTo("suspended");
        assertThat(WorldStatus.ARCHIVED.getCode()).isEqualTo("archived");
        assertThat(WorldStatus.DELETED.getCode()).isEqualTo("deleted");
    }

    @Test
    @DisplayName("should resolve from code")
    void shouldResolveFromCode() {
        assertThat(WorldStatus.fromCode("draft")).isEqualTo(WorldStatus.DRAFT);
        assertThat(WorldStatus.fromCode("active")).isEqualTo(WorldStatus.ACTIVE);
        assertThat(WorldStatus.fromCode("suspended")).isEqualTo(WorldStatus.SUSPENDED);
        assertThat(WorldStatus.fromCode("archived")).isEqualTo(WorldStatus.ARCHIVED);
        assertThat(WorldStatus.fromCode("deleted")).isEqualTo(WorldStatus.DELETED);
    }

    @Test
    @DisplayName("should throw exception for unknown code")
    void shouldThrowExceptionForUnknownCode() {
        assertThatThrownBy(() -> WorldStatus.fromCode("unknown"))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Unknown world status code");
    }

    @Nested
    @DisplayName("isModifiable tests")
    class IsModifiableTests {

        @Test
        @DisplayName("DRAFT and ACTIVE should be modifiable")
        void draftAndActiveShouldBeModifiable() {
            assertThat(WorldStatus.DRAFT.isModifiable()).isTrue();
            assertThat(WorldStatus.ACTIVE.isModifiable()).isTrue();
        }

        @Test
        @DisplayName("other statuses should not be modifiable")
        void otherStatusesShouldNotBeModifiable() {
            assertThat(WorldStatus.SUSPENDED.isModifiable()).isFalse();
            assertThat(WorldStatus.ARCHIVED.isModifiable()).isFalse();
            assertThat(WorldStatus.DELETED.isModifiable()).isFalse();
        }
    }

    @Nested
    @DisplayName("allowsNewMembers tests")
    class AllowsNewMembersTests {

        @Test
        @DisplayName("only ACTIVE should allow new members")
        void onlyActiveShouldAllowNewMembers() {
            assertThat(WorldStatus.ACTIVE.allowsNewMembers()).isTrue();
        }

        @Test
        @DisplayName("other statuses should not allow new members")
        void otherStatusesShouldNotAllowNewMembers() {
            assertThat(WorldStatus.DRAFT.allowsNewMembers()).isFalse();
            assertThat(WorldStatus.SUSPENDED.allowsNewMembers()).isFalse();
            assertThat(WorldStatus.ARCHIVED.allowsNewMembers()).isFalse();
            assertThat(WorldStatus.DELETED.allowsNewMembers()).isFalse();
        }
    }

    @Nested
    @DisplayName("isTerminal tests")
    class IsTerminalTests {

        @Test
        @DisplayName("ARCHIVED and DELETED should be terminal")
        void archivedAndDeletedShouldBeTerminal() {
            assertThat(WorldStatus.ARCHIVED.isTerminal()).isTrue();
            assertThat(WorldStatus.DELETED.isTerminal()).isTrue();
        }

        @Test
        @DisplayName("other statuses should not be terminal")
        void otherStatusesShouldNotBeTerminal() {
            assertThat(WorldStatus.DRAFT.isTerminal()).isFalse();
            assertThat(WorldStatus.ACTIVE.isTerminal()).isFalse();
            assertThat(WorldStatus.SUSPENDED.isTerminal()).isFalse();
        }
    }

    @Nested
    @DisplayName("state transition tests")
    class StateTransitionTests {

        @Test
        @DisplayName("DRAFT and SUSPENDED can activate")
        void draftAndSuspendedCanActivate() {
            assertThat(WorldStatus.DRAFT.canActivate()).isTrue();
            assertThat(WorldStatus.SUSPENDED.canActivate()).isTrue();
        }

        @Test
        @DisplayName("ACTIVE can suspend")
        void activeCanSuspend() {
            assertThat(WorldStatus.ACTIVE.canSuspend()).isTrue();
        }

        @Test
        @DisplayName("ACTIVE and SUSPENDED can archive")
        void activeAndSuspendedCanArchive() {
            assertThat(WorldStatus.ACTIVE.canArchive()).isTrue();
            assertThat(WorldStatus.SUSPENDED.canArchive()).isTrue();
        }
    }
}

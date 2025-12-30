package com.ffl.playoffs.domain.model.world;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("WorldVisibility Enum Tests")
class WorldVisibilityTest {

    @Test
    @DisplayName("should have exactly three visibility levels")
    void shouldHaveExactlyThreeVisibilityLevels() {
        assertThat(WorldVisibility.values()).hasSize(3);
    }

    @Test
    @DisplayName("should have correct codes")
    void shouldHaveCorrectCodes() {
        assertThat(WorldVisibility.PRIVATE.getCode()).isEqualTo("private");
        assertThat(WorldVisibility.INVITE_ONLY.getCode()).isEqualTo("invite_only");
        assertThat(WorldVisibility.PUBLIC.getCode()).isEqualTo("public");
    }

    @Test
    @DisplayName("should resolve from code")
    void shouldResolveFromCode() {
        assertThat(WorldVisibility.fromCode("private")).isEqualTo(WorldVisibility.PRIVATE);
        assertThat(WorldVisibility.fromCode("invite_only")).isEqualTo(WorldVisibility.INVITE_ONLY);
        assertThat(WorldVisibility.fromCode("public")).isEqualTo(WorldVisibility.PUBLIC);
    }

    @Test
    @DisplayName("should resolve from code case insensitively")
    void shouldResolveFromCodeCaseInsensitively() {
        assertThat(WorldVisibility.fromCode("PRIVATE")).isEqualTo(WorldVisibility.PRIVATE);
        assertThat(WorldVisibility.fromCode("Public")).isEqualTo(WorldVisibility.PUBLIC);
    }

    @Test
    @DisplayName("should throw exception for unknown code")
    void shouldThrowExceptionForUnknownCode() {
        assertThatThrownBy(() -> WorldVisibility.fromCode("unknown"))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Unknown world visibility code");
    }

    @Nested
    @DisplayName("isPubliclyVisible tests")
    class IsPubliclyVisibleTests {

        @Test
        @DisplayName("INVITE_ONLY and PUBLIC should be publicly visible")
        void inviteOnlyAndPublicShouldBePubliclyVisible() {
            assertThat(WorldVisibility.INVITE_ONLY.isPubliclyVisible()).isTrue();
            assertThat(WorldVisibility.PUBLIC.isPubliclyVisible()).isTrue();
        }

        @Test
        @DisplayName("PRIVATE should not be publicly visible")
        void privateShouldNotBePubliclyVisible() {
            assertThat(WorldVisibility.PRIVATE.isPubliclyVisible()).isFalse();
        }
    }

    @Nested
    @DisplayName("requiresInvitation tests")
    class RequiresInvitationTests {

        @Test
        @DisplayName("PRIVATE and INVITE_ONLY should require invitation")
        void privateAndInviteOnlyShouldRequireInvitation() {
            assertThat(WorldVisibility.PRIVATE.requiresInvitation()).isTrue();
            assertThat(WorldVisibility.INVITE_ONLY.requiresInvitation()).isTrue();
        }

        @Test
        @DisplayName("PUBLIC should not require invitation")
        void publicShouldNotRequireInvitation() {
            assertThat(WorldVisibility.PUBLIC.requiresInvitation()).isFalse();
        }
    }
}

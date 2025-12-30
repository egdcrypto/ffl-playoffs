package com.ffl.playoffs.domain.model.character;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("TeamBranding Value Object Tests")
class TeamBrandingTest {

    @Test
    @DisplayName("should create branding with builder")
    void shouldCreateBrandingWithBuilder() {
        TeamBranding branding = TeamBranding.builder()
                .teamName("The Champions")
                .teamSlogan("Always winning")
                .avatarUrl("https://example.com/avatar.png")
                .primaryColor("#FF5733")
                .secondaryColor("#33FF57")
                .build();

        assertThat(branding.getTeamName()).isEqualTo("The Champions");
        assertThat(branding.getTeamSlogan()).isEqualTo("Always winning");
        assertThat(branding.getAvatarUrl()).isEqualTo("https://example.com/avatar.png");
        assertThat(branding.getPrimaryColor()).isEqualTo("#FF5733");
        assertThat(branding.getSecondaryColor()).isEqualTo("#33FF57");
    }

    @Test
    @DisplayName("should create default branding")
    void shouldCreateDefaultBranding() {
        TeamBranding branding = TeamBranding.defaultBranding("My Team");

        assertThat(branding.getTeamName()).isEqualTo("My Team");
        assertThat(branding.getPrimaryColor()).isEqualTo("#1E88E5");
        assertThat(branding.getSecondaryColor()).isEqualTo("#FFC107");
    }

    @Test
    @DisplayName("should update team name")
    void shouldUpdateTeamName() {
        TeamBranding original = TeamBranding.defaultBranding("Old Name");
        TeamBranding updated = original.withTeamName("New Name");

        assertThat(updated.getTeamName()).isEqualTo("New Name");
        assertThat(original.getTeamName()).isEqualTo("Old Name"); // Immutable
    }

    @Test
    @DisplayName("should update slogan")
    void shouldUpdateSlogan() {
        TeamBranding original = TeamBranding.defaultBranding("Team");
        TeamBranding updated = original.withSlogan("New Slogan");

        assertThat(updated.getTeamSlogan()).isEqualTo("New Slogan");
    }

    @Test
    @DisplayName("should update colors")
    void shouldUpdateColors() {
        TeamBranding original = TeamBranding.defaultBranding("Team");
        TeamBranding updated = original.withColors("#000000", "#FFFFFF");

        assertThat(updated.getPrimaryColor()).isEqualTo("#000000");
        assertThat(updated.getSecondaryColor()).isEqualTo("#FFFFFF");
    }

    @Test
    @DisplayName("should throw for null team name")
    void shouldThrowForNullTeamName() {
        assertThatThrownBy(() -> TeamBranding.builder().teamName(null).build())
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("required");
    }

    @Test
    @DisplayName("should throw for blank team name")
    void shouldThrowForBlankTeamName() {
        assertThatThrownBy(() -> TeamBranding.builder().teamName("   ").build())
                .isInstanceOf(IllegalArgumentException.class);
    }

    @Test
    @DisplayName("should throw for too long team name")
    void shouldThrowForTooLongTeamName() {
        String longName = "A".repeat(51);
        assertThatThrownBy(() -> TeamBranding.builder().teamName(longName).build())
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("50 characters");
    }

    @Test
    @DisplayName("should throw for invalid color format")
    void shouldThrowForInvalidColorFormat() {
        assertThatThrownBy(() -> TeamBranding.builder()
                .teamName("Team")
                .primaryColor("red")
                .build())
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("valid hex color");
    }

    @Test
    @DisplayName("should implement equals correctly")
    void shouldImplementEqualsCorrectly() {
        TeamBranding branding1 = TeamBranding.builder()
                .teamName("Team")
                .primaryColor("#FF0000")
                .secondaryColor("#00FF00")
                .build();

        TeamBranding branding2 = TeamBranding.builder()
                .teamName("Team")
                .primaryColor("#FF0000")
                .secondaryColor("#00FF00")
                .build();

        TeamBranding branding3 = TeamBranding.builder()
                .teamName("Different")
                .primaryColor("#FF0000")
                .secondaryColor("#00FF00")
                .build();

        assertThat(branding1).isEqualTo(branding2);
        assertThat(branding1).isNotEqualTo(branding3);
    }
}

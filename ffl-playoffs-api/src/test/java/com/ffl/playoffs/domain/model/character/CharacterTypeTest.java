package com.ffl.playoffs.domain.model.character;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("CharacterType Enum Tests")
class CharacterTypeTest {

    @Test
    @DisplayName("should have correct code and display name")
    void shouldHaveCorrectCodeAndDisplayName() {
        assertThat(CharacterType.ROOKIE.getCode()).isEqualTo("rookie");
        assertThat(CharacterType.ROOKIE.getDisplayName()).isEqualTo("Rookie");

        assertThat(CharacterType.ELITE.getCode()).isEqualTo("elite");
        assertThat(CharacterType.ELITE.getDisplayName()).isEqualTo("Elite");
    }

    @Test
    @DisplayName("should return correct type for level")
    void shouldReturnCorrectTypeForLevel() {
        assertThat(CharacterType.forLevel(0)).isEqualTo(CharacterType.ROOKIE);
        assertThat(CharacterType.forLevel(5)).isEqualTo(CharacterType.ROOKIE);
        assertThat(CharacterType.forLevel(10)).isEqualTo(CharacterType.STANDARD);
        assertThat(CharacterType.forLevel(49)).isEqualTo(CharacterType.STANDARD);
        assertThat(CharacterType.forLevel(50)).isEqualTo(CharacterType.PRO);
        assertThat(CharacterType.forLevel(99)).isEqualTo(CharacterType.PRO);
        assertThat(CharacterType.forLevel(100)).isEqualTo(CharacterType.ELITE);
        assertThat(CharacterType.forLevel(199)).isEqualTo(CharacterType.ELITE);
        assertThat(CharacterType.forLevel(200)).isEqualTo(CharacterType.LEGEND);
        assertThat(CharacterType.forLevel(500)).isEqualTo(CharacterType.LEGEND);
    }

    @Test
    @DisplayName("should correctly check upgrade eligibility")
    void shouldCorrectlyCheckUpgradeEligibility() {
        assertThat(CharacterType.ROOKIE.canUpgradeTo(CharacterType.STANDARD)).isTrue();
        assertThat(CharacterType.ROOKIE.canUpgradeTo(CharacterType.LEGEND)).isTrue();
        assertThat(CharacterType.LEGEND.canUpgradeTo(CharacterType.ROOKIE)).isFalse();
        assertThat(CharacterType.PRO.canUpgradeTo(CharacterType.PRO)).isFalse();
    }

    @Test
    @DisplayName("should have correct required levels")
    void shouldHaveCorrectRequiredLevels() {
        assertThat(CharacterType.ROOKIE.getRequiredLevel()).isEqualTo(0);
        assertThat(CharacterType.STANDARD.getRequiredLevel()).isEqualTo(10);
        assertThat(CharacterType.PRO.getRequiredLevel()).isEqualTo(50);
        assertThat(CharacterType.ELITE.getRequiredLevel()).isEqualTo(100);
        assertThat(CharacterType.LEGEND.getRequiredLevel()).isEqualTo(200);
    }
}

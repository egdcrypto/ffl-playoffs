package com.ffl.playoffs.domain.model.character;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("Character Tests")
class CharacterTest {

    private UUID userId;
    private UUID leagueId;

    @BeforeEach
    void setUp() {
        userId = UUID.randomUUID();
        leagueId = UUID.randomUUID();
    }

    @Nested
    @DisplayName("create tests")
    class CreateTests {

        @Test
        @DisplayName("should create character with valid parameters")
        void shouldCreateCharacterWithValidParameters() {
            Character character = Character.create(userId, leagueId, "Test Character");

            assertThat(character.getId()).isNotNull();
            assertThat(character.getUserId()).isEqualTo(userId);
            assertThat(character.getLeagueId()).isEqualTo(leagueId);
            assertThat(character.getName()).isEqualTo("Test Character");
            assertThat(character.getStatus()).isEqualTo(CharacterStatus.DRAFT);
            assertThat(character.getTotalScore()).isEqualTo(0.0);
            assertThat(character.getCreatedAt()).isNotNull();
            assertThat(character.getUpdatedAt()).isNotNull();
        }

        @Test
        @DisplayName("should trim character name")
        void shouldTrimCharacterName() {
            Character character = Character.create(userId, leagueId, "  Test Character  ");
            assertThat(character.getName()).isEqualTo("Test Character");
        }

        @Test
        @DisplayName("should throw exception for null userId")
        void shouldThrowExceptionForNullUserId() {
            assertThatThrownBy(() -> Character.create(null, leagueId, "Test"))
                    .isInstanceOf(NullPointerException.class);
        }

        @Test
        @DisplayName("should throw exception for null leagueId")
        void shouldThrowExceptionForNullLeagueId() {
            assertThatThrownBy(() -> Character.create(userId, null, "Test"))
                    .isInstanceOf(NullPointerException.class);
        }

        @Test
        @DisplayName("should throw exception for blank name")
        void shouldThrowExceptionForBlankName() {
            assertThatThrownBy(() -> Character.create(userId, leagueId, "   "))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Name cannot be blank");
        }

        @Test
        @DisplayName("should throw exception for null name")
        void shouldThrowExceptionForNullName() {
            assertThatThrownBy(() -> Character.create(userId, leagueId, null))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Name cannot be blank");
        }
    }

    @Nested
    @DisplayName("activate tests")
    class ActivateTests {

        @Test
        @DisplayName("should activate draft character")
        void shouldActivateDraftCharacter() {
            Character character = Character.create(userId, leagueId, "Test");

            character.activate();

            assertThat(character.getStatus()).isEqualTo(CharacterStatus.ACTIVE);
            assertThat(character.getActivatedAt()).isNotNull();
        }

        @Test
        @DisplayName("should throw exception when activating active character")
        void shouldThrowExceptionWhenActivatingActiveCharacter() {
            Character character = Character.create(userId, leagueId, "Test");
            character.activate();

            assertThatThrownBy(() -> character.activate())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot activate character");
        }

        @Test
        @DisplayName("should throw exception when activating eliminated character")
        void shouldThrowExceptionWhenActivatingEliminatedCharacter() {
            Character character = Character.create(userId, leagueId, "Test");
            character.activate();
            character.eliminate(1, 10);

            assertThatThrownBy(() -> character.activate())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot activate character");
        }
    }

    @Nested
    @DisplayName("eliminate tests")
    class EliminateTests {

        @Test
        @DisplayName("should eliminate active character")
        void shouldEliminateActiveCharacter() {
            Character character = Character.create(userId, leagueId, "Test");
            character.activate();
            character.addScore(100.0);

            character.eliminate(3, 10, "Low score");

            assertThat(character.getStatus()).isEqualTo(CharacterStatus.ELIMINATED);
            assertThat(character.getEliminationWeek()).isEqualTo(3);
            assertThat(character.getEliminationRank()).isEqualTo(10);
            assertThat(character.getEliminationScore()).isEqualTo(100.0);
            assertThat(character.getEliminationReason()).isEqualTo("Low score");
            assertThat(character.getEliminatedAt()).isNotNull();
        }

        @Test
        @DisplayName("should eliminate with default reason")
        void shouldEliminateWithDefaultReason() {
            Character character = Character.create(userId, leagueId, "Test");
            character.activate();

            character.eliminate(2, 8);

            assertThat(character.getEliminationReason()).contains("Lowest score in week 2");
        }

        @Test
        @DisplayName("should throw exception when eliminating draft character")
        void shouldThrowExceptionWhenEliminatingDraftCharacter() {
            Character character = Character.create(userId, leagueId, "Test");

            assertThatThrownBy(() -> character.eliminate(1, 10))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot eliminate character");
        }

        @Test
        @DisplayName("should throw exception when eliminating already eliminated character")
        void shouldThrowExceptionWhenEliminatingAlreadyEliminatedCharacter() {
            Character character = Character.create(userId, leagueId, "Test");
            character.activate();
            character.eliminate(1, 10);

            assertThatThrownBy(() -> character.eliminate(2, 5))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot eliminate character");
        }
    }

    @Nested
    @DisplayName("score tests")
    class ScoreTests {

        @Test
        @DisplayName("should add score to active character")
        void shouldAddScoreToActiveCharacter() {
            Character character = Character.create(userId, leagueId, "Test");
            character.activate();

            character.addScore(50.5);
            character.addScore(30.0);

            assertThat(character.getTotalScore()).isEqualTo(80.5);
        }

        @Test
        @DisplayName("should throw exception when adding score to draft character")
        void shouldThrowExceptionWhenAddingScoreToDraftCharacter() {
            Character character = Character.create(userId, leagueId, "Test");

            assertThatThrownBy(() -> character.addScore(50.0))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot add score");
        }

        @Test
        @DisplayName("should throw exception when adding score to eliminated character")
        void shouldThrowExceptionWhenAddingScoreToEliminatedCharacter() {
            Character character = Character.create(userId, leagueId, "Test");
            character.activate();
            character.eliminate(1, 10);

            assertThatThrownBy(() -> character.addScore(50.0))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot add score");
        }

        @Test
        @DisplayName("should throw exception for negative score")
        void shouldThrowExceptionForNegativeScore() {
            Character character = Character.create(userId, leagueId, "Test");
            character.activate();

            assertThatThrownBy(() -> character.addScore(-10.0))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("non-negative");
        }
    }

    @Nested
    @DisplayName("rank tests")
    class RankTests {

        @Test
        @DisplayName("should update weekly rank")
        void shouldUpdateWeeklyRank() {
            Character character = Character.create(userId, leagueId, "Test");

            character.updateWeeklyRank(5);

            assertThat(character.getWeeklyRank()).isEqualTo(5);
        }

        @Test
        @DisplayName("should update overall rank")
        void shouldUpdateOverallRank() {
            Character character = Character.create(userId, leagueId, "Test");

            character.updateOverallRank(3);

            assertThat(character.getOverallRank()).isEqualTo(3);
        }
    }

    @Nested
    @DisplayName("name update tests")
    class NameUpdateTests {

        @Test
        @DisplayName("should update name in draft status")
        void shouldUpdateNameInDraftStatus() {
            Character character = Character.create(userId, leagueId, "Original");

            character.updateName("Updated");

            assertThat(character.getName()).isEqualTo("Updated");
        }

        @Test
        @DisplayName("should throw exception when updating name after draft")
        void shouldThrowExceptionWhenUpdatingNameAfterDraft() {
            Character character = Character.create(userId, leagueId, "Original");
            character.activate();

            assertThatThrownBy(() -> character.updateName("Updated"))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot change name");
        }

        @Test
        @DisplayName("should throw exception for blank name update")
        void shouldThrowExceptionForBlankNameUpdate() {
            Character character = Character.create(userId, leagueId, "Original");

            assertThatThrownBy(() -> character.updateName("   "))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Name cannot be blank");
        }
    }

    @Nested
    @DisplayName("status check tests")
    class StatusCheckTests {

        @Test
        @DisplayName("isDraft should return true for draft character")
        void isDraftShouldReturnTrueForDraftCharacter() {
            Character character = Character.create(userId, leagueId, "Test");
            assertThat(character.isDraft()).isTrue();
            assertThat(character.isActive()).isFalse();
            assertThat(character.isEliminated()).isFalse();
        }

        @Test
        @DisplayName("isActive should return true for active character")
        void isActiveShouldReturnTrueForActiveCharacter() {
            Character character = Character.create(userId, leagueId, "Test");
            character.activate();
            assertThat(character.isDraft()).isFalse();
            assertThat(character.isActive()).isTrue();
            assertThat(character.isEliminated()).isFalse();
        }

        @Test
        @DisplayName("isEliminated should return true for eliminated character")
        void isEliminatedShouldReturnTrueForEliminatedCharacter() {
            Character character = Character.create(userId, leagueId, "Test");
            character.activate();
            character.eliminate(1, 10);
            assertThat(character.isDraft()).isFalse();
            assertThat(character.isActive()).isFalse();
            assertThat(character.isEliminated()).isTrue();
        }

        @Test
        @DisplayName("isInCompetition should return correct value")
        void isInCompetitionShouldReturnCorrectValue() {
            Character character = Character.create(userId, leagueId, "Test");
            assertThat(character.isInCompetition()).isTrue();

            character.activate();
            assertThat(character.isInCompetition()).isTrue();

            character.eliminate(1, 10);
            assertThat(character.isInCompetition()).isFalse();
        }

        @Test
        @DisplayName("canMakeSelections should return correct value")
        void canMakeSelectionsShouldReturnCorrectValue() {
            Character character = Character.create(userId, leagueId, "Test");
            assertThat(character.canMakeSelections()).isFalse();

            character.activate();
            assertThat(character.canMakeSelections()).isTrue();

            character.eliminate(1, 10);
            assertThat(character.canMakeSelections()).isFalse();
        }
    }

    @Nested
    @DisplayName("ownership tests")
    class OwnershipTests {

        @Test
        @DisplayName("belongsTo should return true for owner")
        void belongsToShouldReturnTrueForOwner() {
            Character character = Character.create(userId, leagueId, "Test");
            assertThat(character.belongsTo(userId)).isTrue();
        }

        @Test
        @DisplayName("belongsTo should return false for non-owner")
        void belongsToShouldReturnFalseForNonOwner() {
            Character character = Character.create(userId, leagueId, "Test");
            assertThat(character.belongsTo(UUID.randomUUID())).isFalse();
        }

        @Test
        @DisplayName("isInLeague should return true for correct league")
        void isInLeagueShouldReturnTrueForCorrectLeague() {
            Character character = Character.create(userId, leagueId, "Test");
            assertThat(character.isInLeague(leagueId)).isTrue();
        }

        @Test
        @DisplayName("isInLeague should return false for wrong league")
        void isInLeagueShouldReturnFalseForWrongLeague() {
            Character character = Character.create(userId, leagueId, "Test");
            assertThat(character.isInLeague(UUID.randomUUID())).isFalse();
        }
    }

    @Nested
    @DisplayName("display tests")
    class DisplayTests {

        @Test
        @DisplayName("getStatusDisplay should show correct text for each status")
        void getStatusDisplayShouldShowCorrectText() {
            Character character = Character.create(userId, leagueId, "Test");
            assertThat(character.getStatusDisplay()).contains("Preparing");

            character.activate();
            character.updateOverallRank(5);
            assertThat(character.getStatusDisplay()).contains("In Competition").contains("Rank #5");

            character.eliminate(3, 10);
            assertThat(character.getStatusDisplay()).contains("Eliminated").contains("Week 3").contains("Rank #10");
        }
    }

    @Nested
    @DisplayName("avatar tests")
    class AvatarTests {

        @Test
        @DisplayName("should update avatar")
        void shouldUpdateAvatar() {
            Character character = Character.create(userId, leagueId, "Test");

            character.updateAvatar("https://example.com/avatar.png");

            assertThat(character.getAvatarUrl()).isEqualTo("https://example.com/avatar.png");
        }
    }
}

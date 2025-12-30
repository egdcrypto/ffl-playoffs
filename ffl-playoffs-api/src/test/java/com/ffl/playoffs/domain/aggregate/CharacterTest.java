package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.character.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("Character Aggregate Tests")
class CharacterTest {

    private UUID userId;
    private UUID leagueId;

    @BeforeEach
    void setUp() {
        userId = UUID.randomUUID();
        leagueId = UUID.randomUUID();
    }

    @Nested
    @DisplayName("Creation Tests")
    class CreationTests {

        @Test
        @DisplayName("should create character with required fields")
        void shouldCreateCharacterWithRequiredFields() {
            Character character = new Character(userId, leagueId, "The Champions");

            assertThat(character.getId()).isNotNull();
            assertThat(character.getUserId()).isEqualTo(userId);
            assertThat(character.getLeagueId()).isEqualTo(leagueId);
            assertThat(character.getTeamName()).isEqualTo("The Champions");
            assertThat(character.getType()).isEqualTo(CharacterType.ROOKIE);
            assertThat(character.getLevel()).isEqualTo(1);
            assertThat(character.getExperiencePoints()).isGreaterThan(0); // From first league achievement
            assertThat(character.getCreatedAt()).isNotNull();
        }

        @Test
        @DisplayName("should award first league achievement on creation")
        void shouldAwardFirstLeagueAchievementOnCreation() {
            Character character = new Character(userId, leagueId, "Team");

            assertThat(character.hasAchievement(AchievementType.FIRST_LEAGUE)).isTrue();
            assertThat(character.getAchievementCount()).isEqualTo(1);
        }

        @Test
        @DisplayName("should throw for null user ID")
        void shouldThrowForNullUserId() {
            assertThatThrownBy(() -> new Character(null, leagueId, "Team"))
                    .isInstanceOf(NullPointerException.class);
        }

        @Test
        @DisplayName("should throw for null league ID")
        void shouldThrowForNullLeagueId() {
            assertThatThrownBy(() -> new Character(userId, null, "Team"))
                    .isInstanceOf(NullPointerException.class);
        }
    }

    @Nested
    @DisplayName("Branding Tests")
    class BrandingTests {

        @Test
        @DisplayName("should update team name")
        void shouldUpdateTeamName() {
            Character character = new Character(userId, leagueId, "Old Name");

            character.updateTeamName("New Name");

            assertThat(character.getTeamName()).isEqualTo("New Name");
        }

        @Test
        @DisplayName("should update slogan")
        void shouldUpdateSlogan() {
            Character character = new Character(userId, leagueId, "Team");

            character.updateSlogan("Victory awaits!");

            assertThat(character.getBranding().getTeamSlogan()).isEqualTo("Victory awaits!");
        }

        @Test
        @DisplayName("should update colors")
        void shouldUpdateColors() {
            Character character = new Character(userId, leagueId, "Team");

            character.updateColors("#000000", "#FFFFFF");

            assertThat(character.getBranding().getPrimaryColor()).isEqualTo("#000000");
            assertThat(character.getBranding().getSecondaryColor()).isEqualTo("#FFFFFF");
        }

        @Test
        @DisplayName("should update avatar")
        void shouldUpdateAvatar() {
            Character character = new Character(userId, leagueId, "Team");

            character.updateAvatar("https://example.com/avatar.png");

            assertThat(character.getBranding().getAvatarUrl()).isEqualTo("https://example.com/avatar.png");
        }
    }

    @Nested
    @DisplayName("Progression Tests")
    class ProgressionTests {

        @Test
        @DisplayName("should gain experience")
        void shouldGainExperience() {
            Character character = new Character(userId, leagueId, "Team");
            int initialXp = character.getExperiencePoints();

            character.gainExperience(50);

            assertThat(character.getExperiencePoints()).isEqualTo(initialXp + 50);
        }

        @Test
        @DisplayName("should level up when reaching XP threshold")
        void shouldLevelUpWhenReachingXpThreshold() {
            Character character = new Character(userId, leagueId, "Team");
            character.setLevel(1);
            character.setExperiencePoints(0);

            character.gainExperience(100); // Level 1 requires 100 XP

            assertThat(character.getLevel()).isEqualTo(2);
        }

        @Test
        @DisplayName("should upgrade character type at level milestones")
        void shouldUpgradeCharacterTypeAtLevelMilestones() {
            Character character = new Character(userId, leagueId, "Team");
            character.setLevel(9);
            character.setExperiencePoints(800);

            character.gainExperience(200); // Should reach level 10

            assertThat(character.getLevel()).isGreaterThanOrEqualTo(10);
            assertThat(character.getType()).isEqualTo(CharacterType.STANDARD);
        }

        @Test
        @DisplayName("should not gain negative experience")
        void shouldNotGainNegativeExperience() {
            Character character = new Character(userId, leagueId, "Team");
            int initialXp = character.getExperiencePoints();

            character.gainExperience(-50);

            assertThat(character.getExperiencePoints()).isEqualTo(initialXp);
        }
    }

    @Nested
    @DisplayName("Achievement Tests")
    class AchievementTests {

        @Test
        @DisplayName("should award achievement")
        void shouldAwardAchievement() {
            Character character = new Character(userId, leagueId, "Team");

            Optional<Achievement> awarded = character.awardAchievement(AchievementType.FIRST_WIN);

            assertThat(awarded).isPresent();
            assertThat(character.hasAchievement(AchievementType.FIRST_WIN)).isTrue();
        }

        @Test
        @DisplayName("should not duplicate one-time achievement")
        void shouldNotDuplicateOneTimeAchievement() {
            Character character = new Character(userId, leagueId, "Team");

            // First league achievement already awarded
            Optional<Achievement> duplicate = character.awardAchievement(AchievementType.FIRST_LEAGUE);

            assertThat(duplicate).isEmpty();
            assertThat(character.getAchievementCount()).isEqualTo(1);
        }

        @Test
        @DisplayName("should increment repeatable achievement count")
        void shouldIncrementRepeatableAchievementCount() {
            Character character = new Character(userId, leagueId, "Team");

            character.awardAchievement(AchievementType.SEASON_CHAMPION);
            Optional<Achievement> second = character.awardAchievement(AchievementType.SEASON_CHAMPION);

            assertThat(second).isPresent();
            assertThat(second.get().getCount()).isEqualTo(2);
        }

        @Test
        @DisplayName("should award achievement with context")
        void shouldAwardAchievementWithContext() {
            Character character = new Character(userId, leagueId, "Team");

            Optional<Achievement> awarded = character.awardAchievement(
                    AchievementType.SEASON_CHAMPION, "Season 2024");

            assertThat(awarded).isPresent();
            assertThat(awarded.get().getContext()).isEqualTo("Season 2024");
        }
    }

    @Nested
    @DisplayName("Statistics Tests")
    class StatisticsTests {

        @Test
        @DisplayName("should record win")
        void shouldRecordWin() {
            Character character = new Character(userId, leagueId, "Team");

            character.recordWin(150.5);

            assertThat(character.getStats().getGamesPlayed()).isEqualTo(1);
            assertThat(character.getStats().getWins()).isEqualTo(1);
            assertThat(character.getStats().getTotalPointsScored()).isEqualTo(150.5);
        }

        @Test
        @DisplayName("should award first win achievement")
        void shouldAwardFirstWinAchievement() {
            Character character = new Character(userId, leagueId, "Team");

            character.recordWin(100);

            assertThat(character.hasAchievement(AchievementType.FIRST_WIN)).isTrue();
        }

        @Test
        @DisplayName("should award streak achievement at 5 wins")
        void shouldAwardStreakAchievementAt5Wins() {
            Character character = new Character(userId, leagueId, "Team");

            for (int i = 0; i < 5; i++) {
                character.recordWin(100);
            }

            assertThat(character.hasAchievement(AchievementType.STREAK_5)).isTrue();
        }

        @Test
        @DisplayName("should record loss")
        void shouldRecordLoss() {
            Character character = new Character(userId, leagueId, "Team");

            character.recordLoss(80);

            assertThat(character.getStats().getGamesPlayed()).isEqualTo(1);
            assertThat(character.getStats().getLosses()).isEqualTo(1);
        }

        @Test
        @DisplayName("should record tie")
        void shouldRecordTie() {
            Character character = new Character(userId, leagueId, "Team");

            character.recordTie(100);

            assertThat(character.getStats().getGamesPlayed()).isEqualTo(1);
            assertThat(character.getStats().getTies()).isEqualTo(1);
        }

        @Test
        @DisplayName("should record season championship")
        void shouldRecordSeasonChampionship() {
            Character character = new Character(userId, leagueId, "Team");

            character.recordSeasonChampionship();

            assertThat(character.getStats().getSeasonWins()).isEqualTo(1);
            assertThat(character.hasAchievement(AchievementType.SEASON_CHAMPION)).isTrue();
        }

        @Test
        @DisplayName("should award dynasty achievement at 3 season wins")
        void shouldAwardDynastyAchievementAt3SeasonWins() {
            Character character = new Character(userId, leagueId, "Team");

            character.recordSeasonChampionship();
            character.recordSeasonChampionship();
            character.recordSeasonChampionship();

            assertThat(character.hasAchievement(AchievementType.DYNASTY)).isTrue();
        }
    }

    @Test
    @DisplayName("should implement equals based on ID")
    void shouldImplementEqualsBasedOnId() {
        Character character1 = new Character(userId, leagueId, "Team 1");
        Character character2 = new Character(userId, leagueId, "Team 2");

        UUID sharedId = UUID.randomUUID();
        character1.setId(sharedId);
        character2.setId(sharedId);

        assertThat(character1).isEqualTo(character2);
        assertThat(character1.hashCode()).isEqualTo(character2.hashCode());
    }
}

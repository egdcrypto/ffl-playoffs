package com.ffl.playoffs.domain.model.character;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("CharacterStats Value Object Tests")
class CharacterStatsTest {

    @Test
    @DisplayName("should create empty stats")
    void shouldCreateEmptyStats() {
        CharacterStats stats = CharacterStats.empty();

        assertThat(stats.getGamesPlayed()).isZero();
        assertThat(stats.getWins()).isZero();
        assertThat(stats.getLosses()).isZero();
        assertThat(stats.getTies()).isZero();
        assertThat(stats.getSeasonsPlayed()).isZero();
        assertThat(stats.getSeasonWins()).isZero();
        assertThat(stats.getCurrentWinStreak()).isZero();
        assertThat(stats.getBestWinStreak()).isZero();
        assertThat(stats.getTotalPointsScored()).isZero();
        assertThat(stats.getHighestWeeklyScore()).isZero();
    }

    @Test
    @DisplayName("should record win correctly")
    void shouldRecordWinCorrectly() {
        CharacterStats stats = CharacterStats.empty();

        CharacterStats afterWin = stats.recordWin(150.5);

        assertThat(afterWin.getGamesPlayed()).isEqualTo(1);
        assertThat(afterWin.getWins()).isEqualTo(1);
        assertThat(afterWin.getLosses()).isZero();
        assertThat(afterWin.getCurrentWinStreak()).isEqualTo(1);
        assertThat(afterWin.getTotalPointsScored()).isEqualTo(150.5);
        assertThat(afterWin.getHighestWeeklyScore()).isEqualTo(150.5);
    }

    @Test
    @DisplayName("should record loss and reset streak")
    void shouldRecordLossAndResetStreak() {
        CharacterStats stats = CharacterStats.empty()
                .recordWin(100)
                .recordWin(110);

        assertThat(stats.getCurrentWinStreak()).isEqualTo(2);

        CharacterStats afterLoss = stats.recordLoss(80);

        assertThat(afterLoss.getGamesPlayed()).isEqualTo(3);
        assertThat(afterLoss.getWins()).isEqualTo(2);
        assertThat(afterLoss.getLosses()).isEqualTo(1);
        assertThat(afterLoss.getCurrentWinStreak()).isZero();
        assertThat(afterLoss.getBestWinStreak()).isEqualTo(2);
    }

    @Test
    @DisplayName("should track best win streak")
    void shouldTrackBestWinStreak() {
        CharacterStats stats = CharacterStats.empty()
                .recordWin(100)
                .recordWin(100)
                .recordWin(100)
                .recordLoss(50)
                .recordWin(100)
                .recordWin(100);

        assertThat(stats.getCurrentWinStreak()).isEqualTo(2);
        assertThat(stats.getBestWinStreak()).isEqualTo(3);
    }

    @Test
    @DisplayName("should record tie correctly")
    void shouldRecordTieCorrectly() {
        CharacterStats stats = CharacterStats.empty();

        CharacterStats afterTie = stats.recordTie(100);

        assertThat(afterTie.getGamesPlayed()).isEqualTo(1);
        assertThat(afterTie.getTies()).isEqualTo(1);
        assertThat(afterTie.getWins()).isZero();
        assertThat(afterTie.getLosses()).isZero();
        assertThat(afterTie.getCurrentWinStreak()).isZero();
    }

    @Test
    @DisplayName("should record season win")
    void shouldRecordSeasonWin() {
        CharacterStats stats = CharacterStats.empty();

        CharacterStats afterSeasonWin = stats.recordSeasonWin();

        assertThat(afterSeasonWin.getSeasonsPlayed()).isEqualTo(1);
        assertThat(afterSeasonWin.getSeasonWins()).isEqualTo(1);
    }

    @Test
    @DisplayName("should record season complete without win")
    void shouldRecordSeasonCompleteWithoutWin() {
        CharacterStats stats = CharacterStats.empty();

        CharacterStats afterSeasonComplete = stats.recordSeasonComplete();

        assertThat(afterSeasonComplete.getSeasonsPlayed()).isEqualTo(1);
        assertThat(afterSeasonComplete.getSeasonWins()).isZero();
    }

    @Test
    @DisplayName("should calculate win percentage")
    void shouldCalculateWinPercentage() {
        CharacterStats stats = CharacterStats.empty()
                .recordWin(100)
                .recordWin(100)
                .recordLoss(50)
                .recordLoss(50);

        assertThat(stats.getWinPercentage()).isEqualTo(50.0);
    }

    @Test
    @DisplayName("should calculate average points per game")
    void shouldCalculateAveragePointsPerGame() {
        CharacterStats stats = CharacterStats.empty()
                .recordWin(100)
                .recordWin(150)
                .recordLoss(50);

        assertThat(stats.getAveragePointsPerGame()).isEqualTo(100.0);
    }

    @Test
    @DisplayName("should return zero win percentage for no games")
    void shouldReturnZeroWinPercentageForNoGames() {
        CharacterStats stats = CharacterStats.empty();

        assertThat(stats.getWinPercentage()).isZero();
    }

    @Test
    @DisplayName("should update highest weekly score")
    void shouldUpdateHighestWeeklyScore() {
        CharacterStats stats = CharacterStats.empty()
                .recordWin(100)
                .recordWin(200)
                .recordWin(150);

        assertThat(stats.getHighestWeeklyScore()).isEqualTo(200);
    }
}

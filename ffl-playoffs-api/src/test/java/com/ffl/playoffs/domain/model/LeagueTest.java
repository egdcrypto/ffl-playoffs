package com.ffl.playoffs.domain.model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("League Domain Entity Tests")
class LeagueTest {

    private UUID adminId;

    @BeforeEach
    void setUp() {
        adminId = UUID.randomUUID();
    }

    @Nested
    @DisplayName("Construction")
    class Construction {

        @Test
        @DisplayName("should create league with default constructor")
        void shouldCreateLeagueWithDefaultConstructor() {
            // When
            League league = new League();

            // Then
            assertThat(league.getId()).isNotNull();
            assertThat(league.getStatus()).isEqualTo(League.LeagueStatus.CREATED);
            assertThat(league.getConfigurationLocked()).isFalse();
            assertThat(league.getCreatedAt()).isNotNull();
            assertThat(league.getUpdatedAt()).isNotNull();
            assertThat(league.getPlayers()).isNotNull().isEmpty();
        }

        @Test
        @DisplayName("should create league with all required parameters")
        void shouldCreateLeagueWithAllRequiredParameters() {
            // Given
            String name = "Championship League";
            String code = "CHAMP2024";
            int startingWeek = 15;
            int numberOfWeeks = 4;

            // When
            League league = new League(name, code, adminId, startingWeek, numberOfWeeks);

            // Then
            assertThat(league.getName()).isEqualTo(name);
            assertThat(league.getCode()).isEqualTo(code);
            assertThat(league.getOwnerId()).isEqualTo(adminId);
            assertThat(league.getStartingWeek()).isEqualTo(startingWeek);
            assertThat(league.getNumberOfWeeks()).isEqualTo(numberOfWeeks);
            assertThat(league.getCurrentWeek()).isEqualTo(startingWeek);
            assertThat(league.getEndingWeek()).isEqualTo(18); // 15 + 4 - 1
        }
    }

    @Nested
    @DisplayName("Week Validation")
    class WeekValidation {

        @Test
        @DisplayName("should accept valid week configuration")
        void shouldAcceptValidWeekConfiguration() {
            // When/Then - no exception
            assertThatCode(() ->
                new League("Test", "TEST", adminId, 1, 17)
            ).doesNotThrowAnyException();
        }

        @Test
        @DisplayName("should accept playoff weeks (15-18)")
        void shouldAcceptPlayoffWeeks() {
            // When
            League league = new League("Playoffs", "PLAYOFF", adminId, 15, 4);

            // Then
            assertThat(league.getStartingWeek()).isEqualTo(15);
            assertThat(league.getEndingWeek()).isEqualTo(18);
        }

        @Test
        @DisplayName("should reject starting week less than 1")
        void shouldRejectStartingWeekLessThan1() {
            // When/Then
            assertThatThrownBy(() ->
                new League("Test", "TEST", adminId, 0, 4)
            )
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessageContaining("Starting week must be between 1 and 22");
        }

        @Test
        @DisplayName("should reject starting week greater than 22")
        void shouldRejectStartingWeekGreaterThan22() {
            // When/Then
            assertThatThrownBy(() ->
                new League("Test", "TEST", adminId, 23, 1)
            )
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessageContaining("Starting week must be between 1 and 22");
        }

        @Test
        @DisplayName("should reject number of weeks less than 1")
        void shouldRejectNumberOfWeeksLessThan1() {
            // When/Then
            assertThatThrownBy(() ->
                new League("Test", "TEST", adminId, 10, 0)
            )
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessageContaining("Number of weeks must be between 1 and 17");
        }

        @Test
        @DisplayName("should reject number of weeks greater than 17")
        void shouldRejectNumberOfWeeksGreaterThan17() {
            // When/Then
            assertThatThrownBy(() ->
                new League("Test", "TEST", adminId, 1, 18)
            )
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessageContaining("Number of weeks must be between 1 and 17");
        }

        @Test
        @DisplayName("should reject configuration that exceeds NFL season (week 22)")
        void shouldRejectConfigurationThatExceedsNFLSeason() {
            // When/Then
            assertThatThrownBy(() ->
                new League("Test", "TEST", adminId, 18, 6)
            )
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessageContaining("exceeds NFL calendar")
            .hasMessageContaining("would end at week 23");
        }

        @Test
        @DisplayName("should accept league ending exactly at week 22")
        void shouldAcceptLeagueEndingExactlyAtWeek22() {
            // When
            League league = new League("Full Season", "FULL", adminId, 6, 17);

            // Then
            assertThat(league.getEndingWeek()).isEqualTo(22);
        }

        @Test
        @DisplayName("should reject null starting week")
        void shouldRejectNullStartingWeek() {
            // When/Then
            assertThatThrownBy(() ->
                new League("Test", "TEST", adminId, null, 4)
            )
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessageContaining("cannot be null");
        }

        @Test
        @DisplayName("should reject null number of weeks")
        void shouldRejectNullNumberOfWeeks() {
            // When/Then
            assertThatThrownBy(() ->
                new League("Test", "TEST", adminId, 10, null)
            )
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessageContaining("cannot be null");
        }
    }

    @Nested
    @DisplayName("Configuration Locking")
    class ConfigurationLocking {

        private League league;

        @BeforeEach
        void setUp() {
            league = new League("Test", "TEST", adminId, 15, 4);
        }

        @Test
        @DisplayName("should not be locked initially")
        void shouldNotBeLockedInitially() {
            // When
            boolean isLocked = league.isConfigurationLocked(LocalDateTime.now());

            // Then
            assertThat(isLocked).isFalse();
        }

        @Test
        @DisplayName("should lock configuration when lockConfiguration is called")
        void shouldLockConfigurationWhenCalled() {
            // Given
            LocalDateTime lockTime = LocalDateTime.now();

            // When
            league.lockConfiguration(lockTime, "FIRST_GAME_STARTED");

            // Then
            assertThat(league.isConfigurationLocked(LocalDateTime.now())).isTrue();
            assertThat(league.getConfigurationLockedAt()).isEqualTo(lockTime);
            assertThat(league.getLockReason()).isEqualTo("FIRST_GAME_STARTED");
        }

        @Test
        @DisplayName("should be locked when current time is after first game start")
        void shouldBeLockedWhenAfterFirstGameStart() {
            // Given
            LocalDateTime firstGameTime = LocalDateTime.now().minusHours(1);
            league.setFirstGameStartTime(firstGameTime);

            // When
            boolean isLocked = league.isConfigurationLocked(LocalDateTime.now());

            // Then
            assertThat(isLocked).isTrue();
        }

        @Test
        @DisplayName("should not be locked when current time is before first game start")
        void shouldNotBeLockedWhenBeforeFirstGameStart() {
            // Given
            LocalDateTime firstGameTime = LocalDateTime.now().plusHours(1);
            league.setFirstGameStartTime(firstGameTime);

            // When
            boolean isLocked = league.isConfigurationLocked(LocalDateTime.now());

            // Then
            assertThat(isLocked).isFalse();
        }

        @Test
        @DisplayName("should ignore subsequent lock calls once locked")
        void shouldIgnoreSubsequentLockCallsOnceLocked() {
            // Given
            LocalDateTime firstLockTime = LocalDateTime.now().minusMinutes(10);
            league.lockConfiguration(firstLockTime, "FIRST_REASON");

            // When
            LocalDateTime secondLockTime = LocalDateTime.now();
            league.lockConfiguration(secondLockTime, "SECOND_REASON");

            // Then
            assertThat(league.getConfigurationLockedAt()).isEqualTo(firstLockTime);
            assertThat(league.getLockReason()).isEqualTo("FIRST_REASON");
        }

        @Test
        @DisplayName("should throw exception when modifying name after lock")
        void shouldThrowExceptionWhenModifyingNameAfterLock() {
            // Given
            league.lockConfiguration(LocalDateTime.now(), "LOCKED");

            // When/Then
            assertThatThrownBy(() ->
                league.setName("New Name", LocalDateTime.now())
            )
            .isInstanceOf(League.ConfigurationLockedException.class)
            .hasMessageContaining("Configuration cannot be modified");
        }

        @Test
        @DisplayName("should throw exception when modifying description after lock")
        void shouldThrowExceptionWhenModifyingDescriptionAfterLock() {
            // Given
            league.lockConfiguration(LocalDateTime.now(), "LOCKED");

            // When/Then
            assertThatThrownBy(() ->
                league.setDescription("New Description", LocalDateTime.now())
            )
            .isInstanceOf(League.ConfigurationLockedException.class);
        }

        @Test
        @DisplayName("should throw exception when modifying starting week after lock")
        void shouldThrowExceptionWhenModifyingStartingWeekAfterLock() {
            // Given
            league.lockConfiguration(LocalDateTime.now(), "LOCKED");

            // When/Then
            assertThatThrownBy(() ->
                league.setStartingWeek(10, LocalDateTime.now())
            )
            .isInstanceOf(League.ConfigurationLockedException.class);
        }

        @Test
        @DisplayName("should allow modification before lock")
        void shouldAllowModificationBeforeLock() {
            // When/Then
            assertThatCode(() -> {
                league.setName("New Name", LocalDateTime.now());
                league.setDescription("New Description", LocalDateTime.now());
            }).doesNotThrowAnyException();
        }
    }

    @Nested
    @DisplayName("Player Management")
    class PlayerManagement {

        private League league;
        private Player player;

        @BeforeEach
        void setUp() {
            league = new League("Test", "TEST", adminId, 15, 4);
            player = new Player();
        }

        @Test
        @DisplayName("should add player to league")
        void shouldAddPlayerToLeague() {
            // When
            league.addPlayer(player);

            // Then
            assertThat(league.getPlayers()).hasSize(1);
            assertThat(league.getPlayers()).contains(player);
        }

        @Test
        @DisplayName("should add multiple players")
        void shouldAddMultiplePlayers() {
            // Given
            Player player2 = new Player();

            // When
            league.addPlayer(player);
            league.addPlayer(player2);

            // Then
            assertThat(league.getPlayers()).hasSize(2);
        }

        @Test
        @DisplayName("should throw exception when adding player to active league")
        void shouldThrowExceptionWhenAddingPlayerToActiveLeague() {
            // Given
            league.setStatus(League.LeagueStatus.ACTIVE);

            // When/Then
            assertThatThrownBy(() -> league.addPlayer(player))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("Cannot add players to a league that has started");
        }

        @Test
        @DisplayName("should allow adding player to WAITING_FOR_PLAYERS league")
        void shouldAllowAddingPlayerToWaitingForPlayersLeague() {
            // Given
            league.setStatus(League.LeagueStatus.WAITING_FOR_PLAYERS);

            // When/Then
            assertThatCode(() -> league.addPlayer(player))
                .doesNotThrowAnyException();
        }
    }

    @Nested
    @DisplayName("League Lifecycle")
    class LeagueLifecycle {

        private League league;

        @BeforeEach
        void setUp() {
            league = new League("Test", "TEST", adminId, 15, 4);
            league.setRosterConfiguration(RosterConfiguration.standardRoster());
            league.setScoringRules(new ScoringRules());
        }

        @Test
        @DisplayName("should start league with valid configuration")
        void shouldStartLeagueWithValidConfiguration() {
            // Given
            league.addPlayer(new Player());
            league.addPlayer(new Player());

            // When
            league.start();

            // Then
            assertThat(league.getStatus()).isEqualTo(League.LeagueStatus.ACTIVE);
        }

        @Test
        @DisplayName("should reject starting league with less than 2 players")
        void shouldRejectStartingLeagueWithLessThan2Players() {
            // Given
            league.addPlayer(new Player());

            // When/Then
            assertThatThrownBy(() -> league.start())
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("at least 2 players");
        }

        @Test
        @DisplayName("should reject starting league without roster configuration")
        void shouldRejectStartingLeagueWithoutRosterConfiguration() {
            // Given
            league.addPlayer(new Player());
            league.addPlayer(new Player());
            league.setRosterConfiguration(null);

            // When/Then
            assertThatThrownBy(() -> league.start())
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("roster configuration");
        }

        @Test
        @DisplayName("should reject starting league without scoring rules")
        void shouldRejectStartingLeagueWithoutScoringRules() {
            // Given
            league.addPlayer(new Player());
            league.addPlayer(new Player());
            league.setScoringRules(null);

            // When/Then
            assertThatThrownBy(() -> league.start())
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("scoring rules");
        }

        @Test
        @DisplayName("should advance week for active league")
        void shouldAdvanceWeekForActiveLeague() {
            // Given
            league.addPlayer(new Player());
            league.addPlayer(new Player());
            league.start();
            int initialWeek = league.getCurrentWeek();

            // When
            league.advanceWeek();

            // Then
            assertThat(league.getCurrentWeek()).isEqualTo(initialWeek + 1);
        }

        @Test
        @DisplayName("should complete league when advancing past final week")
        void shouldCompleteLeagueWhenAdvancingPastFinalWeek() {
            // Given
            league.addPlayer(new Player());
            league.addPlayer(new Player());
            league.start();
            league.setCurrentWeek(18); // At final week (15 + 4 - 1 = 18)

            // When
            league.advanceWeek();

            // Then
            assertThat(league.getStatus()).isEqualTo(League.LeagueStatus.COMPLETED);
        }

        @Test
        @DisplayName("should reject advancing week for non-active league")
        void shouldRejectAdvancingWeekForNonActiveLeague() {
            // When/Then
            assertThatThrownBy(() -> league.advanceWeek())
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("active leagues");
        }

        @Test
        @DisplayName("should complete active league")
        void shouldCompleteActiveLeague() {
            // Given
            league.addPlayer(new Player());
            league.addPlayer(new Player());
            league.start();

            // When
            league.complete();

            // Then
            assertThat(league.getStatus()).isEqualTo(League.LeagueStatus.COMPLETED);
        }

        @Test
        @DisplayName("should reject completing non-active league")
        void shouldRejectCompletingNonActiveLeague() {
            // When/Then
            assertThatThrownBy(() -> league.complete())
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("active");
        }
    }

    @Nested
    @DisplayName("Calculated Properties")
    class CalculatedProperties {

        @Test
        @DisplayName("should calculate ending week correctly")
        void shouldCalculateEndingWeekCorrectly() {
            // Given
            League league = new League("Test", "TEST", adminId, 5, 10);

            // When
            Integer endingWeek = league.getEndingWeek();

            // Then
            assertThat(endingWeek).isEqualTo(14); // 5 + 10 - 1
        }

        @Test
        @DisplayName("should return null ending week when starting week is null")
        void shouldReturnNullEndingWeekWhenStartingWeekIsNull() {
            // Given
            League league = new League();

            // When
            Integer endingWeek = league.getEndingWeek();

            // Then
            assertThat(endingWeek).isNull();
        }

        @Test
        @DisplayName("isActive should return true for ACTIVE status")
        void isActiveShouldReturnTrueForActiveStatus() {
            // Given
            League league = new League("Test", "TEST", adminId, 15, 4);
            league.setStatus(League.LeagueStatus.ACTIVE);

            // Then
            assertThat(league.isActive()).isTrue();
        }

        @Test
        @DisplayName("isActive should return false for non-ACTIVE status")
        void isActiveShouldReturnFalseForNonActiveStatus() {
            // Given
            League league = new League("Test", "TEST", adminId, 15, 4);

            // Then
            assertThat(league.isActive()).isFalse();
        }

        @Test
        @DisplayName("isCompleted should return true for COMPLETED status")
        void isCompletedShouldReturnTrueForCompletedStatus() {
            // Given
            League league = new League("Test", "TEST", adminId, 15, 4);
            league.setStatus(League.LeagueStatus.COMPLETED);

            // Then
            assertThat(league.isCompleted()).isTrue();
        }

        @Test
        @DisplayName("isCompleted should return false for non-COMPLETED status")
        void isCompletedShouldReturnFalseForNonCompletedStatus() {
            // Given
            League league = new League("Test", "TEST", adminId, 15, 4);

            // Then
            assertThat(league.isCompleted()).isFalse();
        }
    }

    @Nested
    @DisplayName("toString Method")
    class ToStringMethod {

        @Test
        @DisplayName("should generate readable string representation")
        void shouldGenerateReadableStringRepresentation() {
            // Given
            League league = new League("Championship", "CHAMP2024", adminId, 15, 4);

            // When
            String str = league.toString();

            // Then
            assertThat(str)
                .contains("Championship")
                .contains("15")
                .contains("18")
                .contains("CREATED");
        }
    }
}

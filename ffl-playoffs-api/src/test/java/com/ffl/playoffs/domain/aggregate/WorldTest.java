package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.world.WorldConfiguration;
import com.ffl.playoffs.domain.model.world.WorldStatus;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("World Aggregate Tests")
class WorldTest {

    private WorldConfiguration defaultConfig;
    private UUID creatorId;

    @BeforeEach
    void setUp() {
        defaultConfig = WorldConfiguration.defaultForSeason(2024);
        creatorId = UUID.randomUUID();
    }

    @Nested
    @DisplayName("Creation Tests")
    class CreationTests {

        @Test
        @DisplayName("should create world with required fields")
        void shouldCreateWorldWithRequiredFields() {
            World world = new World("FFL 2024", defaultConfig, creatorId);

            assertThat(world.getId()).isNotNull();
            assertThat(world.getName()).isEqualTo("FFL 2024");
            assertThat(world.getStatus()).isEqualTo(WorldStatus.CREATED);
            assertThat(world.getConfiguration()).isEqualTo(defaultConfig);
            assertThat(world.getCreatedBy()).isEqualTo(creatorId);
            assertThat(world.getSeasonInfo()).isNotNull();
            assertThat(world.getLeagueIds()).isEmpty();
            assertThat(world.getCreatedAt()).isNotNull();
        }

        @Test
        @DisplayName("should throw for null name")
        void shouldThrowForNullName() {
            assertThatThrownBy(() -> new World(null, defaultConfig, creatorId))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("null or blank");
        }

        @Test
        @DisplayName("should throw for blank name")
        void shouldThrowForBlankName() {
            assertThatThrownBy(() -> new World("   ", defaultConfig, creatorId))
                    .isInstanceOf(IllegalArgumentException.class);
        }

        @Test
        @DisplayName("should throw for null configuration")
        void shouldThrowForNullConfiguration() {
            assertThatThrownBy(() -> new World("Test", null, creatorId))
                    .isInstanceOf(NullPointerException.class);
        }
    }

    @Nested
    @DisplayName("Lifecycle Tests")
    class LifecycleTests {

        @Test
        @DisplayName("should configure world")
        void shouldConfigureWorld() {
            World world = new World("FFL 2024", defaultConfig, creatorId);
            WorldConfiguration newConfig = WorldConfiguration.playoffsForSeason(2024);

            world.configure(newConfig);

            assertThat(world.getStatus()).isEqualTo(WorldStatus.CONFIGURING);
            assertThat(world.getConfiguration()).isEqualTo(newConfig);
        }

        @Test
        @DisplayName("should mark world ready")
        void shouldMarkWorldReady() {
            World world = new World("FFL 2024", defaultConfig, creatorId);
            world.configure(defaultConfig);

            world.markReady();

            assertThat(world.getStatus()).isEqualTo(WorldStatus.READY);
        }

        @Test
        @DisplayName("should activate world with league")
        void shouldActivateWorldWithLeague() {
            World world = new World("FFL 2024", defaultConfig, creatorId);
            world.registerLeague(UUID.randomUUID());
            world.markReady();

            world.activate();

            assertThat(world.getStatus()).isEqualTo(WorldStatus.ACTIVE);
            assertThat(world.getActivatedAt()).isNotNull();
        }

        @Test
        @DisplayName("should throw when activating without leagues")
        void shouldThrowWhenActivatingWithoutLeagues() {
            World world = new World("FFL 2024", defaultConfig, creatorId);
            world.markReady();

            assertThatThrownBy(world::activate)
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("at least one league");
        }

        @Test
        @DisplayName("should pause and resume world")
        void shouldPauseAndResumeWorld() {
            World world = new World("FFL 2024", defaultConfig, creatorId);
            world.registerLeague(UUID.randomUUID());
            world.markReady();
            world.activate();

            world.pause("Maintenance");
            assertThat(world.getStatus()).isEqualTo(WorldStatus.PAUSED);

            world.resume();
            assertThat(world.getStatus()).isEqualTo(WorldStatus.ACTIVE);
        }

        @Test
        @DisplayName("should complete world")
        void shouldCompleteWorld() {
            World world = new World("FFL 2024", defaultConfig, creatorId);
            world.registerLeague(UUID.randomUUID());
            world.markReady();
            world.activate();

            world.complete("Season finished");

            assertThat(world.getStatus()).isEqualTo(WorldStatus.COMPLETED);
            assertThat(world.getCompletedAt()).isNotNull();
            assertThat(world.getCompletionReason()).isEqualTo("Season finished");
        }

        @Test
        @DisplayName("should cancel world")
        void shouldCancelWorld() {
            World world = new World("FFL 2024", defaultConfig, creatorId);

            world.cancel("Not enough participants");

            assertThat(world.getStatus()).isEqualTo(WorldStatus.CANCELLED);
            assertThat(world.getCompletionReason()).isEqualTo("Not enough participants");
        }

        @Test
        @DisplayName("should not cancel terminal state")
        void shouldNotCancelTerminalState() {
            World world = new World("FFL 2024", defaultConfig, creatorId);
            world.registerLeague(UUID.randomUUID());
            world.markReady();
            world.activate();
            world.complete("Done");

            assertThatThrownBy(() -> world.cancel("Oops"))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot cancel");
        }
    }

    @Nested
    @DisplayName("Week Advancement Tests")
    class WeekAdvancementTests {

        @Test
        @DisplayName("should advance week")
        void shouldAdvanceWeek() {
            World world = new World("FFL 2024", defaultConfig, creatorId);
            world.registerLeague(UUID.randomUUID());
            world.markReady();
            world.activate();

            Integer initialWeek = world.getCurrentWeek();
            world.advanceWeek();

            assertThat(world.getCurrentWeek()).isEqualTo(initialWeek + 1);
        }

        @Test
        @DisplayName("should auto-complete on last week")
        void shouldAutoCompleteOnLastWeek() {
            WorldConfiguration shortConfig = WorldConfiguration.builder()
                    .season(2024)
                    .startingNflWeek(1)
                    .endingNflWeek(2)
                    .build();

            World world = new World("Short Season", shortConfig, creatorId);
            world.registerLeague(UUID.randomUUID());
            world.markReady();
            world.activate();

            // Advance from week 1 to week 2
            world.advanceWeek();
            assertThat(world.getStatus()).isEqualTo(WorldStatus.ACTIVE);

            // Advance from week 2 should complete
            world.advanceWeek();
            assertThat(world.getStatus()).isEqualTo(WorldStatus.COMPLETED);
        }

        @Test
        @DisplayName("should throw when advancing inactive world")
        void shouldThrowWhenAdvancingInactiveWorld() {
            World world = new World("FFL 2024", defaultConfig, creatorId);

            assertThatThrownBy(world::advanceWeek)
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("only advance week for an active world");
        }
    }

    @Nested
    @DisplayName("League Management Tests")
    class LeagueManagementTests {

        @Test
        @DisplayName("should register league")
        void shouldRegisterLeague() {
            World world = new World("FFL 2024", defaultConfig, creatorId);
            UUID leagueId = UUID.randomUUID();

            world.registerLeague(leagueId);

            assertThat(world.getLeagueIds()).containsExactly(leagueId);
            assertThat(world.getActiveLeagueCount()).isEqualTo(1);
        }

        @Test
        @DisplayName("should throw when registering duplicate league")
        void shouldThrowWhenRegisteringDuplicateLeague() {
            World world = new World("FFL 2024", defaultConfig, creatorId);
            UUID leagueId = UUID.randomUUID();
            world.registerLeague(leagueId);

            assertThatThrownBy(() -> world.registerLeague(leagueId))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("already registered");
        }

        @Test
        @DisplayName("should throw when exceeding max leagues")
        void shouldThrowWhenExceedingMaxLeagues() {
            WorldConfiguration limitedConfig = WorldConfiguration.builder()
                    .season(2024)
                    .startingNflWeek(1)
                    .endingNflWeek(18)
                    .maxLeagues(2)
                    .build();

            World world = new World("Limited World", limitedConfig, creatorId);
            world.registerLeague(UUID.randomUUID());
            world.registerLeague(UUID.randomUUID());

            assertThatThrownBy(() -> world.registerLeague(UUID.randomUUID()))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("maximum league limit");
        }

        @Test
        @DisplayName("should unregister league before activation")
        void shouldUnregisterLeagueBeforeActivation() {
            World world = new World("FFL 2024", defaultConfig, creatorId);
            UUID leagueId = UUID.randomUUID();
            world.registerLeague(leagueId);

            world.unregisterLeague(leagueId);

            assertThat(world.getLeagueIds()).isEmpty();
        }

        @Test
        @DisplayName("should throw when unregistering from active world")
        void shouldThrowWhenUnregisteringFromActiveWorld() {
            World world = new World("FFL 2024", defaultConfig, creatorId);
            UUID leagueId = UUID.randomUUID();
            world.registerLeague(leagueId);
            world.markReady();
            world.activate();

            assertThatThrownBy(() -> world.unregisterLeague(leagueId))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot unregister leagues from an active world");
        }
    }

    @Nested
    @DisplayName("Statistics Tests")
    class StatisticsTests {

        @Test
        @DisplayName("should update participant count")
        void shouldUpdateParticipantCount() {
            World world = new World("FFL 2024", defaultConfig, creatorId);

            world.updateParticipantCount(100);

            assertThat(world.getTotalParticipants()).isEqualTo(100);
        }

        @Test
        @DisplayName("should increment games played")
        void shouldIncrementGamesPlayed() {
            World world = new World("FFL 2024", defaultConfig, creatorId);

            world.incrementGamesPlayed();
            world.incrementGamesPlayed();

            assertThat(world.getTotalGamesPlayed()).isEqualTo(2);
        }

        @Test
        @DisplayName("should throw for negative participant count")
        void shouldThrowForNegativeParticipantCount() {
            World world = new World("FFL 2024", defaultConfig, creatorId);

            assertThatThrownBy(() -> world.updateParticipantCount(-1))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("cannot be negative");
        }
    }

    @Nested
    @DisplayName("Query Methods Tests")
    class QueryMethodsTests {

        @Test
        @DisplayName("should correctly identify active state")
        void shouldCorrectlyIdentifyActiveState() {
            World world = new World("FFL 2024", defaultConfig, creatorId);
            assertThat(world.isActive()).isFalse();

            world.registerLeague(UUID.randomUUID());
            world.markReady();
            world.activate();

            assertThat(world.isActive()).isTrue();
        }

        @Test
        @DisplayName("should correctly identify configurable state")
        void shouldCorrectlyIdentifyConfigurableState() {
            World world = new World("FFL 2024", defaultConfig, creatorId);
            assertThat(world.isConfigurable()).isTrue();

            world.registerLeague(UUID.randomUUID());
            world.markReady();
            world.activate();

            assertThat(world.isConfigurable()).isFalse();
        }

        @Test
        @DisplayName("should return current week and season")
        void shouldReturnCurrentWeekAndSeason() {
            World world = new World("FFL 2024", defaultConfig, creatorId);

            assertThat(world.getCurrentWeek()).isEqualTo(1);
            assertThat(world.getSeason()).isEqualTo(2024);
        }
    }

    @Test
    @DisplayName("should implement equals based on ID")
    void shouldImplementEqualsBasedOnId() {
        World world1 = new World("FFL 2024", defaultConfig, creatorId);
        World world2 = new World("FFL 2025", defaultConfig, creatorId);

        UUID sharedId = UUID.randomUUID();
        world1.setId(sharedId);
        world2.setId(sharedId);

        assertThat(world1).isEqualTo(world2);
        assertThat(world1.hashCode()).isEqualTo(world2.hashCode());
    }
}

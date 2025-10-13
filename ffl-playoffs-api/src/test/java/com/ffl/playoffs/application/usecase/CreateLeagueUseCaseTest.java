package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.IntegrationTestBase;
import com.ffl.playoffs.domain.model.*;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

/**
 * Integration tests for CreateLeagueUseCase
 * Tests complete end-to-end flow with MongoDB persistence
 */
@DisplayName("CreateLeagueUseCase Integration Tests")
class CreateLeagueUseCaseTest extends IntegrationTestBase {

    @Autowired
    private LeagueRepository leagueRepository;

    @Autowired
    private UserRepository userRepository;

    private CreateLeagueUseCase useCase;
    private UUID testOwnerId;

    @Override
    protected void baseSetUp() {
        super.baseSetUp();
        useCase = new CreateLeagueUseCase(leagueRepository);

        // Create a test owner user
        User owner = new User("owner@example.com", "League Owner", "google-owner");
        owner.setRole(Role.ADMIN);
        owner = userRepository.save(owner);
        testOwnerId = owner.getId();
    }

    @Test
    @DisplayName("Should create league with minimal required fields")
    void shouldCreateLeagueWithMinimalFields() {
        // Given
        var command = new CreateLeagueUseCase.CreateLeagueCommand(
                "Playoff Challenge 2024",
                "PLAYOFF2024",
                testOwnerId,
                15, // Starting week 15
                4   // 4 weeks duration (weeks 15-18)
        );

        // When
        League createdLeague = useCase.execute(command);

        // Then
        assertThat(createdLeague).isNotNull();
        assertThat(createdLeague.getId()).isNotNull();
        assertThat(createdLeague.getName()).isEqualTo("Playoff Challenge 2024");
        assertThat(createdLeague.getCode()).isEqualTo("PLAYOFF2024");
        assertThat(createdLeague.getOwnerId()).isEqualTo(testOwnerId);
        assertThat(createdLeague.getStartingWeek()).isEqualTo(15);
        assertThat(createdLeague.getNumberOfWeeks()).isEqualTo(4);
        assertThat(createdLeague.getEndingWeek()).isEqualTo(18);
        assertThat(createdLeague.getCurrentWeek()).isEqualTo(15);
        assertThat(createdLeague.getStatus()).isEqualTo(League.LeagueStatus.WAITING_FOR_PLAYERS);
        assertThat(createdLeague.getConfigurationLocked()).isFalse();
        assertThat(createdLeague.getCreatedAt()).isNotNull();
        assertThat(createdLeague.getUpdatedAt()).isNotNull();

        // Verify persistence
        League savedLeague = leagueRepository.findById(createdLeague.getId()).orElse(null);
        assertThat(savedLeague).isNotNull();
        assertThat(savedLeague.getCode()).isEqualTo("PLAYOFF2024");
    }

    @Test
    @DisplayName("Should create league with default roster configuration when not provided")
    void shouldCreateLeagueWithDefaultRosterConfiguration() {
        // Given
        var command = new CreateLeagueUseCase.CreateLeagueCommand(
                "Standard League",
                "STD2024",
                testOwnerId,
                1,
                17
        );

        // When
        League createdLeague = useCase.execute(command);

        // Then
        assertThat(createdLeague.getRosterConfiguration()).isNotNull();
        RosterConfiguration config = createdLeague.getRosterConfiguration();
        assertThat(config.getPositionSlots(Position.QB)).isEqualTo(1);
        assertThat(config.getPositionSlots(Position.RB)).isEqualTo(2);
        assertThat(config.getPositionSlots(Position.WR)).isEqualTo(2);
        assertThat(config.getPositionSlots(Position.TE)).isEqualTo(1);
        assertThat(config.getPositionSlots(Position.FLEX)).isEqualTo(1);
        assertThat(config.getPositionSlots(Position.K)).isEqualTo(1);
        assertThat(config.getPositionSlots(Position.DEF)).isEqualTo(1);
        assertThat(config.getTotalSlots()).isEqualTo(9);
    }

    @Test
    @DisplayName("Should create league with default scoring rules when not provided")
    void shouldCreateLeagueWithDefaultScoringRules() {
        // Given
        var command = new CreateLeagueUseCase.CreateLeagueCommand(
                "PPR League",
                "PPR2024",
                testOwnerId,
                1,
                17
        );

        // When
        League createdLeague = useCase.execute(command);

        // Then
        assertThat(createdLeague.getScoringRules()).isNotNull();
        ScoringRules rules = createdLeague.getScoringRules();
        // Verify default PPR scoring
        assertThat(rules.getReceptionPoints()).isEqualTo(1.0); // Full PPR
        assertThat(rules.getPassingTouchdownPoints()).isEqualTo(4.0);
        assertThat(rules.getRushingTouchdownPoints()).isEqualTo(6.0);
        assertThat(rules.getReceivingTouchdownPoints()).isEqualTo(6.0);
    }

    @Test
    @DisplayName("Should create league with custom roster configuration")
    void shouldCreateLeagueWithCustomRosterConfiguration() {
        // Given
        RosterConfiguration customConfig = RosterConfiguration.superflexRoster();

        var command = new CreateLeagueUseCase.CreateLeagueCommand(
                "Superflex League",
                "SFLEX2024",
                testOwnerId,
                1,
                17
        );
        command.setRosterConfiguration(customConfig);

        // When
        League createdLeague = useCase.execute(command);

        // Then
        assertThat(createdLeague.getRosterConfiguration()).isNotNull();
        assertThat(createdLeague.getRosterConfiguration().hasPosition(Position.SUPERFLEX)).isTrue();
        assertThat(createdLeague.getRosterConfiguration().getPositionSlots(Position.SUPERFLEX)).isEqualTo(1);
    }

    @Test
    @DisplayName("Should create league with custom scoring rules")
    void shouldCreateLeagueWithCustomScoringRules() {
        // Given
        ScoringRules customRules = new ScoringRules();
        customRules.setReceptionPoints(0.5); // Half PPR
        customRules.setPassingTouchdownPoints(6.0); // 6 points for passing TD

        var command = new CreateLeagueUseCase.CreateLeagueCommand(
                "Half PPR League",
                "HALFPPR2024",
                testOwnerId,
                1,
                17
        );
        command.setScoringRules(customRules);

        // When
        League createdLeague = useCase.execute(command);

        // Then
        assertThat(createdLeague.getScoringRules()).isNotNull();
        assertThat(createdLeague.getScoringRules().getReceptionPoints()).isEqualTo(0.5);
        assertThat(createdLeague.getScoringRules().getPassingTouchdownPoints()).isEqualTo(6.0);
    }

    @Test
    @DisplayName("Should create league with description and first game start time")
    void shouldCreateLeagueWithOptionalFields() {
        // Given
        LocalDateTime firstGameTime = LocalDateTime.of(2024, 12, 14, 13, 0);

        var command = new CreateLeagueUseCase.CreateLeagueCommand(
                "Championship Week",
                "CHAMP2024",
                testOwnerId,
                15,
                4
        );
        command.setDescription("End of season playoff challenge");
        command.setFirstGameStartTime(firstGameTime);

        // When
        League createdLeague = useCase.execute(command);

        // Then
        assertThat(createdLeague.getDescription()).isEqualTo("End of season playoff challenge");
        assertThat(createdLeague.getFirstGameStartTime()).isEqualTo(firstGameTime);
    }

    @Test
    @DisplayName("Should throw exception when league code already exists")
    void shouldThrowExceptionWhenCodeExists() {
        // Given - create first league
        var firstCommand = new CreateLeagueUseCase.CreateLeagueCommand(
                "First League",
                "DUPLICATE",
                testOwnerId,
                1,
                17
        );
        useCase.execute(firstCommand);

        // Try to create another league with same code
        var duplicateCommand = new CreateLeagueUseCase.CreateLeagueCommand(
                "Second League",
                "DUPLICATE",
                testOwnerId,
                1,
                17
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(duplicateCommand))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("League code already exists: DUPLICATE");
    }

    @Test
    @DisplayName("Should throw exception when starting week is invalid")
    void shouldThrowExceptionWhenStartingWeekInvalid() {
        // Test week < 1
        var command1 = new CreateLeagueUseCase.CreateLeagueCommand(
                "Invalid League",
                "INVALID1",
                testOwnerId,
                0, // Invalid: week 0
                4
        );
        assertThatThrownBy(() -> useCase.execute(command1))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Starting week must be between 1 and 22");

        // Test week > 22
        var command2 = new CreateLeagueUseCase.CreateLeagueCommand(
                "Invalid League",
                "INVALID2",
                testOwnerId,
                23, // Invalid: week 23
                4
        );
        assertThatThrownBy(() -> useCase.execute(command2))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Starting week must be between 1 and 22");
    }

    @Test
    @DisplayName("Should throw exception when number of weeks is invalid")
    void shouldThrowExceptionWhenNumberOfWeeksInvalid() {
        // Test weeks < 1
        var command1 = new CreateLeagueUseCase.CreateLeagueCommand(
                "Invalid League",
                "INVALID3",
                testOwnerId,
                1,
                0 // Invalid: 0 weeks
        );
        assertThatThrownBy(() -> useCase.execute(command1))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Number of weeks must be between 1 and 17");

        // Test weeks > 17
        var command2 = new CreateLeagueUseCase.CreateLeagueCommand(
                "Invalid League",
                "INVALID4",
                testOwnerId,
                1,
                18 // Invalid: 18 weeks
        );
        assertThatThrownBy(() -> useCase.execute(command2))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Number of weeks must be between 1 and 17");
    }

    @Test
    @DisplayName("Should throw exception when league duration exceeds NFL calendar")
    void shouldThrowExceptionWhenDurationExceedsNFLCalendar() {
        // Given - week 20 + 5 weeks = week 24 (exceeds max week 22)
        var command = new CreateLeagueUseCase.CreateLeagueCommand(
                "Invalid League",
                "INVALID5",
                testOwnerId,
                20,  // Starting week 20
                5    // 5 weeks would end at week 24 (too late)
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("League duration exceeds NFL calendar");
    }

    @Test
    @DisplayName("Should create league at maximum valid week range")
    void shouldCreateLeagueAtMaximumValidWeekRange() {
        // Given - week 6 + 17 weeks = week 22 (maximum valid)
        var command = new CreateLeagueUseCase.CreateLeagueCommand(
                "Full Season League",
                "FULLSEASON",
                testOwnerId,
                6,   // Starting week 6
                17   // 17 weeks ends at week 22
        );

        // When
        League createdLeague = useCase.execute(command);

        // Then
        assertThat(createdLeague).isNotNull();
        assertThat(createdLeague.getStartingWeek()).isEqualTo(6);
        assertThat(createdLeague.getNumberOfWeeks()).isEqualTo(17);
        assertThat(createdLeague.getEndingWeek()).isEqualTo(22);
    }

    @Test
    @DisplayName("Should find league by code after creation")
    void shouldFindLeagueByCode() {
        // Given
        var command = new CreateLeagueUseCase.CreateLeagueCommand(
                "Findable League",
                "FINDME",
                testOwnerId,
                1,
                4
        );
        League createdLeague = useCase.execute(command);

        // When
        League foundLeague = leagueRepository.findByCode("FINDME").orElse(null);

        // Then
        assertThat(foundLeague).isNotNull();
        assertThat(foundLeague.getId()).isEqualTo(createdLeague.getId());
        assertThat(foundLeague.getName()).isEqualTo("Findable League");
    }

    @Test
    @DisplayName("Should find league by owner ID after creation")
    void shouldFindLeagueByOwnerId() {
        // Given - create multiple leagues for same owner
        var command1 = new CreateLeagueUseCase.CreateLeagueCommand(
                "League 1",
                "OWNER1",
                testOwnerId,
                1,
                4
        );
        useCase.execute(command1);

        var command2 = new CreateLeagueUseCase.CreateLeagueCommand(
                "League 2",
                "OWNER2",
                testOwnerId,
                5,
                4
        );
        useCase.execute(command2);

        // When
        var leagues = leagueRepository.findByAdminId(testOwnerId);

        // Then
        assertThat(leagues).hasSize(2);
        assertThat(leagues).extracting(League::getName)
                .containsExactlyInAnyOrder("League 1", "League 2");
    }

    @Test
    @DisplayName("Should persist all league fields correctly")
    void shouldPersistAllLeagueFields() {
        // Given
        RosterConfiguration config = RosterConfiguration.superflexRoster();
        ScoringRules rules = new ScoringRules();
        rules.setReceptionPoints(0.5);
        LocalDateTime firstGameTime = LocalDateTime.of(2024, 9, 6, 20, 15);

        var command = new CreateLeagueUseCase.CreateLeagueCommand(
                "Complete League",
                "COMPLETE",
                testOwnerId,
                1,
                17
        );
        command.setDescription("Fully configured league");
        command.setRosterConfiguration(config);
        command.setScoringRules(rules);
        command.setFirstGameStartTime(firstGameTime);

        // When
        League createdLeague = useCase.execute(command);

        // Then - retrieve from database and verify all fields
        League retrievedLeague = leagueRepository.findById(createdLeague.getId()).orElse(null);
        assertThat(retrievedLeague).isNotNull();
        assertThat(retrievedLeague.getName()).isEqualTo("Complete League");
        assertThat(retrievedLeague.getCode()).isEqualTo("COMPLETE");
        assertThat(retrievedLeague.getDescription()).isEqualTo("Fully configured league");
        assertThat(retrievedLeague.getOwnerId()).isEqualTo(testOwnerId);
        assertThat(retrievedLeague.getStartingWeek()).isEqualTo(1);
        assertThat(retrievedLeague.getNumberOfWeeks()).isEqualTo(17);
        assertThat(retrievedLeague.getCurrentWeek()).isEqualTo(1);
        assertThat(retrievedLeague.getStatus()).isEqualTo(League.LeagueStatus.WAITING_FOR_PLAYERS);
        assertThat(retrievedLeague.getConfigurationLocked()).isFalse();
        assertThat(retrievedLeague.getFirstGameStartTime()).isEqualTo(firstGameTime);

        // Verify roster configuration
        assertThat(retrievedLeague.getRosterConfiguration()).isNotNull();
        assertThat(retrievedLeague.getRosterConfiguration().hasPosition(Position.SUPERFLEX)).isTrue();

        // Verify scoring rules
        assertThat(retrievedLeague.getScoringRules()).isNotNull();
        assertThat(retrievedLeague.getScoringRules().getReceptionPoints()).isEqualTo(0.5);
    }
}

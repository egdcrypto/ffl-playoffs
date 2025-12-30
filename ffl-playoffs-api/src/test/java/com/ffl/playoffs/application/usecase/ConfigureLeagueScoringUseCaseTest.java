package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.model.ScoringRules;
import com.ffl.playoffs.domain.port.LeagueRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ConfigureLeagueScoringUseCase Tests")
class ConfigureLeagueScoringUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    private ConfigureLeagueScoringUseCase useCase;

    @Captor
    private ArgumentCaptor<League> leagueCaptor;

    private UUID leagueId;
    private UUID adminUserId;
    private League league;

    @BeforeEach
    void setUp() {
        useCase = new ConfigureLeagueScoringUseCase(leagueRepository);

        leagueId = UUID.randomUUID();
        adminUserId = UUID.randomUUID();

        // Create league
        league = new League();
        league.setId(leagueId);
        league.setName("Test League");
        league.setCode("TEST");
        league.setOwnerId(adminUserId);
        league.setStartingWeekAndDuration(15, 3);
        league.setScoringRules(ScoringRules.standardRules());
    }

    @Nested
    @DisplayName("configurePPRScoring")
    class ConfigurePPRScoring {

        @Test
        @DisplayName("should configure PPR scoring successfully")
        void shouldConfigurePPRScoringSuccessfully() {
            // Arrange
            ConfigureLeagueScoringUseCase.ConfigurePPRCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigurePPRCommand(
                            leagueId, adminUserId, 25.0, 10.0, 10.0, 1.0, 6.0);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.configurePPRScoring(command);

            // Assert
            assertNotNull(result);
            assertNotNull(result.getScoringRules());
            assertNotNull(result.getScoringRules().getPprScoringRules());

            verify(leagueRepository).save(leagueCaptor.capture());
            assertNotNull(leagueCaptor.getValue().getScoringRules().getPprScoringRules());
        }

        @Test
        @DisplayName("should throw exception when league not found")
        void shouldThrowExceptionWhenLeagueNotFound() {
            // Arrange
            UUID unknownLeagueId = UUID.randomUUID();
            ConfigureLeagueScoringUseCase.ConfigurePPRCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigurePPRCommand(
                            unknownLeagueId, adminUserId, 25.0, 10.0, 10.0, 1.0, 6.0);

            when(leagueRepository.findById(unknownLeagueId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.configurePPRScoring(command)
            );

            assertTrue(exception.getMessage().contains("League not found"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw UnauthorizedLeagueAccessException when not owner")
        void shouldThrowExceptionWhenNotOwner() {
            // Arrange
            UUID differentUserId = UUID.randomUUID();
            ConfigureLeagueScoringUseCase.ConfigurePPRCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigurePPRCommand(
                            leagueId, differentUserId, 25.0, 10.0, 10.0, 1.0, 6.0);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act & Assert
            ConfigureLeagueScoringUseCase.UnauthorizedLeagueAccessException exception = assertThrows(
                    ConfigureLeagueScoringUseCase.UnauthorizedLeagueAccessException.class,
                    () -> useCase.configurePPRScoring(command)
            );

            assertTrue(exception.getMessage().contains("does not own"));
            assertEquals("UNAUTHORIZED_LEAGUE_ACCESS", exception.getErrorCode());
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw ConfigurationLockedException when league is locked")
        void shouldThrowExceptionWhenLeagueLocked() {
            // Arrange
            League lockedLeague = new League();
            lockedLeague.setId(leagueId);
            lockedLeague.setName("Test League");
            lockedLeague.setCode("TEST");
            lockedLeague.setOwnerId(adminUserId);
            lockedLeague.setStartingWeekAndDuration(15, 3);
            lockedLeague.setScoringRules(ScoringRules.standardRules());
            lockedLeague.lockConfiguration(LocalDateTime.now().minusDays(1), "Testing");

            ConfigureLeagueScoringUseCase.ConfigurePPRCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigurePPRCommand(
                            leagueId, adminUserId, 25.0, 10.0, 10.0, 1.0, 6.0);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(lockedLeague));

            // Act & Assert
            League.ConfigurationLockedException exception = assertThrows(
                    League.ConfigurationLockedException.class,
                    () -> useCase.configurePPRScoring(command)
            );

            assertNotNull(exception);
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should create default scoring rules when league has none")
        void shouldCreateDefaultScoringRulesWhenNone() {
            // Arrange
            League leagueWithoutRules = new League();
            leagueWithoutRules.setId(leagueId);
            leagueWithoutRules.setName("Test League");
            leagueWithoutRules.setCode("TEST");
            leagueWithoutRules.setOwnerId(adminUserId);
            leagueWithoutRules.setStartingWeekAndDuration(15, 3);
            // No scoring rules set

            ConfigureLeagueScoringUseCase.ConfigurePPRCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigurePPRCommand(
                            leagueId, adminUserId, 25.0, 10.0, 10.0, 1.0, 6.0);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(leagueWithoutRules));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.configurePPRScoring(command);

            // Assert
            assertNotNull(result);
            assertNotNull(result.getScoringRules());
            assertNotNull(result.getScoringRules().getPprScoringRules());
        }

        @Test
        @DisplayName("should save league after configuring PPR scoring")
        void shouldSaveLeagueAfterConfiguration() {
            // Arrange
            ConfigureLeagueScoringUseCase.ConfigurePPRCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigurePPRCommand(
                            leagueId, adminUserId, 25.0, 10.0, 10.0, 1.0, 6.0);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.configurePPRScoring(command);

            // Assert
            verify(leagueRepository, times(1)).save(any(League.class));
        }
    }

    @Nested
    @DisplayName("configureFieldGoalScoring")
    class ConfigureFieldGoalScoring {

        @Test
        @DisplayName("should configure field goal scoring successfully")
        void shouldConfigureFieldGoalScoringSuccessfully() {
            // Arrange
            ConfigureLeagueScoringUseCase.ConfigureFieldGoalCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigureFieldGoalCommand(
                            leagueId, adminUserId, 3.0, 4.0, 5.0);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.configureFieldGoalScoring(command);

            // Assert
            assertNotNull(result);
            assertNotNull(result.getScoringRules());
            assertNotNull(result.getScoringRules().getFieldGoalScoringRules());

            verify(leagueRepository).save(leagueCaptor.capture());
            assertNotNull(leagueCaptor.getValue().getScoringRules().getFieldGoalScoringRules());
        }

        @Test
        @DisplayName("should throw exception when league not found")
        void shouldThrowExceptionWhenLeagueNotFound() {
            // Arrange
            UUID unknownLeagueId = UUID.randomUUID();
            ConfigureLeagueScoringUseCase.ConfigureFieldGoalCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigureFieldGoalCommand(
                            unknownLeagueId, adminUserId, 3.0, 4.0, 5.0);

            when(leagueRepository.findById(unknownLeagueId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.configureFieldGoalScoring(command)
            );

            assertTrue(exception.getMessage().contains("League not found"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw UnauthorizedLeagueAccessException when not owner")
        void shouldThrowExceptionWhenNotOwner() {
            // Arrange
            UUID differentUserId = UUID.randomUUID();
            ConfigureLeagueScoringUseCase.ConfigureFieldGoalCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigureFieldGoalCommand(
                            leagueId, differentUserId, 3.0, 4.0, 5.0);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act & Assert
            ConfigureLeagueScoringUseCase.UnauthorizedLeagueAccessException exception = assertThrows(
                    ConfigureLeagueScoringUseCase.UnauthorizedLeagueAccessException.class,
                    () -> useCase.configureFieldGoalScoring(command)
            );

            assertTrue(exception.getMessage().contains("does not own"));
            assertEquals("UNAUTHORIZED_LEAGUE_ACCESS", exception.getErrorCode());
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw ConfigurationLockedException when league is locked")
        void shouldThrowExceptionWhenLeagueLocked() {
            // Arrange
            League lockedLeague = new League();
            lockedLeague.setId(leagueId);
            lockedLeague.setName("Test League");
            lockedLeague.setCode("TEST");
            lockedLeague.setOwnerId(adminUserId);
            lockedLeague.setStartingWeekAndDuration(15, 3);
            lockedLeague.setScoringRules(ScoringRules.standardRules());
            lockedLeague.lockConfiguration(LocalDateTime.now().minusDays(1), "Testing");

            ConfigureLeagueScoringUseCase.ConfigureFieldGoalCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigureFieldGoalCommand(
                            leagueId, adminUserId, 3.0, 4.0, 5.0);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(lockedLeague));

            // Act & Assert
            League.ConfigurationLockedException exception = assertThrows(
                    League.ConfigurationLockedException.class,
                    () -> useCase.configureFieldGoalScoring(command)
            );

            assertNotNull(exception);
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should create default scoring rules when league has none")
        void shouldCreateDefaultScoringRulesWhenNone() {
            // Arrange
            League leagueWithoutRules = new League();
            leagueWithoutRules.setId(leagueId);
            leagueWithoutRules.setName("Test League");
            leagueWithoutRules.setCode("TEST");
            leagueWithoutRules.setOwnerId(adminUserId);
            leagueWithoutRules.setStartingWeekAndDuration(15, 3);
            // No scoring rules set

            ConfigureLeagueScoringUseCase.ConfigureFieldGoalCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigureFieldGoalCommand(
                            leagueId, adminUserId, 3.0, 4.0, 5.0);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(leagueWithoutRules));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.configureFieldGoalScoring(command);

            // Assert
            assertNotNull(result);
            assertNotNull(result.getScoringRules());
            assertNotNull(result.getScoringRules().getFieldGoalScoringRules());
        }

        @Test
        @DisplayName("should save league after configuring field goal scoring")
        void shouldSaveLeagueAfterConfiguration() {
            // Arrange
            ConfigureLeagueScoringUseCase.ConfigureFieldGoalCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigureFieldGoalCommand(
                            leagueId, adminUserId, 3.0, 4.0, 5.0);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.configureFieldGoalScoring(command);

            // Assert
            verify(leagueRepository, times(1)).save(any(League.class));
        }
    }

    @Nested
    @DisplayName("configureDefensiveScoring")
    class ConfigureDefensiveScoring {

        private Map<Integer, Double> pointsAllowedTiers;

        @BeforeEach
        void setUpDefensiveTiers() {
            pointsAllowedTiers = new HashMap<>();
            pointsAllowedTiers.put(0, 10.0);
            pointsAllowedTiers.put(7, 7.0);
            pointsAllowedTiers.put(14, 4.0);
            pointsAllowedTiers.put(21, 1.0);
            pointsAllowedTiers.put(28, 0.0);
            pointsAllowedTiers.put(35, -1.0);
        }

        @Test
        @DisplayName("should configure defensive scoring successfully")
        void shouldConfigureDefensiveScoringSuccessfully() {
            // Arrange
            ConfigureLeagueScoringUseCase.ConfigureDefensiveCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigureDefensiveCommand(
                            leagueId, adminUserId, 1.0, 2.0, 2.0, 2.0, 6.0, pointsAllowedTiers);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.configureDefensiveScoring(command);

            // Assert
            assertNotNull(result);
            assertNotNull(result.getScoringRules());
            assertNotNull(result.getScoringRules().getDefensiveScoringRules());

            verify(leagueRepository).save(leagueCaptor.capture());
            assertNotNull(leagueCaptor.getValue().getScoringRules().getDefensiveScoringRules());
        }

        @Test
        @DisplayName("should throw exception when league not found")
        void shouldThrowExceptionWhenLeagueNotFound() {
            // Arrange
            UUID unknownLeagueId = UUID.randomUUID();
            ConfigureLeagueScoringUseCase.ConfigureDefensiveCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigureDefensiveCommand(
                            unknownLeagueId, adminUserId, 1.0, 2.0, 2.0, 2.0, 6.0, pointsAllowedTiers);

            when(leagueRepository.findById(unknownLeagueId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.configureDefensiveScoring(command)
            );

            assertTrue(exception.getMessage().contains("League not found"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw UnauthorizedLeagueAccessException when not owner")
        void shouldThrowExceptionWhenNotOwner() {
            // Arrange
            UUID differentUserId = UUID.randomUUID();
            ConfigureLeagueScoringUseCase.ConfigureDefensiveCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigureDefensiveCommand(
                            leagueId, differentUserId, 1.0, 2.0, 2.0, 2.0, 6.0, pointsAllowedTiers);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act & Assert
            ConfigureLeagueScoringUseCase.UnauthorizedLeagueAccessException exception = assertThrows(
                    ConfigureLeagueScoringUseCase.UnauthorizedLeagueAccessException.class,
                    () -> useCase.configureDefensiveScoring(command)
            );

            assertTrue(exception.getMessage().contains("does not own"));
            assertEquals("UNAUTHORIZED_LEAGUE_ACCESS", exception.getErrorCode());
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw ConfigurationLockedException when league is locked")
        void shouldThrowExceptionWhenLeagueLocked() {
            // Arrange
            League lockedLeague = new League();
            lockedLeague.setId(leagueId);
            lockedLeague.setName("Test League");
            lockedLeague.setCode("TEST");
            lockedLeague.setOwnerId(adminUserId);
            lockedLeague.setStartingWeekAndDuration(15, 3);
            lockedLeague.setScoringRules(ScoringRules.standardRules());
            lockedLeague.lockConfiguration(LocalDateTime.now().minusDays(1), "Testing");

            ConfigureLeagueScoringUseCase.ConfigureDefensiveCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigureDefensiveCommand(
                            leagueId, adminUserId, 1.0, 2.0, 2.0, 2.0, 6.0, pointsAllowedTiers);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(lockedLeague));

            // Act & Assert
            League.ConfigurationLockedException exception = assertThrows(
                    League.ConfigurationLockedException.class,
                    () -> useCase.configureDefensiveScoring(command)
            );

            assertNotNull(exception);
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should create default scoring rules when league has none")
        void shouldCreateDefaultScoringRulesWhenNone() {
            // Arrange
            League leagueWithoutRules = new League();
            leagueWithoutRules.setId(leagueId);
            leagueWithoutRules.setName("Test League");
            leagueWithoutRules.setCode("TEST");
            leagueWithoutRules.setOwnerId(adminUserId);
            leagueWithoutRules.setStartingWeekAndDuration(15, 3);
            // No scoring rules set

            ConfigureLeagueScoringUseCase.ConfigureDefensiveCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigureDefensiveCommand(
                            leagueId, adminUserId, 1.0, 2.0, 2.0, 2.0, 6.0, pointsAllowedTiers);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(leagueWithoutRules));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.configureDefensiveScoring(command);

            // Assert
            assertNotNull(result);
            assertNotNull(result.getScoringRules());
            assertNotNull(result.getScoringRules().getDefensiveScoringRules());
        }

        @Test
        @DisplayName("should save league after configuring defensive scoring")
        void shouldSaveLeagueAfterConfiguration() {
            // Arrange
            ConfigureLeagueScoringUseCase.ConfigureDefensiveCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigureDefensiveCommand(
                            leagueId, adminUserId, 1.0, 2.0, 2.0, 2.0, 6.0, pointsAllowedTiers);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.configureDefensiveScoring(command);

            // Assert
            verify(leagueRepository, times(1)).save(any(League.class));
        }
    }

    @Nested
    @DisplayName("Command Tests")
    class CommandTests {

        @Test
        @DisplayName("ConfigurePPRCommand should have all fields")
        void configurePPRCommandShouldHaveAllFields() {
            // Arrange & Act
            ConfigureLeagueScoringUseCase.ConfigurePPRCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigurePPRCommand(
                            leagueId, adminUserId, 25.0, 10.0, 10.0, 1.0, 6.0);

            // Assert
            assertEquals(leagueId, command.getLeagueId());
            assertEquals(adminUserId, command.getAdminUserId());
            assertEquals(25.0, command.getPassingYardsPerPoint());
            assertEquals(10.0, command.getRushingYardsPerPoint());
            assertEquals(10.0, command.getReceivingYardsPerPoint());
            assertEquals(1.0, command.getReceptionPoints());
            assertEquals(6.0, command.getTouchdownPoints());
        }

        @Test
        @DisplayName("ConfigureFieldGoalCommand should have all fields")
        void configureFieldGoalCommandShouldHaveAllFields() {
            // Arrange & Act
            ConfigureLeagueScoringUseCase.ConfigureFieldGoalCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigureFieldGoalCommand(
                            leagueId, adminUserId, 3.0, 4.0, 5.0);

            // Assert
            assertEquals(leagueId, command.getLeagueId());
            assertEquals(adminUserId, command.getAdminUserId());
            assertEquals(3.0, command.getFg0to39Points());
            assertEquals(4.0, command.getFg40to49Points());
            assertEquals(5.0, command.getFg50PlusPoints());
        }

        @Test
        @DisplayName("ConfigureDefensiveCommand should have all fields")
        void configureDefensiveCommandShouldHaveAllFields() {
            // Arrange
            Map<Integer, Double> tiers = new HashMap<>();
            tiers.put(0, 10.0);

            // Act
            ConfigureLeagueScoringUseCase.ConfigureDefensiveCommand command =
                    new ConfigureLeagueScoringUseCase.ConfigureDefensiveCommand(
                            leagueId, adminUserId, 1.0, 2.0, 2.0, 2.0, 6.0, tiers);

            // Assert
            assertEquals(leagueId, command.getLeagueId());
            assertEquals(adminUserId, command.getAdminUserId());
            assertEquals(1.0, command.getSackPoints());
            assertEquals(2.0, command.getInterceptionPoints());
            assertEquals(2.0, command.getFumbleRecoveryPoints());
            assertEquals(2.0, command.getSafetyPoints());
            assertEquals(6.0, command.getDefensiveTDPoints());
            assertEquals(tiers, command.getPointsAllowedTiers());
        }
    }
}

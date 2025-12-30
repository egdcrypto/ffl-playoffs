package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.model.RosterConfiguration;
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

import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ConfigureLeagueUseCase Tests")
class ConfigureLeagueUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    private ConfigureLeagueUseCase useCase;

    @Captor
    private ArgumentCaptor<League> leagueCaptor;

    private UUID leagueId;
    private UUID ownerId;
    private League league;

    @BeforeEach
    void setUp() {
        useCase = new ConfigureLeagueUseCase(leagueRepository);

        leagueId = UUID.randomUUID();
        ownerId = UUID.randomUUID();

        // Create league
        league = new League();
        league.setId(leagueId);
        league.setName("Test League");
        league.setCode("TEST");
        league.setOwnerId(ownerId);
        league.setStartingWeekAndDuration(15, 3);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should configure league successfully")
        void shouldConfigureLeagueSuccessfully() {
            // Arrange
            ConfigureLeagueUseCase.ConfigureLeagueCommand command =
                    new ConfigureLeagueUseCase.ConfigureLeagueCommand(leagueId, ownerId);
            command.setName("Updated League Name");

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals("Updated League Name", result.getName());

            verify(leagueRepository).save(leagueCaptor.capture());
            assertNotNull(leagueCaptor.getValue());
        }

        @Test
        @DisplayName("should throw exception when league not found")
        void shouldThrowExceptionWhenLeagueNotFound() {
            // Arrange
            UUID unknownLeagueId = UUID.randomUUID();
            ConfigureLeagueUseCase.ConfigureLeagueCommand command =
                    new ConfigureLeagueUseCase.ConfigureLeagueCommand(unknownLeagueId, ownerId);

            when(leagueRepository.findById(unknownLeagueId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("League not found"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when user is not owner")
        void shouldThrowExceptionWhenUserNotOwner() {
            // Arrange
            UUID differentUserId = UUID.randomUUID();
            ConfigureLeagueUseCase.ConfigureLeagueCommand command =
                    new ConfigureLeagueUseCase.ConfigureLeagueCommand(leagueId, differentUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("owner"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should update name if provided")
        void shouldUpdateNameIfProvided() {
            // Arrange
            String newName = "New League Name";
            ConfigureLeagueUseCase.ConfigureLeagueCommand command =
                    new ConfigureLeagueUseCase.ConfigureLeagueCommand(leagueId, ownerId);
            command.setName(newName);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertEquals(newName, result.getName());
        }

        @Test
        @DisplayName("should not update name if not provided")
        void shouldNotUpdateNameIfNotProvided() {
            // Arrange
            String originalName = league.getName();
            ConfigureLeagueUseCase.ConfigureLeagueCommand command =
                    new ConfigureLeagueUseCase.ConfigureLeagueCommand(leagueId, ownerId);
            // name is not set

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertEquals(originalName, result.getName());
        }

        @Test
        @DisplayName("should update description if provided")
        void shouldUpdateDescriptionIfProvided() {
            // Arrange
            String newDescription = "New description";
            ConfigureLeagueUseCase.ConfigureLeagueCommand command =
                    new ConfigureLeagueUseCase.ConfigureLeagueCommand(leagueId, ownerId);
            command.setDescription(newDescription);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertEquals(newDescription, result.getDescription());
        }

        @Test
        @DisplayName("should update starting week if provided")
        void shouldUpdateStartingWeekIfProvided() {
            // Arrange
            int newStartingWeek = 16;
            ConfigureLeagueUseCase.ConfigureLeagueCommand command =
                    new ConfigureLeagueUseCase.ConfigureLeagueCommand(leagueId, ownerId);
            command.setStartingWeek(newStartingWeek);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertEquals(newStartingWeek, result.getStartingWeek());
        }

        @Test
        @DisplayName("should update number of weeks if provided")
        void shouldUpdateNumberOfWeeksIfProvided() {
            // Arrange
            int newNumberOfWeeks = 4;
            ConfigureLeagueUseCase.ConfigureLeagueCommand command =
                    new ConfigureLeagueUseCase.ConfigureLeagueCommand(leagueId, ownerId);
            command.setNumberOfWeeks(newNumberOfWeeks);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertEquals(newNumberOfWeeks, result.getNumberOfWeeks());
        }

        @Test
        @DisplayName("should update both starting week and number of weeks if both provided")
        void shouldUpdateBothWeekFieldsIfBothProvided() {
            // Arrange
            int newStartingWeek = 16;
            int newNumberOfWeeks = 4;
            ConfigureLeagueUseCase.ConfigureLeagueCommand command =
                    new ConfigureLeagueUseCase.ConfigureLeagueCommand(leagueId, ownerId);
            command.setStartingWeek(newStartingWeek);
            command.setNumberOfWeeks(newNumberOfWeeks);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertEquals(newStartingWeek, result.getStartingWeek());
            assertEquals(newNumberOfWeeks, result.getNumberOfWeeks());
        }

        @Test
        @DisplayName("should update roster configuration if provided")
        void shouldUpdateRosterConfigurationIfProvided() {
            // Arrange
            RosterConfiguration newConfig = RosterConfiguration.standardRoster();
            ConfigureLeagueUseCase.ConfigureLeagueCommand command =
                    new ConfigureLeagueUseCase.ConfigureLeagueCommand(leagueId, ownerId);
            command.setRosterConfiguration(newConfig);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertEquals(newConfig, result.getRosterConfiguration());
        }

        @Test
        @DisplayName("should update scoring rules if provided")
        void shouldUpdateScoringRulesIfProvided() {
            // Arrange
            ScoringRules newRules = ScoringRules.standardRules();
            ConfigureLeagueUseCase.ConfigureLeagueCommand command =
                    new ConfigureLeagueUseCase.ConfigureLeagueCommand(leagueId, ownerId);
            command.setScoringRules(newRules);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertNotNull(result.getScoringRules());
        }

        @Test
        @DisplayName("should save league after configuration")
        void shouldSaveLeagueAfterConfiguration() {
            // Arrange
            ConfigureLeagueUseCase.ConfigureLeagueCommand command =
                    new ConfigureLeagueUseCase.ConfigureLeagueCommand(leagueId, ownerId);
            command.setName("Updated Name");

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(leagueRepository, times(1)).save(any(League.class));
        }

        @Test
        @DisplayName("should throw ConfigurationLockedException when league is locked")
        void shouldThrowExceptionWhenLeagueLocked() {
            // Arrange
            League lockedLeague = new League();
            lockedLeague.setId(leagueId);
            lockedLeague.setName("Test League");
            lockedLeague.setCode("TEST");
            lockedLeague.setOwnerId(ownerId);
            lockedLeague.setStartingWeekAndDuration(15, 3);
            lockedLeague.lockConfiguration(java.time.LocalDateTime.now().minusDays(1), "Testing");

            ConfigureLeagueUseCase.ConfigureLeagueCommand command =
                    new ConfigureLeagueUseCase.ConfigureLeagueCommand(leagueId, ownerId);
            command.setName("New Name");

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(lockedLeague));

            // Act & Assert
            League.ConfigurationLockedException exception = assertThrows(
                    League.ConfigurationLockedException.class,
                    () -> useCase.execute(command)
            );

            assertNotNull(exception);
            verify(leagueRepository, never()).save(any());
        }
    }

    @Nested
    @DisplayName("ConfigureLeagueCommand")
    class CommandTests {

        @Test
        @DisplayName("should create command with required fields")
        void shouldCreateCommandWithRequiredFields() {
            // Arrange & Act
            ConfigureLeagueUseCase.ConfigureLeagueCommand command =
                    new ConfigureLeagueUseCase.ConfigureLeagueCommand(leagueId, ownerId);

            // Assert
            assertEquals(leagueId, command.getLeagueId());
            assertEquals(ownerId, command.getOwnerId());
        }

        @Test
        @DisplayName("should set optional fields")
        void shouldSetOptionalFields() {
            // Arrange
            ConfigureLeagueUseCase.ConfigureLeagueCommand command =
                    new ConfigureLeagueUseCase.ConfigureLeagueCommand(leagueId, ownerId);

            RosterConfiguration config = RosterConfiguration.standardRoster();
            ScoringRules rules = ScoringRules.standardRules();

            // Act
            command.setName("Test Name");
            command.setDescription("Test Description");
            command.setStartingWeek(16);
            command.setNumberOfWeeks(4);
            command.setRosterConfiguration(config);
            command.setScoringRules(rules);

            // Assert
            assertEquals("Test Name", command.getName());
            assertEquals("Test Description", command.getDescription());
            assertEquals(16, command.getStartingWeek());
            assertEquals(4, command.getNumberOfWeeks());
            assertEquals(config, command.getRosterConfiguration());
            assertEquals(rules, command.getScoringRules());
        }
    }
}

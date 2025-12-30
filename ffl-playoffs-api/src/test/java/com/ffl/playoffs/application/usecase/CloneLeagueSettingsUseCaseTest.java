package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.model.LeagueStatus;
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
@DisplayName("CloneLeagueSettingsUseCase Tests")
class CloneLeagueSettingsUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    private CloneLeagueSettingsUseCase useCase;

    @Captor
    private ArgumentCaptor<League> leagueCaptor;

    private UUID sourceLeagueId;
    private UUID adminUserId;
    private String newLeagueName;
    private String newLeagueCode;
    private League sourceLeague;

    @BeforeEach
    void setUp() {
        useCase = new CloneLeagueSettingsUseCase(leagueRepository);

        sourceLeagueId = UUID.randomUUID();
        adminUserId = UUID.randomUUID();
        newLeagueName = "New Cloned League";
        newLeagueCode = "NEWCODE";

        // Create source league
        sourceLeague = new League();
        sourceLeague.setId(sourceLeagueId);
        sourceLeague.setName("Source League");
        sourceLeague.setCode("SOURCE");
        sourceLeague.setOwnerId(adminUserId);
        sourceLeague.setStartingWeekAndDuration(15, 3);
        sourceLeague.setDescription("Original league description");
        sourceLeague.setRosterConfiguration(RosterConfiguration.standardRoster());
        sourceLeague.setScoringRules(ScoringRules.standardRules());
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should clone league settings successfully")
        void shouldCloneLeagueSuccessfully() {
            // Arrange
            CloneLeagueSettingsUseCase.CloneLeagueCommand command =
                    new CloneLeagueSettingsUseCase.CloneLeagueCommand(
                            sourceLeagueId, newLeagueName, newLeagueCode, adminUserId);

            when(leagueRepository.findById(sourceLeagueId)).thenReturn(Optional.of(sourceLeague));
            when(leagueRepository.existsByCode(newLeagueCode)).thenReturn(false);
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(newLeagueName, result.getName());
            assertEquals(newLeagueCode, result.getCode());
            assertEquals(adminUserId, result.getOwnerId());
            assertEquals(LeagueStatus.DRAFT, result.getStatus());

            verify(leagueRepository).save(leagueCaptor.capture());
            assertNotNull(leagueCaptor.getValue());
        }

        @Test
        @DisplayName("should throw exception when source league not found")
        void shouldThrowExceptionWhenSourceNotFound() {
            // Arrange
            UUID unknownSourceId = UUID.randomUUID();
            CloneLeagueSettingsUseCase.CloneLeagueCommand command =
                    new CloneLeagueSettingsUseCase.CloneLeagueCommand(
                            unknownSourceId, newLeagueName, newLeagueCode, adminUserId);

            when(leagueRepository.findById(unknownSourceId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Source league not found"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw UnauthorizedLeagueAccessException when admin doesn't own source")
        void shouldThrowExceptionWhenAdminDoesntOwnSource() {
            // Arrange
            UUID differentAdminId = UUID.randomUUID();
            CloneLeagueSettingsUseCase.CloneLeagueCommand command =
                    new CloneLeagueSettingsUseCase.CloneLeagueCommand(
                            sourceLeagueId, newLeagueName, newLeagueCode, differentAdminId);

            when(leagueRepository.findById(sourceLeagueId)).thenReturn(Optional.of(sourceLeague));

            // Act & Assert
            CloneLeagueSettingsUseCase.UnauthorizedLeagueAccessException exception = assertThrows(
                    CloneLeagueSettingsUseCase.UnauthorizedLeagueAccessException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("does not own"));
            assertEquals("UNAUTHORIZED_LEAGUE_ACCESS", exception.getErrorCode());
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when new league code already exists")
        void shouldThrowExceptionWhenCodeExists() {
            // Arrange
            CloneLeagueSettingsUseCase.CloneLeagueCommand command =
                    new CloneLeagueSettingsUseCase.CloneLeagueCommand(
                            sourceLeagueId, newLeagueName, newLeagueCode, adminUserId);

            when(leagueRepository.findById(sourceLeagueId)).thenReturn(Optional.of(sourceLeague));
            when(leagueRepository.existsByCode(newLeagueCode)).thenReturn(true);

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("already exists"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should clone roster configuration from source")
        void shouldCloneRosterConfiguration() {
            // Arrange
            CloneLeagueSettingsUseCase.CloneLeagueCommand command =
                    new CloneLeagueSettingsUseCase.CloneLeagueCommand(
                            sourceLeagueId, newLeagueName, newLeagueCode, adminUserId);

            when(leagueRepository.findById(sourceLeagueId)).thenReturn(Optional.of(sourceLeague));
            when(leagueRepository.existsByCode(newLeagueCode)).thenReturn(false);
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertNotNull(result.getRosterConfiguration());
            assertEquals(sourceLeague.getRosterConfiguration(), result.getRosterConfiguration());
        }

        @Test
        @DisplayName("should clone scoring rules from source")
        void shouldCloneScoringRules() {
            // Arrange
            CloneLeagueSettingsUseCase.CloneLeagueCommand command =
                    new CloneLeagueSettingsUseCase.CloneLeagueCommand(
                            sourceLeagueId, newLeagueName, newLeagueCode, adminUserId);

            when(leagueRepository.findById(sourceLeagueId)).thenReturn(Optional.of(sourceLeague));
            when(leagueRepository.existsByCode(newLeagueCode)).thenReturn(false);
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertNotNull(result.getScoringRules());
        }

        @Test
        @DisplayName("should use custom description if provided")
        void shouldUseCustomDescription() {
            // Arrange
            String customDescription = "My custom description";
            CloneLeagueSettingsUseCase.CloneLeagueCommand command =
                    new CloneLeagueSettingsUseCase.CloneLeagueCommand(
                            sourceLeagueId, newLeagueName, newLeagueCode, adminUserId);
            command.setDescription(customDescription);

            when(leagueRepository.findById(sourceLeagueId)).thenReturn(Optional.of(sourceLeague));
            when(leagueRepository.existsByCode(newLeagueCode)).thenReturn(false);
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertEquals(customDescription, result.getDescription());
        }

        @Test
        @DisplayName("should use default cloned description when not provided")
        void shouldUseDefaultClonedDescription() {
            // Arrange
            CloneLeagueSettingsUseCase.CloneLeagueCommand command =
                    new CloneLeagueSettingsUseCase.CloneLeagueCommand(
                            sourceLeagueId, newLeagueName, newLeagueCode, adminUserId);

            when(leagueRepository.findById(sourceLeagueId)).thenReturn(Optional.of(sourceLeague));
            when(leagueRepository.existsByCode(newLeagueCode)).thenReturn(false);
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertTrue(result.getDescription().contains("Cloned from"));
        }

        @Test
        @DisplayName("should use custom starting week if provided")
        void shouldUseCustomStartingWeek() {
            // Arrange
            int customStartingWeek = 16;
            CloneLeagueSettingsUseCase.CloneLeagueCommand command =
                    new CloneLeagueSettingsUseCase.CloneLeagueCommand(
                            sourceLeagueId, newLeagueName, newLeagueCode, adminUserId);
            command.setStartingWeek(customStartingWeek);

            when(leagueRepository.findById(sourceLeagueId)).thenReturn(Optional.of(sourceLeague));
            when(leagueRepository.existsByCode(newLeagueCode)).thenReturn(false);
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertEquals(customStartingWeek, result.getStartingWeek());
        }

        @Test
        @DisplayName("should use source starting week when not provided")
        void shouldUseSourceStartingWeek() {
            // Arrange
            CloneLeagueSettingsUseCase.CloneLeagueCommand command =
                    new CloneLeagueSettingsUseCase.CloneLeagueCommand(
                            sourceLeagueId, newLeagueName, newLeagueCode, adminUserId);

            when(leagueRepository.findById(sourceLeagueId)).thenReturn(Optional.of(sourceLeague));
            when(leagueRepository.existsByCode(newLeagueCode)).thenReturn(false);
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertEquals(sourceLeague.getStartingWeek(), result.getStartingWeek());
        }

        @Test
        @DisplayName("should use custom number of weeks if provided")
        void shouldUseCustomNumberOfWeeks() {
            // Arrange
            int customNumberOfWeeks = 4;
            CloneLeagueSettingsUseCase.CloneLeagueCommand command =
                    new CloneLeagueSettingsUseCase.CloneLeagueCommand(
                            sourceLeagueId, newLeagueName, newLeagueCode, adminUserId);
            command.setNumberOfWeeks(customNumberOfWeeks);

            when(leagueRepository.findById(sourceLeagueId)).thenReturn(Optional.of(sourceLeague));
            when(leagueRepository.existsByCode(newLeagueCode)).thenReturn(false);
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.execute(command);

            // Assert
            assertEquals(customNumberOfWeeks, result.getNumberOfWeeks());
        }

        @Test
        @DisplayName("should save new league")
        void shouldSaveNewLeague() {
            // Arrange
            CloneLeagueSettingsUseCase.CloneLeagueCommand command =
                    new CloneLeagueSettingsUseCase.CloneLeagueCommand(
                            sourceLeagueId, newLeagueName, newLeagueCode, adminUserId);

            when(leagueRepository.findById(sourceLeagueId)).thenReturn(Optional.of(sourceLeague));
            when(leagueRepository.existsByCode(newLeagueCode)).thenReturn(false);
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(leagueRepository, times(1)).save(any(League.class));
        }
    }

    @Nested
    @DisplayName("CloneLeagueCommand")
    class CommandTests {

        @Test
        @DisplayName("should create command with required fields")
        void shouldCreateCommandWithRequiredFields() {
            // Arrange & Act
            CloneLeagueSettingsUseCase.CloneLeagueCommand command =
                    new CloneLeagueSettingsUseCase.CloneLeagueCommand(
                            sourceLeagueId, newLeagueName, newLeagueCode, adminUserId);

            // Assert
            assertEquals(sourceLeagueId, command.getSourceLeagueId());
            assertEquals(newLeagueName, command.getNewLeagueName());
            assertEquals(newLeagueCode, command.getNewLeagueCode());
            assertEquals(adminUserId, command.getAdminUserId());
        }

        @Test
        @DisplayName("should set optional fields")
        void shouldSetOptionalFields() {
            // Arrange
            CloneLeagueSettingsUseCase.CloneLeagueCommand command =
                    new CloneLeagueSettingsUseCase.CloneLeagueCommand(
                            sourceLeagueId, newLeagueName, newLeagueCode, adminUserId);

            // Act
            command.setDescription("Test description");
            command.setStartingWeek(16);
            command.setNumberOfWeeks(4);

            // Assert
            assertEquals("Test description", command.getDescription());
            assertEquals(16, command.getStartingWeek());
            assertEquals(4, command.getNumberOfWeeks());
        }
    }
}

package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
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
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ValidateConfigurationLockUseCase Tests")
class ValidateConfigurationLockUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    private ValidateConfigurationLockUseCase useCase;

    @Captor
    private ArgumentCaptor<League> leagueCaptor;

    private UUID leagueId;
    private UUID ownerId;
    private League league;

    @BeforeEach
    void setUp() {
        useCase = new ValidateConfigurationLockUseCase(leagueRepository);

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
    @DisplayName("execute (validate lock status)")
    class Execute {

        @Test
        @DisplayName("should return lock status for locked league")
        void shouldReturnLockStatusForLockedLeague() {
            // Arrange
            LocalDateTime lockTime = LocalDateTime.now().minusDays(1);
            league.lockConfiguration(lockTime, "TEST_REASON");

            ValidateConfigurationLockUseCase.ValidateConfigurationLockQuery query =
                    new ValidateConfigurationLockUseCase.ValidateConfigurationLockQuery(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act
            ValidateConfigurationLockUseCase.ConfigurationLockStatus result = useCase.execute(query);

            // Assert
            assertNotNull(result);
            assertTrue(result.isLocked());
            assertEquals(leagueId, result.getLeagueId());
            assertEquals("TEST_REASON", result.getLockReason());
        }

        @Test
        @DisplayName("should return lock status for unlocked league")
        void shouldReturnLockStatusForUnlockedLeague() {
            // Arrange
            ValidateConfigurationLockUseCase.ValidateConfigurationLockQuery query =
                    new ValidateConfigurationLockUseCase.ValidateConfigurationLockQuery(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act
            ValidateConfigurationLockUseCase.ConfigurationLockStatus result = useCase.execute(query);

            // Assert
            assertNotNull(result);
            assertFalse(result.isLocked());
            assertEquals(leagueId, result.getLeagueId());
        }

        @Test
        @DisplayName("should throw exception when league not found")
        void shouldThrowExceptionWhenLeagueNotFound() {
            // Arrange
            UUID unknownLeagueId = UUID.randomUUID();
            ValidateConfigurationLockUseCase.ValidateConfigurationLockQuery query =
                    new ValidateConfigurationLockUseCase.ValidateConfigurationLockQuery(unknownLeagueId);

            when(leagueRepository.findById(unknownLeagueId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(query)
            );

            assertTrue(exception.getMessage().contains("League not found"));
        }

        @Test
        @DisplayName("should use custom check time when provided")
        void shouldUseCustomCheckTime() {
            // Arrange
            LocalDateTime customCheckTime = LocalDateTime.of(2024, 1, 15, 14, 0);
            ValidateConfigurationLockUseCase.ValidateConfigurationLockQuery query =
                    new ValidateConfigurationLockUseCase.ValidateConfigurationLockQuery(leagueId);
            query.setCheckTime(customCheckTime);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act
            ValidateConfigurationLockUseCase.ConfigurationLockStatus result = useCase.execute(query);

            // Assert - just verifying it doesn't throw and returns result
            assertNotNull(result);
        }

        @Test
        @DisplayName("should return first game start time")
        void shouldReturnFirstGameStartTime() {
            // Arrange
            LocalDateTime gameStartTime = LocalDateTime.of(2024, 1, 20, 13, 0);
            league.setFirstGameStartTime(gameStartTime);

            ValidateConfigurationLockUseCase.ValidateConfigurationLockQuery query =
                    new ValidateConfigurationLockUseCase.ValidateConfigurationLockQuery(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act
            ValidateConfigurationLockUseCase.ConfigurationLockStatus result = useCase.execute(query);

            // Assert
            assertEquals(gameStartTime, result.getFirstGameStartTime());
        }
    }

    @Nested
    @DisplayName("lockConfiguration")
    class LockConfiguration {

        @Test
        @DisplayName("should lock configuration successfully")
        void shouldLockConfigurationSuccessfully() {
            // Arrange
            ValidateConfigurationLockUseCase.LockConfigurationCommand command =
                    new ValidateConfigurationLockUseCase.LockConfigurationCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.lockConfiguration(command);

            // Assert
            assertNotNull(result);
            assertTrue(result.isConfigurationLocked(LocalDateTime.now()));
        }

        @Test
        @DisplayName("should throw exception when league not found")
        void shouldThrowExceptionWhenLeagueNotFound() {
            // Arrange
            UUID unknownLeagueId = UUID.randomUUID();
            ValidateConfigurationLockUseCase.LockConfigurationCommand command =
                    new ValidateConfigurationLockUseCase.LockConfigurationCommand(unknownLeagueId);

            when(leagueRepository.findById(unknownLeagueId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.lockConfiguration(command)
            );

            assertTrue(exception.getMessage().contains("League not found"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should use provided lock time")
        void shouldUseProvidedLockTime() {
            // Arrange
            LocalDateTime customLockTime = LocalDateTime.of(2024, 1, 15, 14, 0);
            ValidateConfigurationLockUseCase.LockConfigurationCommand command =
                    new ValidateConfigurationLockUseCase.LockConfigurationCommand(leagueId);
            command.setLockTime(customLockTime);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.lockConfiguration(command);

            // Assert
            assertEquals(customLockTime, result.getConfigurationLockedAt());
        }

        @Test
        @DisplayName("should use default lock reason when not provided")
        void shouldUseDefaultLockReason() {
            // Arrange
            ValidateConfigurationLockUseCase.LockConfigurationCommand command =
                    new ValidateConfigurationLockUseCase.LockConfigurationCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.lockConfiguration(command);

            // Assert
            assertEquals("FIRST_GAME_STARTED", result.getLockReason());
        }

        @Test
        @DisplayName("should use provided lock reason")
        void shouldUseProvidedLockReason() {
            // Arrange
            ValidateConfigurationLockUseCase.LockConfigurationCommand command =
                    new ValidateConfigurationLockUseCase.LockConfigurationCommand(leagueId);
            command.setLockReason("ADMIN_LOCKED");

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.lockConfiguration(command);

            // Assert
            assertEquals("ADMIN_LOCKED", result.getLockReason());
        }

        @Test
        @DisplayName("should save league to repository")
        void shouldSaveLeagueToRepository() {
            // Arrange
            ValidateConfigurationLockUseCase.LockConfigurationCommand command =
                    new ValidateConfigurationLockUseCase.LockConfigurationCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.lockConfiguration(command);

            // Assert
            verify(leagueRepository, times(1)).save(leagueCaptor.capture());
            League savedLeague = leagueCaptor.getValue();
            assertTrue(savedLeague.isConfigurationLocked(LocalDateTime.now()));
        }
    }

    @Nested
    @DisplayName("ValidateConfigurationLockQuery")
    class ValidateConfigurationLockQueryTests {

        @Test
        @DisplayName("should create query with league ID")
        void shouldCreateQueryWithLeagueId() {
            // Arrange & Act
            ValidateConfigurationLockUseCase.ValidateConfigurationLockQuery query =
                    new ValidateConfigurationLockUseCase.ValidateConfigurationLockQuery(leagueId);

            // Assert
            assertEquals(leagueId, query.getLeagueId());
            assertNull(query.getCheckTime());
        }

        @Test
        @DisplayName("should set check time")
        void shouldSetCheckTime() {
            // Arrange
            LocalDateTime checkTime = LocalDateTime.now();
            ValidateConfigurationLockUseCase.ValidateConfigurationLockQuery query =
                    new ValidateConfigurationLockUseCase.ValidateConfigurationLockQuery(leagueId);

            // Act
            query.setCheckTime(checkTime);

            // Assert
            assertEquals(checkTime, query.getCheckTime());
        }
    }

    @Nested
    @DisplayName("LockConfigurationCommand")
    class LockConfigurationCommandTests {

        @Test
        @DisplayName("should create command with league ID")
        void shouldCreateCommandWithLeagueId() {
            // Arrange & Act
            ValidateConfigurationLockUseCase.LockConfigurationCommand command =
                    new ValidateConfigurationLockUseCase.LockConfigurationCommand(leagueId);

            // Assert
            assertEquals(leagueId, command.getLeagueId());
            assertNull(command.getLockTime());
            assertNull(command.getLockReason());
        }

        @Test
        @DisplayName("should set optional fields")
        void shouldSetOptionalFields() {
            // Arrange
            LocalDateTime lockTime = LocalDateTime.now();
            String lockReason = "TEST_REASON";

            ValidateConfigurationLockUseCase.LockConfigurationCommand command =
                    new ValidateConfigurationLockUseCase.LockConfigurationCommand(leagueId);

            // Act
            command.setLockTime(lockTime);
            command.setLockReason(lockReason);

            // Assert
            assertEquals(lockTime, command.getLockTime());
            assertEquals(lockReason, command.getLockReason());
        }
    }

    @Nested
    @DisplayName("ConfigurationLockStatus")
    class ConfigurationLockStatusTests {

        @Test
        @DisplayName("should create status with all fields")
        void shouldCreateStatusWithAllFields() {
            // Arrange
            LocalDateTime lockedAt = LocalDateTime.now();
            LocalDateTime firstGameStart = LocalDateTime.now().plusDays(1);

            // Act
            ValidateConfigurationLockUseCase.ConfigurationLockStatus status =
                    new ValidateConfigurationLockUseCase.ConfigurationLockStatus(
                            leagueId, true, lockedAt, "TEST_REASON", firstGameStart);

            // Assert
            assertEquals(leagueId, status.getLeagueId());
            assertTrue(status.isLocked());
            assertEquals(lockedAt, status.getLockedAt());
            assertEquals("TEST_REASON", status.getLockReason());
            assertEquals(firstGameStart, status.getFirstGameStartTime());
        }
    }
}

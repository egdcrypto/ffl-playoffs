package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.model.PlayerInvitation;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.PlayerInvitationRepository;
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
@DisplayName("InvitePlayerToLeagueUseCase Tests")
class InvitePlayerToLeagueUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    @Mock
    private PlayerInvitationRepository invitationRepository;

    private InvitePlayerToLeagueUseCase useCase;

    @Captor
    private ArgumentCaptor<PlayerInvitation> invitationCaptor;

    private UUID leagueId;
    private UUID adminUserId;
    private String playerEmail;
    private League league;

    @BeforeEach
    void setUp() {
        useCase = new InvitePlayerToLeagueUseCase(leagueRepository, invitationRepository);

        leagueId = UUID.randomUUID();
        adminUserId = UUID.randomUUID();
        playerEmail = "player@example.com";

        // Create league
        league = new League();
        league.setId(leagueId);
        league.setName("Test League");
        league.setCode("TEST");
        league.setOwnerId(adminUserId);
        league.setStartingWeekAndDuration(15, 3);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should create invitation successfully")
        void shouldCreateInvitationSuccessfully() {
            // Arrange
            InvitePlayerToLeagueUseCase.InvitePlayerCommand command =
                    new InvitePlayerToLeagueUseCase.InvitePlayerCommand(leagueId, playerEmail, adminUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(invitationRepository.existsPendingByEmailAndLeague(playerEmail, leagueId)).thenReturn(false);
            when(invitationRepository.save(any(PlayerInvitation.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            PlayerInvitation result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(leagueId, result.getLeagueId());
            assertEquals(playerEmail, result.getEmail());
            assertEquals(adminUserId, result.getInvitedByUserId());
        }

        @Test
        @DisplayName("should throw exception when league not found")
        void shouldThrowExceptionWhenLeagueNotFound() {
            // Arrange
            UUID unknownLeagueId = UUID.randomUUID();
            InvitePlayerToLeagueUseCase.InvitePlayerCommand command =
                    new InvitePlayerToLeagueUseCase.InvitePlayerCommand(unknownLeagueId, playerEmail, adminUserId);

            when(leagueRepository.findById(unknownLeagueId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("League not found"));
            verify(invitationRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw UnauthorizedLeagueAccessException when not owner")
        void shouldThrowExceptionWhenNotOwner() {
            // Arrange
            UUID differentUserId = UUID.randomUUID();
            InvitePlayerToLeagueUseCase.InvitePlayerCommand command =
                    new InvitePlayerToLeagueUseCase.InvitePlayerCommand(leagueId, playerEmail, differentUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act & Assert
            InvitePlayerToLeagueUseCase.UnauthorizedLeagueAccessException exception = assertThrows(
                    InvitePlayerToLeagueUseCase.UnauthorizedLeagueAccessException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("does not own"));
            assertEquals("UNAUTHORIZED_LEAGUE_ACCESS", exception.getErrorCode());
            verify(invitationRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw DuplicateInvitationException when pending invitation exists")
        void shouldThrowExceptionWhenDuplicateInvitation() {
            // Arrange
            InvitePlayerToLeagueUseCase.InvitePlayerCommand command =
                    new InvitePlayerToLeagueUseCase.InvitePlayerCommand(leagueId, playerEmail, adminUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(invitationRepository.existsPendingByEmailAndLeague(playerEmail, leagueId)).thenReturn(true);

            // Act & Assert
            InvitePlayerToLeagueUseCase.DuplicateInvitationException exception = assertThrows(
                    InvitePlayerToLeagueUseCase.DuplicateInvitationException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("already exists"));
            assertEquals("INVITATION_ALREADY_EXISTS", exception.getErrorCode());
            verify(invitationRepository, never()).save(any());
        }

        @Test
        @DisplayName("should set invitation properties correctly")
        void shouldSetInvitationPropertiesCorrectly() {
            // Arrange
            InvitePlayerToLeagueUseCase.InvitePlayerCommand command =
                    new InvitePlayerToLeagueUseCase.InvitePlayerCommand(leagueId, playerEmail, adminUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(invitationRepository.existsPendingByEmailAndLeague(playerEmail, leagueId)).thenReturn(false);
            when(invitationRepository.save(any(PlayerInvitation.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            PlayerInvitation result = useCase.execute(command);

            // Assert
            assertNotNull(result.getId());
            assertEquals(leagueId, result.getLeagueId());
            assertEquals(league.getName(), result.getLeagueName());
            assertEquals(playerEmail, result.getEmail());
            assertEquals(adminUserId, result.getInvitedByUserId());
            assertNotNull(result.getInvitationToken());
            assertEquals(PlayerInvitation.InvitationStatus.PENDING, result.getStatus());
            assertNotNull(result.getCreatedAt());
            assertNotNull(result.getExpiresAt());
        }

        @Test
        @DisplayName("should save invitation to repository")
        void shouldSaveInvitationToRepository() {
            // Arrange
            InvitePlayerToLeagueUseCase.InvitePlayerCommand command =
                    new InvitePlayerToLeagueUseCase.InvitePlayerCommand(leagueId, playerEmail, adminUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(invitationRepository.existsPendingByEmailAndLeague(playerEmail, leagueId)).thenReturn(false);
            when(invitationRepository.save(any(PlayerInvitation.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(invitationRepository, times(1)).save(invitationCaptor.capture());
            PlayerInvitation savedInvitation = invitationCaptor.getValue();
            assertEquals(leagueId, savedInvitation.getLeagueId());
            assertEquals(playerEmail, savedInvitation.getEmail());
        }

        @Test
        @DisplayName("should generate unique invitation token")
        void shouldGenerateUniqueInvitationToken() {
            // Arrange
            InvitePlayerToLeagueUseCase.InvitePlayerCommand command =
                    new InvitePlayerToLeagueUseCase.InvitePlayerCommand(leagueId, playerEmail, adminUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(invitationRepository.existsPendingByEmailAndLeague(playerEmail, leagueId)).thenReturn(false);
            when(invitationRepository.save(any(PlayerInvitation.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            PlayerInvitation result = useCase.execute(command);

            // Assert
            assertNotNull(result.getInvitationToken());
            assertTrue(result.getInvitationToken().startsWith("inv_"));
        }
    }

    @Nested
    @DisplayName("InvitePlayerCommand")
    class InvitePlayerCommandTests {

        @Test
        @DisplayName("should create command with all fields")
        void shouldCreateCommandWithAllFields() {
            // Arrange & Act
            InvitePlayerToLeagueUseCase.InvitePlayerCommand command =
                    new InvitePlayerToLeagueUseCase.InvitePlayerCommand(leagueId, playerEmail, adminUserId);

            // Assert
            assertEquals(leagueId, command.getLeagueId());
            assertEquals(playerEmail, command.getEmail());
            assertEquals(adminUserId, command.getAdminUserId());
        }
    }
}

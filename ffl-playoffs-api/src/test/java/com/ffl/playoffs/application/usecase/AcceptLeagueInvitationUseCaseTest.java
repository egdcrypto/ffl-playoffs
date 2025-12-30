package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.model.PlayerInvitation;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.PlayerInvitationRepository;
import com.ffl.playoffs.domain.port.UserRepository;
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
@DisplayName("AcceptLeagueInvitationUseCase Tests")
class AcceptLeagueInvitationUseCaseTest {

    @Mock
    private PlayerInvitationRepository invitationRepository;

    @Mock
    private LeagueRepository leagueRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private LeaguePlayerRepository leaguePlayerRepository;

    private AcceptLeagueInvitationUseCase useCase;

    @Captor
    private ArgumentCaptor<User> userCaptor;

    @Captor
    private ArgumentCaptor<LeaguePlayer> leaguePlayerCaptor;

    @Captor
    private ArgumentCaptor<PlayerInvitation> invitationCaptor;

    private String invitationToken;
    private String email;
    private String displayName;
    private String googleId;
    private UUID leagueId;
    private PlayerInvitation pendingInvitation;
    private League league;

    @BeforeEach
    void setUp() {
        useCase = new AcceptLeagueInvitationUseCase(
                invitationRepository, leagueRepository, userRepository, leaguePlayerRepository);

        invitationToken = "inv_test-token-12345";
        email = "player@test.com";
        displayName = "Test Player";
        googleId = "google-id-xyz";
        leagueId = UUID.randomUUID();

        // Create pending invitation
        pendingInvitation = new PlayerInvitation();
        pendingInvitation.setLeagueId(leagueId);
        pendingInvitation.setEmail(email);
        pendingInvitation.setInvitationToken(invitationToken);

        // Create league
        league = new League();
        league.setId(leagueId);
        league.setName("Test League");
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should accept invitation for new user successfully")
        void shouldAcceptInvitationForNewUser() {
            // Arrange
            AcceptLeagueInvitationUseCase.AcceptInvitationCommand command =
                    new AcceptLeagueInvitationUseCase.AcceptInvitationCommand(
                            invitationToken, email, displayName, googleId);

            when(invitationRepository.findByToken(invitationToken)).thenReturn(Optional.of(pendingInvitation));
            when(userRepository.findByEmail(email)).thenReturn(Optional.empty());
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));
            when(invitationRepository.save(any(PlayerInvitation.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leaguePlayerRepository.findByUserIdAndLeagueId(any(), eq(leagueId))).thenReturn(Optional.empty());
            when(leaguePlayerRepository.save(any(LeaguePlayer.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act
            AcceptLeagueInvitationUseCase.AcceptInvitationResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertTrue(result.isNewUser());
            assertEquals(email, result.getUser().getEmail());
            assertEquals(displayName, result.getUser().getName());
            assertEquals(googleId, result.getUser().getGoogleId());
            assertEquals(Role.PLAYER, result.getUser().getRole());

            verify(userRepository).save(userCaptor.capture());
            assertEquals(email, userCaptor.getValue().getEmail());
        }

        @Test
        @DisplayName("should accept invitation for existing user successfully")
        void shouldAcceptInvitationForExistingUser() {
            // Arrange
            User existingUser = new User();
            existingUser.setEmail(email);
            existingUser.setName("Existing User");
            existingUser.setGoogleId(googleId);
            existingUser.setRole(Role.PLAYER);

            AcceptLeagueInvitationUseCase.AcceptInvitationCommand command =
                    new AcceptLeagueInvitationUseCase.AcceptInvitationCommand(
                            invitationToken, email, displayName, googleId);

            when(invitationRepository.findByToken(invitationToken)).thenReturn(Optional.of(pendingInvitation));
            when(userRepository.findByEmail(email)).thenReturn(Optional.of(existingUser));
            when(invitationRepository.save(any(PlayerInvitation.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leaguePlayerRepository.findByUserIdAndLeagueId(any(), eq(leagueId))).thenReturn(Optional.empty());
            when(leaguePlayerRepository.save(any(LeaguePlayer.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act
            AcceptLeagueInvitationUseCase.AcceptInvitationResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertFalse(result.isNewUser());
            assertEquals(existingUser, result.getUser());
        }

        @Test
        @DisplayName("should throw exception when invitation not found")
        void shouldThrowExceptionWhenInvitationNotFound() {
            // Arrange
            String unknownToken = "inv_unknown-token";
            AcceptLeagueInvitationUseCase.AcceptInvitationCommand command =
                    new AcceptLeagueInvitationUseCase.AcceptInvitationCommand(
                            unknownToken, email, displayName, googleId);

            when(invitationRepository.findByToken(unknownToken)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Invitation not found"));
            verify(userRepository, never()).save(any());
            verify(leaguePlayerRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when email does not match invitation")
        void shouldThrowExceptionWhenEmailMismatch() {
            // Arrange
            String differentEmail = "different@test.com";
            AcceptLeagueInvitationUseCase.AcceptInvitationCommand command =
                    new AcceptLeagueInvitationUseCase.AcceptInvitationCommand(
                            invitationToken, differentEmail, displayName, googleId);

            when(invitationRepository.findByToken(invitationToken)).thenReturn(Optional.of(pendingInvitation));

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Email does not match"));
            verify(userRepository, never()).save(any());
            verify(leaguePlayerRepository, never()).save(any());
        }

        @Test
        @DisplayName("should update Google ID for existing user if missing")
        void shouldUpdateGoogleIdForExistingUser() {
            // Arrange
            User existingUserWithoutGoogleId = new User();
            existingUserWithoutGoogleId.setEmail(email);
            existingUserWithoutGoogleId.setName("Existing User");
            existingUserWithoutGoogleId.setRole(Role.PLAYER);
            // GoogleId is null

            AcceptLeagueInvitationUseCase.AcceptInvitationCommand command =
                    new AcceptLeagueInvitationUseCase.AcceptInvitationCommand(
                            invitationToken, email, displayName, googleId);

            when(invitationRepository.findByToken(invitationToken)).thenReturn(Optional.of(pendingInvitation));
            when(userRepository.findByEmail(email)).thenReturn(Optional.of(existingUserWithoutGoogleId));
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));
            when(invitationRepository.save(any(PlayerInvitation.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leaguePlayerRepository.findByUserIdAndLeagueId(any(), eq(leagueId))).thenReturn(Optional.empty());
            when(leaguePlayerRepository.save(any(LeaguePlayer.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act
            AcceptLeagueInvitationUseCase.AcceptInvitationResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(googleId, result.getUser().getGoogleId());
            verify(userRepository).save(userCaptor.capture());
            assertEquals(googleId, userCaptor.getValue().getGoogleId());
        }

        @Test
        @DisplayName("should throw exception when trying to reactivate removed membership")
        void shouldThrowExceptionWhenReactivatingRemovedMembership() {
            // Arrange
            // Note: The use case attempts to reactivate REMOVED players, but
            // LeaguePlayer.reactivate() only works for INACTIVE status. This test
            // verifies the current behavior (exception is thrown).
            User existingUser = new User();
            existingUser.setEmail(email);
            existingUser.setName("Existing User");
            existingUser.setGoogleId(googleId);
            existingUser.setRole(Role.PLAYER);

            LeaguePlayer removedMembership = new LeaguePlayer(existingUser.getId(), leagueId);
            removedMembership.setStatus(LeaguePlayer.LeaguePlayerStatus.REMOVED);

            AcceptLeagueInvitationUseCase.AcceptInvitationCommand command =
                    new AcceptLeagueInvitationUseCase.AcceptInvitationCommand(
                            invitationToken, email, displayName, googleId);

            when(invitationRepository.findByToken(invitationToken)).thenReturn(Optional.of(pendingInvitation));
            when(userRepository.findByEmail(email)).thenReturn(Optional.of(existingUser));
            when(invitationRepository.save(any(PlayerInvitation.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leaguePlayerRepository.findByUserIdAndLeagueId(existingUser.getId(), leagueId))
                    .thenReturn(Optional.of(removedMembership));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("INACTIVE"));
        }

        @Test
        @DisplayName("should reactivate existing inactive league membership")
        void shouldReactivateInactiveMembership() {
            // Arrange
            User existingUser = new User();
            existingUser.setEmail(email);
            existingUser.setName("Existing User");
            existingUser.setGoogleId(googleId);
            existingUser.setRole(Role.PLAYER);

            LeaguePlayer inactiveMembership = new LeaguePlayer(existingUser.getId(), leagueId);
            inactiveMembership.setStatus(LeaguePlayer.LeaguePlayerStatus.INACTIVE);

            AcceptLeagueInvitationUseCase.AcceptInvitationCommand command =
                    new AcceptLeagueInvitationUseCase.AcceptInvitationCommand(
                            invitationToken, email, displayName, googleId);

            when(invitationRepository.findByToken(invitationToken)).thenReturn(Optional.of(pendingInvitation));
            when(userRepository.findByEmail(email)).thenReturn(Optional.of(existingUser));
            when(invitationRepository.save(any(PlayerInvitation.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leaguePlayerRepository.findByUserIdAndLeagueId(existingUser.getId(), leagueId))
                    .thenReturn(Optional.of(inactiveMembership));
            when(leaguePlayerRepository.save(any(LeaguePlayer.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act
            AcceptLeagueInvitationUseCase.AcceptInvitationResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            verify(leaguePlayerRepository).save(leaguePlayerCaptor.capture());
            assertEquals(LeaguePlayer.LeaguePlayerStatus.ACTIVE, leaguePlayerCaptor.getValue().getStatus());
        }

        @Test
        @DisplayName("should create new league membership when none exists")
        void shouldCreateNewLeagueMembership() {
            // Arrange
            User existingUser = new User();
            existingUser.setEmail(email);
            existingUser.setName("Existing User");
            existingUser.setGoogleId(googleId);
            existingUser.setRole(Role.PLAYER);

            AcceptLeagueInvitationUseCase.AcceptInvitationCommand command =
                    new AcceptLeagueInvitationUseCase.AcceptInvitationCommand(
                            invitationToken, email, displayName, googleId);

            when(invitationRepository.findByToken(invitationToken)).thenReturn(Optional.of(pendingInvitation));
            when(userRepository.findByEmail(email)).thenReturn(Optional.of(existingUser));
            when(invitationRepository.save(any(PlayerInvitation.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leaguePlayerRepository.findByUserIdAndLeagueId(existingUser.getId(), leagueId))
                    .thenReturn(Optional.empty());
            when(leaguePlayerRepository.save(any(LeaguePlayer.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act
            AcceptLeagueInvitationUseCase.AcceptInvitationResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            verify(leaguePlayerRepository).save(leaguePlayerCaptor.capture());
            assertEquals(existingUser.getId(), leaguePlayerCaptor.getValue().getUserId());
            assertEquals(leagueId, leaguePlayerCaptor.getValue().getLeagueId());
            assertEquals(LeaguePlayer.LeaguePlayerStatus.ACTIVE, leaguePlayerCaptor.getValue().getStatus());
        }

        @Test
        @DisplayName("should throw exception when league not found")
        void shouldThrowExceptionWhenLeagueNotFound() {
            // Arrange
            User existingUser = new User();
            existingUser.setEmail(email);
            existingUser.setName("Existing User");
            existingUser.setGoogleId(googleId);
            existingUser.setRole(Role.PLAYER);

            AcceptLeagueInvitationUseCase.AcceptInvitationCommand command =
                    new AcceptLeagueInvitationUseCase.AcceptInvitationCommand(
                            invitationToken, email, displayName, googleId);

            when(invitationRepository.findByToken(invitationToken)).thenReturn(Optional.of(pendingInvitation));
            when(userRepository.findByEmail(email)).thenReturn(Optional.of(existingUser));
            when(invitationRepository.save(any(PlayerInvitation.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leaguePlayerRepository.findByUserIdAndLeagueId(existingUser.getId(), leagueId))
                    .thenReturn(Optional.empty());
            when(leaguePlayerRepository.save(any(LeaguePlayer.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leagueRepository.findById(leagueId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("League not found"));
        }

        @Test
        @DisplayName("should set isNewUser flag correctly for new user")
        void shouldSetIsNewUserFlagCorrectlyForNewUser() {
            // Arrange
            AcceptLeagueInvitationUseCase.AcceptInvitationCommand command =
                    new AcceptLeagueInvitationUseCase.AcceptInvitationCommand(
                            invitationToken, email, displayName, googleId);

            when(invitationRepository.findByToken(invitationToken)).thenReturn(Optional.of(pendingInvitation));
            when(userRepository.findByEmail(email)).thenReturn(Optional.empty());
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));
            when(invitationRepository.save(any(PlayerInvitation.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leaguePlayerRepository.findByUserIdAndLeagueId(any(), eq(leagueId))).thenReturn(Optional.empty());
            when(leaguePlayerRepository.save(any(LeaguePlayer.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act
            AcceptLeagueInvitationUseCase.AcceptInvitationResult result = useCase.execute(command);

            // Assert
            assertTrue(result.isNewUser());
        }

        @Test
        @DisplayName("should return league in result")
        void shouldReturnLeagueInResult() {
            // Arrange
            User existingUser = new User();
            existingUser.setEmail(email);
            existingUser.setName("Existing User");
            existingUser.setGoogleId(googleId);
            existingUser.setRole(Role.PLAYER);

            AcceptLeagueInvitationUseCase.AcceptInvitationCommand command =
                    new AcceptLeagueInvitationUseCase.AcceptInvitationCommand(
                            invitationToken, email, displayName, googleId);

            when(invitationRepository.findByToken(invitationToken)).thenReturn(Optional.of(pendingInvitation));
            when(userRepository.findByEmail(email)).thenReturn(Optional.of(existingUser));
            when(invitationRepository.save(any(PlayerInvitation.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leaguePlayerRepository.findByUserIdAndLeagueId(existingUser.getId(), leagueId))
                    .thenReturn(Optional.empty());
            when(leaguePlayerRepository.save(any(LeaguePlayer.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act
            AcceptLeagueInvitationUseCase.AcceptInvitationResult result = useCase.execute(command);

            // Assert
            assertNotNull(result.getLeague());
            assertEquals(leagueId, result.getLeague().getId());
            assertEquals("Test League", result.getLeague().getName());
        }

        @Test
        @DisplayName("should save invitation after accepting")
        void shouldSaveInvitationAfterAccepting() {
            // Arrange
            User existingUser = new User();
            existingUser.setEmail(email);
            existingUser.setName("Existing User");
            existingUser.setGoogleId(googleId);
            existingUser.setRole(Role.PLAYER);

            AcceptLeagueInvitationUseCase.AcceptInvitationCommand command =
                    new AcceptLeagueInvitationUseCase.AcceptInvitationCommand(
                            invitationToken, email, displayName, googleId);

            when(invitationRepository.findByToken(invitationToken)).thenReturn(Optional.of(pendingInvitation));
            when(userRepository.findByEmail(email)).thenReturn(Optional.of(existingUser));
            when(invitationRepository.save(any(PlayerInvitation.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leaguePlayerRepository.findByUserIdAndLeagueId(existingUser.getId(), leagueId))
                    .thenReturn(Optional.empty());
            when(leaguePlayerRepository.save(any(LeaguePlayer.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act
            useCase.execute(command);

            // Assert
            verify(invitationRepository).save(invitationCaptor.capture());
            assertEquals(PlayerInvitation.InvitationStatus.ACCEPTED, invitationCaptor.getValue().getStatus());
        }
    }

    @Nested
    @DisplayName("AcceptInvitationCommand")
    class CommandTests {

        @Test
        @DisplayName("should create command with all fields")
        void shouldCreateCommandWithAllFields() {
            // Arrange & Act
            AcceptLeagueInvitationUseCase.AcceptInvitationCommand command =
                    new AcceptLeagueInvitationUseCase.AcceptInvitationCommand(
                            invitationToken, email, displayName, googleId);

            // Assert
            assertEquals(invitationToken, command.getInvitationToken());
            assertEquals(email, command.getEmail());
            assertEquals(displayName, command.getDisplayName());
            assertEquals(googleId, command.getGoogleId());
        }
    }

    @Nested
    @DisplayName("AcceptInvitationResult")
    class ResultTests {

        @Test
        @DisplayName("should create result with all fields")
        void shouldCreateResultWithAllFields() {
            // Arrange
            User user = new User();
            LeaguePlayer leaguePlayer = new LeaguePlayer();
            boolean isNewUser = true;

            // Act
            AcceptLeagueInvitationUseCase.AcceptInvitationResult result =
                    new AcceptLeagueInvitationUseCase.AcceptInvitationResult(
                            user, leaguePlayer, league, pendingInvitation, isNewUser);

            // Assert
            assertEquals(user, result.getUser());
            assertEquals(leaguePlayer, result.getLeaguePlayer());
            assertEquals(league, result.getLeague());
            assertEquals(pendingInvitation, result.getInvitation());
            assertTrue(result.isNewUser());
        }
    }
}

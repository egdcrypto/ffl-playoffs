package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.model.PlayerInvitation;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
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

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CreateUserOnFirstLoginUseCase Tests")
class CreateUserOnFirstLoginUseCaseTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PlayerInvitationRepository invitationRepository;

    @Mock
    private LeaguePlayerRepository leaguePlayerRepository;

    private CreateUserOnFirstLoginUseCase useCase;

    @Captor
    private ArgumentCaptor<User> userCaptor;

    @Captor
    private ArgumentCaptor<LeaguePlayer> leaguePlayerCaptor;

    @Captor
    private ArgumentCaptor<PlayerInvitation> invitationCaptor;

    private String email;
    private String googleId;
    private String name;
    private String pictureUrl;

    @BeforeEach
    void setUp() {
        useCase = new CreateUserOnFirstLoginUseCase(userRepository, invitationRepository, leaguePlayerRepository);

        email = "test@example.com";
        googleId = "google-123456";
        name = "Test User";
        pictureUrl = "https://example.com/picture.jpg";
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should return existing user when Google ID matches")
        void shouldReturnExistingUserWhenGoogleIdMatches() {
            // Arrange
            User existingUser = new User();
            existingUser.setId(UUID.randomUUID());
            existingUser.setEmail(email);
            existingUser.setGoogleId(googleId);
            existingUser.setName(name);
            existingUser.setRole(Role.PLAYER);

            CreateUserOnFirstLoginUseCase.OAuthLoginCommand command =
                    new CreateUserOnFirstLoginUseCase.OAuthLoginCommand(email, googleId, name, pictureUrl);

            when(userRepository.findByGoogleId(googleId)).thenReturn(Optional.of(existingUser));
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            CreateUserOnFirstLoginUseCase.FirstLoginResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertFalse(result.isNewUserCreated());
            assertEquals(existingUser.getId(), result.getUser().getId());
            assertTrue(result.getAcceptedInvitations().isEmpty());
        }

        @Test
        @DisplayName("should link Google ID when user exists by email")
        void shouldLinkGoogleIdWhenUserExistsByEmail() {
            // Arrange
            User existingUser = new User();
            existingUser.setId(UUID.randomUUID());
            existingUser.setEmail(email);
            existingUser.setGoogleId(null);
            existingUser.setName(null);
            existingUser.setRole(Role.PLAYER);

            CreateUserOnFirstLoginUseCase.OAuthLoginCommand command =
                    new CreateUserOnFirstLoginUseCase.OAuthLoginCommand(email, googleId, name, pictureUrl);

            when(userRepository.findByGoogleId(googleId)).thenReturn(Optional.empty());
            when(userRepository.findByEmail(email)).thenReturn(Optional.of(existingUser));
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            CreateUserOnFirstLoginUseCase.FirstLoginResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertFalse(result.isNewUserCreated());

            verify(userRepository).save(userCaptor.capture());
            User savedUser = userCaptor.getValue();
            assertEquals(googleId, savedUser.getGoogleId());
            assertEquals(name, savedUser.getName());
        }

        @Test
        @DisplayName("should create new user with PLAYER role when no user exists")
        void shouldCreateNewUserWithPlayerRole() {
            // Arrange
            CreateUserOnFirstLoginUseCase.OAuthLoginCommand command =
                    new CreateUserOnFirstLoginUseCase.OAuthLoginCommand(email, googleId, name, pictureUrl);

            when(userRepository.findByGoogleId(googleId)).thenReturn(Optional.empty());
            when(userRepository.findByEmail(email)).thenReturn(Optional.empty());
            when(invitationRepository.findPendingByEmail(email)).thenReturn(List.of());
            when(userRepository.save(any(User.class))).thenAnswer(inv -> {
                User user = inv.getArgument(0);
                user.setId(UUID.randomUUID());
                return user;
            });

            // Act
            CreateUserOnFirstLoginUseCase.FirstLoginResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertTrue(result.isNewUserCreated());
            assertEquals(Role.PLAYER, result.getUser().getRole());
            assertEquals(email, result.getUser().getEmail());
            assertEquals(name, result.getUser().getName());
            assertEquals(googleId, result.getUser().getGoogleId());
        }

        @Test
        @DisplayName("should auto-accept pending invitations for new user")
        void shouldAutoAcceptPendingInvitations() {
            // Arrange
            UUID leagueId = UUID.randomUUID();
            PlayerInvitation pendingInvitation = new PlayerInvitation(leagueId, "Test League", email, UUID.randomUUID());

            CreateUserOnFirstLoginUseCase.OAuthLoginCommand command =
                    new CreateUserOnFirstLoginUseCase.OAuthLoginCommand(email, googleId, name, pictureUrl);

            when(userRepository.findByGoogleId(googleId)).thenReturn(Optional.empty());
            when(userRepository.findByEmail(email)).thenReturn(Optional.empty());
            when(invitationRepository.findPendingByEmail(email)).thenReturn(List.of(pendingInvitation));
            when(userRepository.save(any(User.class))).thenAnswer(inv -> {
                User user = inv.getArgument(0);
                user.setId(UUID.randomUUID());
                return user;
            });
            when(invitationRepository.save(any(PlayerInvitation.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leaguePlayerRepository.save(any(LeaguePlayer.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            CreateUserOnFirstLoginUseCase.FirstLoginResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertTrue(result.isNewUserCreated());
            assertEquals(1, result.getAcceptedInvitations().size());
            assertEquals(leagueId, result.getAcceptedInvitations().get(0).getLeagueId());
        }

        @Test
        @DisplayName("should create LeaguePlayer entries for accepted invitations")
        void shouldCreateLeaguePlayerEntries() {
            // Arrange
            UUID leagueId = UUID.randomUUID();
            PlayerInvitation pendingInvitation = new PlayerInvitation(leagueId, "Test League", email, UUID.randomUUID());

            CreateUserOnFirstLoginUseCase.OAuthLoginCommand command =
                    new CreateUserOnFirstLoginUseCase.OAuthLoginCommand(email, googleId, name, pictureUrl);

            when(userRepository.findByGoogleId(googleId)).thenReturn(Optional.empty());
            when(userRepository.findByEmail(email)).thenReturn(Optional.empty());
            when(invitationRepository.findPendingByEmail(email)).thenReturn(List.of(pendingInvitation));
            when(userRepository.save(any(User.class))).thenAnswer(inv -> {
                User user = inv.getArgument(0);
                user.setId(UUID.randomUUID());
                return user;
            });
            when(invitationRepository.save(any(PlayerInvitation.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leaguePlayerRepository.save(any(LeaguePlayer.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(leaguePlayerRepository).save(leaguePlayerCaptor.capture());
            LeaguePlayer leaguePlayer = leaguePlayerCaptor.getValue();
            assertEquals(leagueId, leaguePlayer.getLeagueId());
            assertEquals(LeaguePlayer.LeaguePlayerStatus.ACTIVE, leaguePlayer.getStatus());
            assertNotNull(leaguePlayer.getJoinedAt());
        }

        @Test
        @DisplayName("should set newUserCreated flag correctly for new user")
        void shouldSetNewUserCreatedFlagForNewUser() {
            // Arrange
            CreateUserOnFirstLoginUseCase.OAuthLoginCommand command =
                    new CreateUserOnFirstLoginUseCase.OAuthLoginCommand(email, googleId, name, pictureUrl);

            when(userRepository.findByGoogleId(googleId)).thenReturn(Optional.empty());
            when(userRepository.findByEmail(email)).thenReturn(Optional.empty());
            when(invitationRepository.findPendingByEmail(email)).thenReturn(List.of());
            when(userRepository.save(any(User.class))).thenAnswer(inv -> {
                User user = inv.getArgument(0);
                user.setId(UUID.randomUUID());
                return user;
            });

            // Act
            CreateUserOnFirstLoginUseCase.FirstLoginResult result = useCase.execute(command);

            // Assert
            assertTrue(result.isNewUserCreated());
        }

        @Test
        @DisplayName("should set newUserCreated flag to false for existing user")
        void shouldSetNewUserCreatedFlagFalseForExistingUser() {
            // Arrange
            User existingUser = new User();
            existingUser.setId(UUID.randomUUID());
            existingUser.setEmail(email);
            existingUser.setGoogleId(googleId);
            existingUser.setRole(Role.PLAYER);

            CreateUserOnFirstLoginUseCase.OAuthLoginCommand command =
                    new CreateUserOnFirstLoginUseCase.OAuthLoginCommand(email, googleId, name, pictureUrl);

            when(userRepository.findByGoogleId(googleId)).thenReturn(Optional.of(existingUser));
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            CreateUserOnFirstLoginUseCase.FirstLoginResult result = useCase.execute(command);

            // Assert
            assertFalse(result.isNewUserCreated());
        }

        @Test
        @DisplayName("should handle invitation that cannot be accepted")
        void shouldHandleInvitationThatCannotBeAccepted() {
            // Arrange
            UUID leagueId = UUID.randomUUID();
            PlayerInvitation expiredInvitation = new PlayerInvitation(leagueId, "Test League", email, UUID.randomUUID());
            expiredInvitation.setStatus(PlayerInvitation.InvitationStatus.EXPIRED);

            CreateUserOnFirstLoginUseCase.OAuthLoginCommand command =
                    new CreateUserOnFirstLoginUseCase.OAuthLoginCommand(email, googleId, name, pictureUrl);

            when(userRepository.findByGoogleId(googleId)).thenReturn(Optional.empty());
            when(userRepository.findByEmail(email)).thenReturn(Optional.empty());
            when(invitationRepository.findPendingByEmail(email)).thenReturn(List.of(expiredInvitation));
            when(userRepository.save(any(User.class))).thenAnswer(inv -> {
                User user = inv.getArgument(0);
                user.setId(UUID.randomUUID());
                return user;
            });

            // Act
            CreateUserOnFirstLoginUseCase.FirstLoginResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertTrue(result.isNewUserCreated());
            assertTrue(result.getAcceptedInvitations().isEmpty());
            verify(leaguePlayerRepository, never()).save(any());
        }

        @Test
        @DisplayName("should not update user name if already set")
        void shouldNotUpdateNameIfAlreadySet() {
            // Arrange
            String existingName = "Existing Name";
            User existingUser = new User();
            existingUser.setId(UUID.randomUUID());
            existingUser.setEmail(email);
            existingUser.setGoogleId(null);
            existingUser.setName(existingName);
            existingUser.setRole(Role.PLAYER);

            CreateUserOnFirstLoginUseCase.OAuthLoginCommand command =
                    new CreateUserOnFirstLoginUseCase.OAuthLoginCommand(email, googleId, "New Name", pictureUrl);

            when(userRepository.findByGoogleId(googleId)).thenReturn(Optional.empty());
            when(userRepository.findByEmail(email)).thenReturn(Optional.of(existingUser));
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            CreateUserOnFirstLoginUseCase.FirstLoginResult result = useCase.execute(command);

            // Assert
            verify(userRepository).save(userCaptor.capture());
            User savedUser = userCaptor.getValue();
            assertEquals(existingName, savedUser.getName());
        }

        @Test
        @DisplayName("should handle multiple pending invitations")
        void shouldHandleMultiplePendingInvitations() {
            // Arrange
            UUID leagueId1 = UUID.randomUUID();
            UUID leagueId2 = UUID.randomUUID();
            PlayerInvitation invitation1 = new PlayerInvitation(leagueId1, "League 1", email, UUID.randomUUID());
            PlayerInvitation invitation2 = new PlayerInvitation(leagueId2, "League 2", email, UUID.randomUUID());

            CreateUserOnFirstLoginUseCase.OAuthLoginCommand command =
                    new CreateUserOnFirstLoginUseCase.OAuthLoginCommand(email, googleId, name, pictureUrl);

            when(userRepository.findByGoogleId(googleId)).thenReturn(Optional.empty());
            when(userRepository.findByEmail(email)).thenReturn(Optional.empty());
            when(invitationRepository.findPendingByEmail(email)).thenReturn(List.of(invitation1, invitation2));
            when(userRepository.save(any(User.class))).thenAnswer(inv -> {
                User user = inv.getArgument(0);
                user.setId(UUID.randomUUID());
                return user;
            });
            when(invitationRepository.save(any(PlayerInvitation.class))).thenAnswer(inv -> inv.getArgument(0));
            when(leaguePlayerRepository.save(any(LeaguePlayer.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            CreateUserOnFirstLoginUseCase.FirstLoginResult result = useCase.execute(command);

            // Assert
            assertEquals(2, result.getAcceptedInvitations().size());
            verify(leaguePlayerRepository, times(2)).save(any(LeaguePlayer.class));
        }
    }

    @Nested
    @DisplayName("OAuthLoginCommand")
    class OAuthLoginCommandTests {

        @Test
        @DisplayName("should create command with all fields")
        void shouldCreateCommandWithAllFields() {
            // Arrange & Act
            CreateUserOnFirstLoginUseCase.OAuthLoginCommand command =
                    new CreateUserOnFirstLoginUseCase.OAuthLoginCommand(email, googleId, name, pictureUrl);

            // Assert
            assertEquals(email, command.getEmail());
            assertEquals(googleId, command.getGoogleId());
            assertEquals(name, command.getName());
            assertEquals(pictureUrl, command.getPictureUrl());
        }
    }

    @Nested
    @DisplayName("FirstLoginResult")
    class FirstLoginResultTests {

        @Test
        @DisplayName("should create result with all fields")
        void shouldCreateResultWithAllFields() {
            // Arrange
            User user = new User();
            user.setId(UUID.randomUUID());

            PlayerInvitation invitation = new PlayerInvitation(
                    UUID.randomUUID(), "Test League", email, UUID.randomUUID());

            // Act
            CreateUserOnFirstLoginUseCase.FirstLoginResult result =
                    new CreateUserOnFirstLoginUseCase.FirstLoginResult(user, List.of(invitation), true);

            // Assert
            assertEquals(user, result.getUser());
            assertEquals(1, result.getAcceptedInvitations().size());
            assertTrue(result.isNewUserCreated());
        }
    }
}

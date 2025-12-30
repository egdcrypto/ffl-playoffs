package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Role;
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

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("AcceptAdminInvitationUseCase Tests")
class AcceptAdminInvitationUseCaseTest {

    @Mock
    private UserRepository userRepository;

    private AcceptAdminInvitationUseCase useCase;

    @Captor
    private ArgumentCaptor<User> userCaptor;

    private String email;
    private String googleId;
    private String invitationToken;
    private User invitedAdmin;

    @BeforeEach
    void setUp() {
        useCase = new AcceptAdminInvitationUseCase(userRepository);

        email = "admin@test.com";
        googleId = "google-id-12345";
        invitationToken = "invitation-token-xyz";

        // Create an invited admin (without Google ID yet)
        invitedAdmin = new User();
        invitedAdmin.setEmail(email);
        invitedAdmin.setName("Invited Admin");
        invitedAdmin.setRole(Role.ADMIN);
        // googleId is null - this is the expected state for an invited admin
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should accept admin invitation successfully")
        void shouldAcceptInvitationSuccessfully() {
            // Arrange
            AcceptAdminInvitationUseCase.AcceptAdminInvitationCommand command =
                    new AcceptAdminInvitationUseCase.AcceptAdminInvitationCommand(
                            email, googleId, invitationToken);

            when(userRepository.findByEmail(email)).thenReturn(Optional.of(invitedAdmin));
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            User result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(googleId, result.getGoogleId());
            assertEquals(email, result.getEmail());

            verify(userRepository).save(userCaptor.capture());
            User savedUser = userCaptor.getValue();
            assertEquals(googleId, savedUser.getGoogleId());
        }

        @Test
        @DisplayName("should throw IllegalArgumentException when user not found by email")
        void shouldThrowExceptionWhenUserNotFound() {
            // Arrange
            String unknownEmail = "unknown@test.com";
            AcceptAdminInvitationUseCase.AcceptAdminInvitationCommand command =
                    new AcceptAdminInvitationUseCase.AcceptAdminInvitationCommand(
                            unknownEmail, googleId, invitationToken);

            when(userRepository.findByEmail(unknownEmail)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Invitation not found"));
            assertTrue(exception.getMessage().contains(unknownEmail));
            verify(userRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw IllegalStateException when admin already has Google ID")
        void shouldThrowExceptionWhenAdminAlreadyLinked() {
            // Arrange
            User alreadyLinkedAdmin = new User();
            alreadyLinkedAdmin.setEmail(email);
            alreadyLinkedAdmin.setName("Already Linked Admin");
            alreadyLinkedAdmin.setRole(Role.ADMIN);
            alreadyLinkedAdmin.setGoogleId("existing-google-id");  // Already has Google ID

            AcceptAdminInvitationUseCase.AcceptAdminInvitationCommand command =
                    new AcceptAdminInvitationUseCase.AcceptAdminInvitationCommand(
                            email, googleId, invitationToken);

            when(userRepository.findByEmail(email)).thenReturn(Optional.of(alreadyLinkedAdmin));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("already linked"));
            verify(userRepository, never()).save(any());
        }

        @Test
        @DisplayName("should update last login timestamp when accepting invitation")
        void shouldUpdateLastLoginTimestamp() {
            // Arrange
            assertNull(invitedAdmin.getLastLoginAt());

            AcceptAdminInvitationUseCase.AcceptAdminInvitationCommand command =
                    new AcceptAdminInvitationUseCase.AcceptAdminInvitationCommand(
                            email, googleId, invitationToken);

            when(userRepository.findByEmail(email)).thenReturn(Optional.of(invitedAdmin));
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            User result = useCase.execute(command);

            // Assert
            assertNotNull(result.getLastLoginAt());
        }

        @Test
        @DisplayName("should save user with linked Google ID")
        void shouldSaveUserWithLinkedGoogleId() {
            // Arrange
            AcceptAdminInvitationUseCase.AcceptAdminInvitationCommand command =
                    new AcceptAdminInvitationUseCase.AcceptAdminInvitationCommand(
                            email, googleId, invitationToken);

            when(userRepository.findByEmail(email)).thenReturn(Optional.of(invitedAdmin));
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(userRepository, times(1)).save(userCaptor.capture());
            User savedUser = userCaptor.getValue();
            assertEquals(googleId, savedUser.getGoogleId());
            assertEquals(email, savedUser.getEmail());
            assertEquals(Role.ADMIN, savedUser.getRole());
        }

        @Test
        @DisplayName("should preserve existing user data when linking Google ID")
        void shouldPreserveExistingUserData() {
            // Arrange
            invitedAdmin.setName("Test Admin Name");
            invitedAdmin.setRole(Role.ADMIN);

            AcceptAdminInvitationUseCase.AcceptAdminInvitationCommand command =
                    new AcceptAdminInvitationUseCase.AcceptAdminInvitationCommand(
                            email, googleId, invitationToken);

            when(userRepository.findByEmail(email)).thenReturn(Optional.of(invitedAdmin));
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            User result = useCase.execute(command);

            // Assert
            assertEquals("Test Admin Name", result.getName());
            assertEquals(Role.ADMIN, result.getRole());
            assertEquals(email, result.getEmail());
        }
    }

    @Nested
    @DisplayName("AcceptAdminInvitationCommand")
    class CommandTests {

        @Test
        @DisplayName("should create command with all fields")
        void shouldCreateCommandWithAllFields() {
            // Arrange & Act
            AcceptAdminInvitationUseCase.AcceptAdminInvitationCommand command =
                    new AcceptAdminInvitationUseCase.AcceptAdminInvitationCommand(
                            email, googleId, invitationToken);

            // Assert
            assertEquals(email, command.getEmail());
            assertEquals(googleId, command.getGoogleId());
            assertEquals(invitationToken, command.getInvitationToken());
        }
    }
}

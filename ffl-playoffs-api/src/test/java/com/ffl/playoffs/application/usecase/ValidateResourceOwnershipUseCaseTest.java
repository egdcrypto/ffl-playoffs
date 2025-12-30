package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.AuthenticationContext;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.service.ResourceOwnershipValidator;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ValidateResourceOwnershipUseCase Tests")
class ValidateResourceOwnershipUseCaseTest {

    @Mock
    private ResourceOwnershipValidator ownershipValidator;

    private ValidateResourceOwnershipUseCase useCase;

    private UUID userId;
    private UUID leagueId;
    private UUID rosterId;
    private UUID selectionId;
    private AuthenticationContext userContext;

    @BeforeEach
    void setUp() {
        useCase = new ValidateResourceOwnershipUseCase(ownershipValidator);

        userId = UUID.randomUUID();
        leagueId = UUID.randomUUID();
        rosterId = UUID.randomUUID();
        selectionId = UUID.randomUUID();

        userContext = AuthenticationContext.forUser(userId, "test@example.com", Role.PLAYER, "google-123");
    }

    @Nested
    @DisplayName("validateLeagueAccess")
    class ValidateLeagueAccess {

        @Test
        @DisplayName("should allow access when validator returns true")
        void shouldAllowAccessWhenValidatorReturnsTrue() {
            // Arrange
            when(ownershipValidator.canAccessLeague(userContext, leagueId)).thenReturn(true);

            // Act & Assert - no exception thrown
            assertDoesNotThrow(() -> useCase.validateLeagueAccess(userContext, leagueId));
        }

        @Test
        @DisplayName("should throw ResourceAccessDeniedException when access denied")
        void shouldThrowExceptionWhenAccessDenied() {
            // Arrange
            when(ownershipValidator.canAccessLeague(userContext, leagueId)).thenReturn(false);

            // Act & Assert
            ValidateResourceOwnershipUseCase.ResourceAccessDeniedException exception = assertThrows(
                    ValidateResourceOwnershipUseCase.ResourceAccessDeniedException.class,
                    () -> useCase.validateLeagueAccess(userContext, leagueId)
            );

            assertEquals("LEAGUE_ACCESS_DENIED", exception.getErrorCode());
            assertTrue(exception.getMessage().contains("access"));
        }
    }

    @Nested
    @DisplayName("validateRosterModification")
    class ValidateRosterModification {

        @Test
        @DisplayName("should allow modification when validator returns true")
        void shouldAllowModificationWhenValidatorReturnsTrue() {
            // Arrange
            when(ownershipValidator.canModifyRoster(userContext, rosterId)).thenReturn(true);

            // Act & Assert - no exception thrown
            assertDoesNotThrow(() -> useCase.validateRosterModification(userContext, rosterId));
        }

        @Test
        @DisplayName("should throw ResourceAccessDeniedException when modification denied")
        void shouldThrowExceptionWhenModificationDenied() {
            // Arrange
            when(ownershipValidator.canModifyRoster(userContext, rosterId)).thenReturn(false);

            // Act & Assert
            ValidateResourceOwnershipUseCase.ResourceAccessDeniedException exception = assertThrows(
                    ValidateResourceOwnershipUseCase.ResourceAccessDeniedException.class,
                    () -> useCase.validateRosterModification(userContext, rosterId)
            );

            assertEquals("ROSTER_MODIFICATION_DENIED", exception.getErrorCode());
            assertTrue(exception.getMessage().contains("modify"));
        }
    }

    @Nested
    @DisplayName("validateUserAccess")
    class ValidateUserAccess {

        @Test
        @DisplayName("should allow access when validator returns true")
        void shouldAllowAccessWhenValidatorReturnsTrue() {
            // Arrange
            UUID targetUserId = UUID.randomUUID();
            when(ownershipValidator.canAccessUser(userContext, targetUserId)).thenReturn(true);

            // Act & Assert - no exception thrown
            assertDoesNotThrow(() -> useCase.validateUserAccess(userContext, targetUserId));
        }

        @Test
        @DisplayName("should throw ResourceAccessDeniedException when access denied")
        void shouldThrowExceptionWhenAccessDenied() {
            // Arrange
            UUID targetUserId = UUID.randomUUID();
            when(ownershipValidator.canAccessUser(userContext, targetUserId)).thenReturn(false);

            // Act & Assert
            ValidateResourceOwnershipUseCase.ResourceAccessDeniedException exception = assertThrows(
                    ValidateResourceOwnershipUseCase.ResourceAccessDeniedException.class,
                    () -> useCase.validateUserAccess(userContext, targetUserId)
            );

            assertEquals("USER_ACCESS_DENIED", exception.getErrorCode());
            assertTrue(exception.getMessage().contains("access"));
        }
    }

    @Nested
    @DisplayName("validateTeamSelectionModification")
    class ValidateTeamSelectionModification {

        @Test
        @DisplayName("should allow modification when validator returns true")
        void shouldAllowModificationWhenValidatorReturnsTrue() {
            // Arrange
            when(ownershipValidator.canModifyTeamSelection(userContext, selectionId)).thenReturn(true);

            // Act & Assert - no exception thrown
            assertDoesNotThrow(() -> useCase.validateTeamSelectionModification(userContext, selectionId));
        }

        @Test
        @DisplayName("should throw ResourceAccessDeniedException when modification denied")
        void shouldThrowExceptionWhenModificationDenied() {
            // Arrange
            when(ownershipValidator.canModifyTeamSelection(userContext, selectionId)).thenReturn(false);

            // Act & Assert
            ValidateResourceOwnershipUseCase.ResourceAccessDeniedException exception = assertThrows(
                    ValidateResourceOwnershipUseCase.ResourceAccessDeniedException.class,
                    () -> useCase.validateTeamSelectionModification(userContext, selectionId)
            );

            assertEquals("SELECTION_MODIFICATION_DENIED", exception.getErrorCode());
            assertTrue(exception.getMessage().contains("modify"));
        }
    }

    @Nested
    @DisplayName("validateLeagueMembership")
    class ValidateLeagueMembership {

        @Test
        @DisplayName("should allow when user is member")
        void shouldAllowWhenUserIsMember() {
            // Arrange
            when(ownershipValidator.isLeagueMember(userId, leagueId)).thenReturn(true);

            // Act & Assert - no exception thrown
            assertDoesNotThrow(() -> useCase.validateLeagueMembership(userId, leagueId));
        }

        @Test
        @DisplayName("should throw exception when not member")
        void shouldThrowExceptionWhenNotMember() {
            // Arrange
            when(ownershipValidator.isLeagueMember(userId, leagueId)).thenReturn(false);

            // Act & Assert
            ValidateResourceOwnershipUseCase.ResourceAccessDeniedException exception = assertThrows(
                    ValidateResourceOwnershipUseCase.ResourceAccessDeniedException.class,
                    () -> useCase.validateLeagueMembership(userId, leagueId)
            );

            assertEquals("NOT_LEAGUE_MEMBER", exception.getErrorCode());
            assertTrue(exception.getMessage().contains("member"));
        }
    }

    @Nested
    @DisplayName("validateLeagueOwnership")
    class ValidateLeagueOwnership {

        @Test
        @DisplayName("should allow when user is owner")
        void shouldAllowWhenUserIsOwner() {
            // Arrange
            when(ownershipValidator.isLeagueOwner(userId, leagueId)).thenReturn(true);

            // Act & Assert - no exception thrown
            assertDoesNotThrow(() -> useCase.validateLeagueOwnership(userId, leagueId));
        }

        @Test
        @DisplayName("should throw exception when not owner")
        void shouldThrowExceptionWhenNotOwner() {
            // Arrange
            when(ownershipValidator.isLeagueOwner(userId, leagueId)).thenReturn(false);

            // Act & Assert
            ValidateResourceOwnershipUseCase.ResourceAccessDeniedException exception = assertThrows(
                    ValidateResourceOwnershipUseCase.ResourceAccessDeniedException.class,
                    () -> useCase.validateLeagueOwnership(userId, leagueId)
            );

            assertEquals("NOT_LEAGUE_OWNER", exception.getErrorCode());
            assertTrue(exception.getMessage().contains("owned"));
        }
    }

    @Nested
    @DisplayName("ResourceAccessDeniedException")
    class ResourceAccessDeniedExceptionTests {

        @Test
        @DisplayName("should create exception with error code and message")
        void shouldCreateExceptionWithErrorCodeAndMessage() {
            // Arrange & Act
            ValidateResourceOwnershipUseCase.ResourceAccessDeniedException exception =
                    new ValidateResourceOwnershipUseCase.ResourceAccessDeniedException("TEST_CODE", "Test message");

            // Assert
            assertEquals("TEST_CODE", exception.getErrorCode());
            assertEquals("Test message", exception.getMessage());
        }
    }
}

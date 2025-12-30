package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("RevokeAdminUseCase Tests")
class RevokeAdminUseCaseTest {

    @Mock
    private UserRepository userRepository;

    private RevokeAdminUseCase revokeAdminUseCase;

    private UUID superAdminId;
    private UUID adminId;
    private User superAdmin;
    private User admin;

    @BeforeEach
    void setUp() {
        revokeAdminUseCase = new RevokeAdminUseCase(userRepository);

        superAdminId = UUID.randomUUID();
        adminId = UUID.randomUUID();

        superAdmin = new User("superadmin@example.com", "Super Admin", "google123", Role.SUPER_ADMIN);
        superAdmin.setId(superAdminId);

        admin = new User("admin@example.com", "Admin User", "google456", Role.ADMIN);
        admin.setId(adminId);
    }

    @Test
    @DisplayName("should revoke admin privileges successfully")
    void shouldRevokeAdminSuccessfully() {
        // Arrange
        when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
        when(userRepository.findById(adminId)).thenReturn(Optional.of(admin));
        when(userRepository.save(any(User.class))).thenAnswer(invocation -> invocation.getArgument(0));

        RevokeAdminUseCase.RevokeAdminCommand command = new RevokeAdminUseCase.RevokeAdminCommand(
                adminId, superAdminId
        );

        // Act
        RevokeAdminUseCase.RevokeAdminResult result = revokeAdminUseCase.execute(command);

        // Assert
        assertNotNull(result);
        assertEquals(adminId, result.getUserId());
        assertEquals("admin@example.com", result.getEmail());
        assertEquals("Admin User", result.getName());
        assertNotNull(result.getRevokedAt());

        verify(userRepository).save(any(User.class));
        assertEquals(Role.PLAYER, admin.getRole());
    }

    @Test
    @DisplayName("should throw exception when current user not found")
    void shouldThrowExceptionWhenCurrentUserNotFound() {
        // Arrange
        when(userRepository.findById(superAdminId)).thenReturn(Optional.empty());

        RevokeAdminUseCase.RevokeAdminCommand command = new RevokeAdminUseCase.RevokeAdminCommand(
                adminId, superAdminId
        );

        // Act & Assert
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class,
                () -> revokeAdminUseCase.execute(command));
        assertEquals("Current user not found", exception.getMessage());
    }

    @Test
    @DisplayName("should throw exception when current user is not SUPER_ADMIN")
    void shouldThrowExceptionWhenNotSuperAdmin() {
        // Arrange
        User regularAdmin = new User("regular@example.com", "Regular Admin", "google789", Role.ADMIN);
        regularAdmin.setId(superAdminId);
        when(userRepository.findById(superAdminId)).thenReturn(Optional.of(regularAdmin));

        RevokeAdminUseCase.RevokeAdminCommand command = new RevokeAdminUseCase.RevokeAdminCommand(
                adminId, superAdminId
        );

        // Act & Assert
        IllegalStateException exception = assertThrows(IllegalStateException.class,
                () -> revokeAdminUseCase.execute(command));
        assertEquals("Only SUPER_ADMIN can revoke admin privileges", exception.getMessage());
    }

    @Test
    @DisplayName("should throw exception when trying to revoke own privileges")
    void shouldThrowExceptionWhenRevokingSelf() {
        // Arrange
        when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));

        RevokeAdminUseCase.RevokeAdminCommand command = new RevokeAdminUseCase.RevokeAdminCommand(
                superAdminId, superAdminId
        );

        // Act & Assert
        IllegalStateException exception = assertThrows(IllegalStateException.class,
                () -> revokeAdminUseCase.execute(command));
        assertEquals("Cannot revoke your own admin privileges", exception.getMessage());
    }

    @Test
    @DisplayName("should throw exception when target user not found")
    void shouldThrowExceptionWhenTargetUserNotFound() {
        // Arrange
        when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
        when(userRepository.findById(adminId)).thenReturn(Optional.empty());

        RevokeAdminUseCase.RevokeAdminCommand command = new RevokeAdminUseCase.RevokeAdminCommand(
                adminId, superAdminId
        );

        // Act & Assert
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class,
                () -> revokeAdminUseCase.execute(command));
        assertTrue(exception.getMessage().contains("Admin user not found"));
    }

    @Test
    @DisplayName("should throw exception when target user is not an admin")
    void shouldThrowExceptionWhenTargetNotAdmin() {
        // Arrange
        User player = new User("player@example.com", "Player User", "google789", Role.PLAYER);
        player.setId(adminId);
        when(userRepository.findById(superAdminId)).thenReturn(Optional.of(superAdmin));
        when(userRepository.findById(adminId)).thenReturn(Optional.of(player));

        RevokeAdminUseCase.RevokeAdminCommand command = new RevokeAdminUseCase.RevokeAdminCommand(
                adminId, superAdminId
        );

        // Act & Assert
        IllegalStateException exception = assertThrows(IllegalStateException.class,
                () -> revokeAdminUseCase.execute(command));
        assertTrue(exception.getMessage().contains("User is not an admin"));
    }
}

package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.IntegrationTestBase;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.model.User;
import com.ffl.playoffs.domain.port.UserRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static org.assertj.core.api.Assertions.*;

/**
 * Integration tests for CreateUserAccountUseCase
 * Tests complete end-to-end flow with MongoDB persistence
 */
@DisplayName("CreateUserAccountUseCase Integration Tests")
class CreateUserAccountUseCaseTest extends IntegrationTestBase {

    @Autowired
    private UserRepository userRepository;

    private CreateUserAccountUseCase useCase;

    @Override
    protected void baseSetUp() {
        super.baseSetUp();
        useCase = new CreateUserAccountUseCase(userRepository);
    }

    @Test
    @DisplayName("Should create user with PLAYER role by default")
    void shouldCreateUserWithDefaultPlayerRole() {
        // Given
        var command = new CreateUserAccountUseCase.CreateUserCommand(
                "player@example.com",
                "John Doe",
                "google-123"
        );

        // When
        User createdUser = useCase.execute(command);

        // Then
        assertThat(createdUser).isNotNull();
        assertThat(createdUser.getId()).isNotNull();
        assertThat(createdUser.getEmail()).isEqualTo("player@example.com");
        assertThat(createdUser.getName()).isEqualTo("John Doe");
        assertThat(createdUser.getGoogleId()).isEqualTo("google-123");
        assertThat(createdUser.getRole()).isEqualTo(Role.PLAYER);
        assertThat(createdUser.getCreatedAt()).isNotNull();

        // Verify persistence
        User savedUser = userRepository.findByEmail("player@example.com").orElse(null);
        assertThat(savedUser).isNotNull();
        assertThat(savedUser.getId()).isEqualTo(createdUser.getId());
    }

    @Test
    @DisplayName("Should create user with ADMIN role when specified")
    void shouldCreateUserWithAdminRole() {
        // Given
        var command = new CreateUserAccountUseCase.CreateUserCommand(
                "admin@example.com",
                "Admin User",
                "google-456",
                Role.ADMIN
        );

        // When
        User createdUser = useCase.execute(command);

        // Then
        assertThat(createdUser.getRole()).isEqualTo(Role.ADMIN);
        assertThat(createdUser.getEmail()).isEqualTo("admin@example.com");
    }

    @Test
    @DisplayName("Should create user with SUPER_ADMIN role when specified")
    void shouldCreateUserWithSuperAdminRole() {
        // Given
        var command = new CreateUserAccountUseCase.CreateUserCommand(
                "superadmin@example.com",
                "Super Admin",
                "google-789",
                Role.SUPER_ADMIN
        );

        // When
        User createdUser = useCase.execute(command);

        // Then
        assertThat(createdUser.getRole()).isEqualTo(Role.SUPER_ADMIN);
    }

    @Test
    @DisplayName("Should throw exception when email already exists")
    void shouldThrowExceptionWhenEmailExists() {
        // Given
        var firstCommand = new CreateUserAccountUseCase.CreateUserCommand(
                "duplicate@example.com",
                "First User",
                "google-111"
        );
        useCase.execute(firstCommand);

        var duplicateCommand = new CreateUserAccountUseCase.CreateUserCommand(
                "duplicate@example.com",
                "Second User",
                "google-222"
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(duplicateCommand))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("User with email already exists");
    }

    @Test
    @DisplayName("Should throw exception when Google ID already exists")
    void shouldThrowExceptionWhenGoogleIdExists() {
        // Given
        var firstCommand = new CreateUserAccountUseCase.CreateUserCommand(
                "user1@example.com",
                "User One",
                "google-duplicate"
        );
        useCase.execute(firstCommand);

        var duplicateCommand = new CreateUserAccountUseCase.CreateUserCommand(
                "user2@example.com",
                "User Two",
                "google-duplicate"
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(duplicateCommand))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("User with Google ID already exists");
    }

    @Test
    @DisplayName("Should create user without Google ID")
    void shouldCreateUserWithoutGoogleId() {
        // Given
        var command = new CreateUserAccountUseCase.CreateUserCommand(
                "noogle@example.com",
                "No Google User",
                null,
                Role.PLAYER
        );

        // When
        User createdUser = useCase.execute(command);

        // Then
        assertThat(createdUser).isNotNull();
        assertThat(createdUser.getGoogleId()).isNull();
        assertThat(createdUser.getEmail()).isEqualTo("noogle@example.com");
    }

    @Test
    @DisplayName("Should find user by Google ID after creation")
    void shouldFindUserByGoogleId() {
        // Given
        var command = new CreateUserAccountUseCase.CreateUserCommand(
                "findme@example.com",
                "Find Me",
                "google-findme"
        );
        User createdUser = useCase.execute(command);

        // When
        User foundUser = userRepository.findByGoogleId("google-findme").orElse(null);

        // Then
        assertThat(foundUser).isNotNull();
        assertThat(foundUser.getId()).isEqualTo(createdUser.getId());
        assertThat(foundUser.getEmail()).isEqualTo("findme@example.com");
    }

    @Test
    @DisplayName("Should persist all user fields correctly")
    void shouldPersistAllUserFields() {
        // Given
        var command = new CreateUserAccountUseCase.CreateUserCommand(
                "complete@example.com",
                "Complete User",
                "google-complete",
                Role.ADMIN
        );

        // When
        User createdUser = useCase.execute(command);

        // Then - retrieve from database and verify all fields
        User retrievedUser = userRepository.findById(createdUser.getId()).orElse(null);
        assertThat(retrievedUser).isNotNull();
        assertThat(retrievedUser.getEmail()).isEqualTo("complete@example.com");
        assertThat(retrievedUser.getName()).isEqualTo("Complete User");
        assertThat(retrievedUser.getGoogleId()).isEqualTo("google-complete");
        assertThat(retrievedUser.getRole()).isEqualTo(Role.ADMIN);
        assertThat(retrievedUser.getCreatedAt()).isNotNull();
        assertThat(retrievedUser.getLastLoginAt()).isNull(); // Not set on creation
    }
}

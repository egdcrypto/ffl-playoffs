package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.IntegrationTestBase;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.port.UserRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;

import static org.assertj.core.api.Assertions.*;

/**
 * Integration tests for CreateSuperAdminUseCase
 * Tests complete end-to-end flow with MongoDB persistence
 */
@DisplayName("CreateSuperAdminUseCase Integration Tests")
class CreateSuperAdminUseCaseTest extends IntegrationTestBase {

    @Autowired
    private UserRepository userRepository;

    private CreateSuperAdminUseCase useCase;

    @Override
    protected void baseSetUp() {
        super.baseSetUp();
        useCase = new CreateSuperAdminUseCase(userRepository);
    }

    @Test
    @DisplayName("Should create super admin successfully")
    void shouldCreateSuperAdmin() {
        // Given
        var command = new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                "admin@example.com",
                "google-user-123",
                "Admin User"
        );

        // When
        CreateSuperAdminUseCase.CreateSuperAdminResult result = useCase.execute(command);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getId()).isNotNull();
        assertThat(result.getEmail()).isEqualTo("admin@example.com");
        assertThat(result.getName()).isEqualTo("Admin User");
        assertThat(result.getGoogleId()).isEqualTo("google-user-123");
        assertThat(result.getRole()).isEqualTo(Role.SUPER_ADMIN);
        assertThat(result.getCreatedAt()).isNotNull();
    }

    @Test
    @DisplayName("Should persist super admin with all fields")
    void shouldPersistSuperAdminWithAllFields() {
        // Given
        var command = new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                "admin@example.com",
                "google-user-123",
                "Admin User"
        );

        // When
        CreateSuperAdminUseCase.CreateSuperAdminResult result = useCase.execute(command);

        // Then - retrieve from database and verify
        User savedUser = userRepository.findById(result.getId()).orElse(null);
        assertThat(savedUser).isNotNull();
        assertThat(savedUser.getEmail()).isEqualTo("admin@example.com");
        assertThat(savedUser.getName()).isEqualTo("Admin User");
        assertThat(savedUser.getGoogleId()).isEqualTo("google-user-123");
        assertThat(savedUser.getRole()).isEqualTo(Role.SUPER_ADMIN);
        assertThat(savedUser.isActive()).isTrue();
        assertThat(savedUser.getCreatedAt()).isNotNull();
    }

    @Test
    @DisplayName("Should create super admin without name and extract from email")
    void shouldExtractNameFromEmail() {
        // Given - no name provided
        var command = new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                "johndoe@example.com",
                "google-user-456",
                null
        );

        // When
        CreateSuperAdminUseCase.CreateSuperAdminResult result = useCase.execute(command);

        // Then - name should be extracted from email
        assertThat(result.getName()).isEqualTo("johndoe");
    }

    @Test
    @DisplayName("Should throw exception when email already exists")
    void shouldThrowExceptionWhenEmailExists() {
        // Given - create first user
        var firstCommand = new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                "duplicate@example.com",
                "google-user-111",
                "First User"
        );
        useCase.execute(firstCommand);

        // When/Then - try to create second user with same email
        var duplicateCommand = new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                "duplicate@example.com",
                "google-user-222",
                "Second User"
        );

        assertThatThrownBy(() -> useCase.execute(duplicateCommand))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("User with email 'duplicate@example.com' already exists");
    }

    @Test
    @DisplayName("Should throw exception when Google ID already exists")
    void shouldThrowExceptionWhenGoogleIdExists() {
        // Given - create first user
        var firstCommand = new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                "user1@example.com",
                "google-duplicate",
                "First User"
        );
        useCase.execute(firstCommand);

        // When/Then - try to create second user with same Google ID
        var duplicateCommand = new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                "user2@example.com",
                "google-duplicate",
                "Second User"
        );

        assertThatThrownBy(() -> useCase.execute(duplicateCommand))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("User with Google ID 'google-duplicate' already exists");
    }

    @Test
    @DisplayName("Should throw exception when email is null")
    void shouldThrowExceptionWhenEmailNull() {
        // Given
        var command = new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                null,
                "google-user-123",
                "Admin User"
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Email cannot be empty");
    }

    @Test
    @DisplayName("Should throw exception when email is empty")
    void shouldThrowExceptionWhenEmailEmpty() {
        // Given
        var command = new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                "",
                "google-user-123",
                "Admin User"
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Email cannot be empty");
    }

    @Test
    @DisplayName("Should throw exception when email has invalid format")
    void shouldThrowExceptionWhenEmailInvalid() {
        // Given
        var command = new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                "notanemail",
                "google-user-123",
                "Admin User"
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Invalid email format");
    }

    @Test
    @DisplayName("Should throw exception when Google ID is null")
    void shouldThrowExceptionWhenGoogleIdNull() {
        // Given
        var command = new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                "admin@example.com",
                null,
                "Admin User"
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Google ID cannot be empty");
    }

    @Test
    @DisplayName("Should throw exception when Google ID is empty")
    void shouldThrowExceptionWhenGoogleIdEmpty() {
        // Given
        var command = new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                "admin@example.com",
                "",
                "Admin User"
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Google ID cannot be empty");
    }

    @Test
    @DisplayName("Should set createdAt timestamp")
    void shouldSetCreatedAtTimestamp() {
        // Given
        LocalDateTime beforeCreation = LocalDateTime.now();
        var command = new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                "admin@example.com",
                "google-user-123",
                "Admin User"
        );

        // When
        CreateSuperAdminUseCase.CreateSuperAdminResult result = useCase.execute(command);
        LocalDateTime afterCreation = LocalDateTime.now();

        // Then
        assertThat(result.getCreatedAt()).isNotNull();
        assertThat(result.getCreatedAt()).isAfterOrEqualTo(beforeCreation);
        assertThat(result.getCreatedAt()).isBeforeOrEqualTo(afterCreation);
    }

    @Test
    @DisplayName("Should find super admin by email after creation")
    void shouldFindSuperAdminByEmail() {
        // Given
        var command = new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                "findme@example.com",
                "google-user-789",
                "Findable Admin"
        );
        CreateSuperAdminUseCase.CreateSuperAdminResult result = useCase.execute(command);

        // When
        User foundUser = userRepository.findByEmail("findme@example.com").orElse(null);

        // Then
        assertThat(foundUser).isNotNull();
        assertThat(foundUser.getId()).isEqualTo(result.getId());
        assertThat(foundUser.getName()).isEqualTo("Findable Admin");
        assertThat(foundUser.getRole()).isEqualTo(Role.SUPER_ADMIN);
    }

    @Test
    @DisplayName("Should find super admin by Google ID after creation")
    void shouldFindSuperAdminByGoogleId() {
        // Given
        var command = new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                "admin@example.com",
                "google-findable",
                "Admin User"
        );
        CreateSuperAdminUseCase.CreateSuperAdminResult result = useCase.execute(command);

        // When
        User foundUser = userRepository.findByGoogleId("google-findable").orElse(null);

        // Then
        assertThat(foundUser).isNotNull();
        assertThat(foundUser.getId()).isEqualTo(result.getId());
        assertThat(foundUser.getEmail()).isEqualTo("admin@example.com");
        assertThat(foundUser.getRole()).isEqualTo(Role.SUPER_ADMIN);
    }

    @Test
    @DisplayName("Should create active super admin by default")
    void shouldCreateActiveSuperAdmin() {
        // Given
        var command = new CreateSuperAdminUseCase.CreateSuperAdminCommand(
                "admin@example.com",
                "google-user-123",
                "Admin User"
        );

        // When
        CreateSuperAdminUseCase.CreateSuperAdminResult result = useCase.execute(command);

        // Then
        User savedUser = userRepository.findById(result.getId()).orElse(null);
        assertThat(savedUser).isNotNull();
        assertThat(savedUser.isActive()).isTrue();
    }
}

package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.IntegrationTestBase;
import com.ffl.playoffs.domain.model.PATScope;
import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

/**
 * Integration tests for CreatePATUseCase
 * Tests complete end-to-end flow with MongoDB persistence
 */
@DisplayName("CreatePATUseCase Integration Tests")
class CreatePATUseCaseTest extends IntegrationTestBase {

    @Autowired
    private PersonalAccessTokenRepository patRepository;

    @Autowired
    private UserRepository userRepository;

    private CreatePATUseCase useCase;
    private User superAdmin;

    @Override
    protected void baseSetUp() {
        super.baseSetUp();
        useCase = new CreatePATUseCase(patRepository, userRepository);

        // Create a super admin user for testing
        superAdmin = new User(
                "superadmin@example.com",
                "Super Admin",
                "google-super-admin",
                Role.SUPER_ADMIN
        );
        superAdmin = userRepository.save(superAdmin);
    }

    @Test
    @DisplayName("Should create PAT with ADMIN scope successfully")
    void shouldCreatePATWithAdminScope() {
        // Given
        LocalDateTime expiresAt = LocalDateTime.now().plusDays(365);
        var command = new CreatePATUseCase.CreatePATCommand(
                "CI/CD Pipeline Token",
                PATScope.ADMIN,
                expiresAt,
                superAdmin.getId()
        );

        // When
        CreatePATUseCase.CreatePATResult result = useCase.execute(command);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getId()).isNotNull();
        assertThat(result.getName()).isEqualTo("CI/CD Pipeline Token");
        assertThat(result.getScope()).isEqualTo(PATScope.ADMIN);
        assertThat(result.getExpiresAt()).isEqualTo(expiresAt);
        assertThat(result.getCreatedBy()).isEqualTo(superAdmin.getId());
        assertThat(result.getCreatedAt()).isNotNull();

        // Verify plaintext token format: pat_<identifier>_<random>
        String token = result.getPlaintextToken();
        assertThat(token).isNotNull();
        assertThat(token).startsWith("pat_");
        assertThat(token.split("_")).hasSize(3); // pat, identifier, random

        // Verify persistence
        PersonalAccessToken savedPat = patRepository.findById(result.getId()).orElse(null);
        assertThat(savedPat).isNotNull();
        assertThat(savedPat.getName()).isEqualTo("CI/CD Pipeline Token");
        assertThat(savedPat.getScope()).isEqualTo(PATScope.ADMIN);
    }

    @Test
    @DisplayName("Should create PAT with WRITE scope")
    void shouldCreatePATWithWriteScope() {
        // Given
        var command = new CreatePATUseCase.CreatePATCommand(
                "Write Token",
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                superAdmin.getId()
        );

        // When
        CreatePATUseCase.CreatePATResult result = useCase.execute(command);

        // Then
        assertThat(result.getScope()).isEqualTo(PATScope.WRITE);
    }

    @Test
    @DisplayName("Should create PAT with READ_ONLY scope")
    void shouldCreatePATWithReadOnlyScope() {
        // Given
        var command = new CreatePATUseCase.CreatePATCommand(
                "Monitoring Token",
                PATScope.READ_ONLY,
                LocalDateTime.now().plusDays(90),
                superAdmin.getId()
        );

        // When
        CreatePATUseCase.CreatePATResult result = useCase.execute(command);

        // Then
        assertThat(result.getScope()).isEqualTo(PATScope.READ_ONLY);
    }

    @Test
    @DisplayName("Should create PAT without expiration")
    void shouldCreatePATWithoutExpiration() {
        // Given
        var command = new CreatePATUseCase.CreatePATCommand(
                "No Expiration Token",
                PATScope.WRITE,
                null, // No expiration
                superAdmin.getId()
        );

        // When
        CreatePATUseCase.CreatePATResult result = useCase.execute(command);

        // Then
        assertThat(result.getExpiresAt()).isNull();

        PersonalAccessToken savedPat = patRepository.findById(result.getId()).orElse(null);
        assertThat(savedPat).isNotNull();
        assertThat(savedPat.getExpiresAt()).isNull();
    }

    @Test
    @DisplayName("Should throw exception when user is not SUPER_ADMIN")
    void shouldThrowExceptionWhenUserNotSuperAdmin() {
        // Given - create a regular player user
        User player = new User(
                "player@example.com",
                "Regular Player",
                "google-player",
                Role.PLAYER
        );
        player = userRepository.save(player);

        var command = new CreatePATUseCase.CreatePATCommand(
                "Unauthorized Token",
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                player.getId()
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(SecurityException.class)
                .hasMessageContaining("Only SUPER_ADMIN users can create Personal Access Tokens");
    }

    @Test
    @DisplayName("Should throw exception when user is ADMIN (not SUPER_ADMIN)")
    void shouldThrowExceptionWhenUserIsAdmin() {
        // Given - create an admin user
        User admin = new User(
                "admin@example.com",
                "Admin User",
                "google-admin",
                Role.ADMIN
        );
        admin = userRepository.save(admin);

        var command = new CreatePATUseCase.CreatePATCommand(
                "Admin Token",
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                admin.getId()
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(SecurityException.class)
                .hasMessageContaining("Only SUPER_ADMIN users can create Personal Access Tokens");
    }

    @Test
    @DisplayName("Should throw exception when user not found")
    void shouldThrowExceptionWhenUserNotFound() {
        // Given
        UUID nonExistentUserId = UUID.randomUUID();
        var command = new CreatePATUseCase.CreatePATCommand(
                "Nonexistent User Token",
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                nonExistentUserId
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("User not found");
    }

    @Test
    @DisplayName("Should throw exception when PAT name already exists")
    void shouldThrowExceptionWhenNameExists() {
        // Given - create first PAT
        var firstCommand = new CreatePATUseCase.CreatePATCommand(
                "Duplicate Name",
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                superAdmin.getId()
        );
        useCase.execute(firstCommand);

        // When - try to create second PAT with same name
        var duplicateCommand = new CreatePATUseCase.CreatePATCommand(
                "Duplicate Name",
                PATScope.READ_ONLY,
                LocalDateTime.now().plusDays(60),
                superAdmin.getId()
        );

        // Then
        assertThatThrownBy(() -> useCase.execute(duplicateCommand))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("PAT with name 'Duplicate Name' already exists");
    }

    @Test
    @DisplayName("Should throw exception when PAT name is empty")
    void shouldThrowExceptionWhenNameEmpty() {
        // Given
        var command = new CreatePATUseCase.CreatePATCommand(
                "",
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                superAdmin.getId()
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("PAT name cannot be empty");
    }

    @Test
    @DisplayName("Should throw exception when PAT name is null")
    void shouldThrowExceptionWhenNameNull() {
        // Given
        var command = new CreatePATUseCase.CreatePATCommand(
                null,
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                superAdmin.getId()
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("PAT name cannot be empty");
    }

    @Test
    @DisplayName("Should throw exception when scope is null")
    void shouldThrowExceptionWhenScopeNull() {
        // Given
        var command = new CreatePATUseCase.CreatePATCommand(
                "Valid Name",
                null,
                LocalDateTime.now().plusDays(30),
                superAdmin.getId()
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("PAT scope cannot be null");
    }

    @Test
    @DisplayName("Should throw exception when expiration is in the past")
    void shouldThrowExceptionWhenExpirationInPast() {
        // Given
        var command = new CreatePATUseCase.CreatePATCommand(
                "Expired Token",
                PATScope.WRITE,
                LocalDateTime.now().minusDays(1), // Yesterday
                superAdmin.getId()
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("PAT expiration must be in the future");
    }

    @Test
    @DisplayName("Should throw exception when creator ID is null")
    void shouldThrowExceptionWhenCreatorIdNull() {
        // Given
        var command = new CreatePATUseCase.CreatePATCommand(
                "Valid Name",
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                null
        );

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Creator user ID cannot be null");
    }

    @Test
    @DisplayName("Should generate unique token identifiers")
    void shouldGenerateUniqueTokenIdentifiers() {
        // Given/When - create two PATs
        var command1 = new CreatePATUseCase.CreatePATCommand(
                "Token 1",
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                superAdmin.getId()
        );
        var result1 = useCase.execute(command1);

        var command2 = new CreatePATUseCase.CreatePATCommand(
                "Token 2",
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                superAdmin.getId()
        );
        var result2 = useCase.execute(command2);

        // Then - tokens should be different
        assertThat(result1.getPlaintextToken()).isNotEqualTo(result2.getPlaintextToken());
    }

    @Test
    @DisplayName("Should store token hash, not plaintext")
    void shouldStoreTokenHashNotPlaintext() {
        // Given
        var command = new CreatePATUseCase.CreatePATCommand(
                "Secure Token",
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                superAdmin.getId()
        );

        // When
        CreatePATUseCase.CreatePATResult result = useCase.execute(command);
        String plaintextToken = result.getPlaintextToken();

        // Then - database should contain hash, not plaintext
        PersonalAccessToken savedPat = patRepository.findById(result.getId()).orElse(null);
        assertThat(savedPat).isNotNull();
        assertThat(savedPat.getTokenHash()).isNotNull();
        assertThat(savedPat.getTokenHash()).isNotEqualTo(plaintextToken); // Hash != plaintext
        assertThat(savedPat.getTokenHash()).doesNotContain(plaintextToken); // Plaintext not in hash
    }

    @Test
    @DisplayName("Should set createdAt timestamp")
    void shouldSetCreatedAtTimestamp() {
        // Given
        LocalDateTime beforeCreation = LocalDateTime.now();
        var command = new CreatePATUseCase.CreatePATCommand(
                "Timestamped Token",
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                superAdmin.getId()
        );

        // When
        CreatePATUseCase.CreatePATResult result = useCase.execute(command);
        LocalDateTime afterCreation = LocalDateTime.now();

        // Then
        assertThat(result.getCreatedAt()).isNotNull();
        assertThat(result.getCreatedAt()).isAfterOrEqualTo(beforeCreation);
        assertThat(result.getCreatedAt()).isBeforeOrEqualTo(afterCreation);
    }

    @Test
    @DisplayName("Should persist all PAT fields correctly")
    void shouldPersistAllPATFields() {
        // Given
        LocalDateTime expiresAt = LocalDateTime.of(2025, 12, 31, 23, 59);
        var command = new CreatePATUseCase.CreatePATCommand(
                "Complete PAT",
                PATScope.ADMIN,
                expiresAt,
                superAdmin.getId()
        );

        // When
        CreatePATUseCase.CreatePATResult result = useCase.execute(command);

        // Then - retrieve from database and verify all fields
        PersonalAccessToken savedPat = patRepository.findById(result.getId()).orElse(null);
        assertThat(savedPat).isNotNull();
        assertThat(savedPat.getId()).isEqualTo(result.getId());
        assertThat(savedPat.getName()).isEqualTo("Complete PAT");
        assertThat(savedPat.getScope()).isEqualTo(PATScope.ADMIN);
        assertThat(savedPat.getExpiresAt()).isEqualTo(expiresAt);
        assertThat(savedPat.getCreatedBy()).isEqualTo(superAdmin.getId());
        assertThat(savedPat.getCreatedAt()).isNotNull();
        assertThat(savedPat.getLastUsedAt()).isNull(); // Not used yet
        assertThat(savedPat.isRevoked()).isFalse(); // Not revoked
        assertThat(savedPat.getTokenIdentifier()).isNotNull();
        assertThat(savedPat.getTokenHash()).isNotNull();
    }

    @Test
    @DisplayName("Should find PAT by token identifier after creation")
    void shouldFindPATByTokenIdentifier() {
        // Given
        var command = new CreatePATUseCase.CreatePATCommand(
                "Findable PAT",
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                superAdmin.getId()
        );
        CreatePATUseCase.CreatePATResult result = useCase.execute(command);

        // Extract identifier from token: pat_<identifier>_<random>
        String[] parts = result.getPlaintextToken().split("_");
        String identifier = parts[1];

        // When
        PersonalAccessToken foundPat = patRepository.findByTokenIdentifier(identifier).orElse(null);

        // Then
        assertThat(foundPat).isNotNull();
        assertThat(foundPat.getId()).isEqualTo(result.getId());
        assertThat(foundPat.getName()).isEqualTo("Findable PAT");
    }
}

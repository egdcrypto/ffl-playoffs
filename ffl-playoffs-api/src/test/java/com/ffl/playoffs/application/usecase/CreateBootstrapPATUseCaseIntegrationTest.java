package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.IntegrationTestBase;
import com.ffl.playoffs.domain.model.PATScope;
import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.time.LocalDateTime;

import static org.assertj.core.api.Assertions.*;

/**
 * Integration tests for CreateBootstrapPATUseCase
 * Tests complete end-to-end flow with MongoDB persistence
 */
@DisplayName("CreateBootstrapPATUseCase Integration Tests")
class CreateBootstrapPATUseCaseIntegrationTest extends IntegrationTestBase {

    @Autowired
    private PersonalAccessTokenRepository patRepository;

    private CreateBootstrapPATUseCase useCase;

    @Override
    protected void baseSetUp() {
        super.baseSetUp();
        useCase = new CreateBootstrapPATUseCase(patRepository);
    }

    @Test
    @DisplayName("Should create bootstrap PAT successfully")
    void shouldCreateBootstrapPAT() {
        // When
        CreateBootstrapPATUseCase.CreateBootstrapPATResult result = useCase.execute();

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getId()).isNotNull();
        assertThat(result.getName()).isEqualTo("bootstrap");
        assertThat(result.getScope()).isEqualTo(PATScope.ADMIN);
        assertThat(result.getCreatedBy()).isEqualTo("SYSTEM");
        assertThat(result.getCreatedAt()).isNotNull();
        assertThat(result.getExpiresAt()).isNotNull();

        // Verify expiration is 1 year from now
        LocalDateTime expectedExpiration = LocalDateTime.now().plusYears(1);
        assertThat(result.getExpiresAt()).isAfter(expectedExpiration.minusSeconds(5));
        assertThat(result.getExpiresAt()).isBefore(expectedExpiration.plusSeconds(5));

        // Verify plaintext token format: pat_<identifier>_<random>
        String token = result.getPlaintextToken();
        assertThat(token).isNotNull();
        assertThat(token).startsWith("pat_");
        assertThat(token.split("_")).hasSize(3); // pat, identifier, random
    }

    @Test
    @DisplayName("Should store token with BCrypt hash")
    void shouldStoreTokenWithBCryptHash() {
        // When
        CreateBootstrapPATUseCase.CreateBootstrapPATResult result = useCase.execute();
        String plaintextToken = result.getPlaintextToken();

        // Then - retrieve from database and verify hash
        PersonalAccessToken savedPat = patRepository.findById(result.getId()).orElse(null);
        assertThat(savedPat).isNotNull();
        assertThat(savedPat.getTokenHash()).isNotNull();

        // Verify it's a BCrypt hash (starts with $2a$ or $2b$)
        assertThat(savedPat.getTokenHash()).matches("^\\$2[ab]\\$.*");

        // Verify hash != plaintext
        assertThat(savedPat.getTokenHash()).isNotEqualTo(plaintextToken);

        // Verify BCrypt can validate the hash
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(12);
        assertThat(encoder.matches(plaintextToken, savedPat.getTokenHash())).isTrue();
    }

    @Test
    @DisplayName("Should persist all bootstrap PAT fields correctly")
    void shouldPersistAllBootstrapPATFields() {
        // When
        CreateBootstrapPATUseCase.CreateBootstrapPATResult result = useCase.execute();

        // Then - retrieve from database and verify all fields
        PersonalAccessToken savedPat = patRepository.findById(result.getId()).orElse(null);
        assertThat(savedPat).isNotNull();
        assertThat(savedPat.getId()).isEqualTo(result.getId());
        assertThat(savedPat.getName()).isEqualTo("bootstrap");
        assertThat(savedPat.getScope()).isEqualTo(PATScope.ADMIN);
        assertThat(savedPat.getCreatedBy()).isEqualTo("SYSTEM");
        assertThat(savedPat.getCreatedAt()).isNotNull();
        assertThat(savedPat.getExpiresAt()).isNotNull();
        assertThat(savedPat.getLastUsedAt()).isNull(); // Not used yet
        assertThat(savedPat.isRevoked()).isFalse(); // Not revoked
        assertThat(savedPat.getRevokedAt()).isNull(); // Not revoked
        assertThat(savedPat.getTokenIdentifier()).isNotNull();
        assertThat(savedPat.getTokenHash()).isNotNull();
    }

    @Test
    @DisplayName("Should throw exception when bootstrap PAT already exists")
    void shouldThrowExceptionWhenBootstrapPATExists() {
        // Given - create first bootstrap PAT
        useCase.execute();

        // When/Then - try to create second bootstrap PAT
        assertThatThrownBy(() -> useCase.execute())
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("Bootstrap PAT already exists");
    }

    @Test
    @DisplayName("Should store plaintext token hash, not plaintext")
    void shouldNotStorePlaintextToken() {
        // When
        CreateBootstrapPATUseCase.CreateBootstrapPATResult result = useCase.execute();
        String plaintextToken = result.getPlaintextToken();

        // Then - database should NOT contain plaintext
        PersonalAccessToken savedPat = patRepository.findById(result.getId()).orElse(null);
        assertThat(savedPat).isNotNull();
        assertThat(savedPat.getTokenHash()).doesNotContain(plaintextToken);

        // Verify no plaintext in token identifier either
        assertThat(savedPat.getTokenIdentifier()).isNotEqualTo(plaintextToken);
        assertThat(plaintextToken).contains(savedPat.getTokenIdentifier()); // identifier is PART of token
    }

    @Test
    @DisplayName("Should find bootstrap PAT by name")
    void shouldFindBootstrapPATByName() {
        // Given
        CreateBootstrapPATUseCase.CreateBootstrapPATResult result = useCase.execute();

        // When
        boolean exists = patRepository.existsByName("bootstrap");

        // Then
        assertThat(exists).isTrue();
    }

    @Test
    @DisplayName("Should find bootstrap PAT by token identifier")
    void shouldFindBootstrapPATByTokenIdentifier() {
        // Given
        CreateBootstrapPATUseCase.CreateBootstrapPATResult result = useCase.execute();

        // Extract identifier from token: pat_<identifier>_<random>
        String[] parts = result.getPlaintextToken().split("_");
        String identifier = parts[1];

        // When
        PersonalAccessToken foundPat = patRepository.findByTokenIdentifier(identifier).orElse(null);

        // Then
        assertThat(foundPat).isNotNull();
        assertThat(foundPat.getId()).isEqualTo(result.getId());
        assertThat(foundPat.getName()).isEqualTo("bootstrap");
    }

    @Test
    @DisplayName("Should set createdAt timestamp")
    void shouldSetCreatedAtTimestamp() {
        // Given
        LocalDateTime beforeCreation = LocalDateTime.now();

        // When
        CreateBootstrapPATUseCase.CreateBootstrapPATResult result = useCase.execute();
        LocalDateTime afterCreation = LocalDateTime.now();

        // Then
        assertThat(result.getCreatedAt()).isNotNull();
        assertThat(result.getCreatedAt()).isAfterOrEqualTo(beforeCreation);
        assertThat(result.getCreatedAt()).isBeforeOrEqualTo(afterCreation);
    }

    @Test
    @DisplayName("Should generate cryptographically secure token")
    void shouldGenerateCryptographicallySecureToken() {
        // When - create bootstrap PAT
        CreateBootstrapPATUseCase.CreateBootstrapPATResult result = useCase.execute();
        String token = result.getPlaintextToken();

        // Then
        // Token format: pat_<32-char-identifier>_<64+-char-random>
        String[] parts = token.split("_");
        assertThat(parts).hasSize(3);
        assertThat(parts[0]).isEqualTo("pat");

        // Identifier should be 32 characters (UUID without hyphens)
        assertThat(parts[1]).hasSize(32);
        assertThat(parts[1]).matches("^[a-f0-9]{32}$");

        // Random part should be at least 64 characters (Base64 URL-safe)
        assertThat(parts[2].length()).isGreaterThanOrEqualTo(64);
        assertThat(parts[2]).matches("^[A-Za-z0-9_-]+$"); // Base64 URL-safe chars
    }

    @Test
    @DisplayName("Should create bootstrap PAT with ADMIN scope")
    void shouldCreateBootstrapPATWithAdminScope() {
        // When
        CreateBootstrapPATUseCase.CreateBootstrapPATResult result = useCase.execute();

        // Then
        assertThat(result.getScope()).isEqualTo(PATScope.ADMIN);

        // Verify in database
        PersonalAccessToken savedPat = patRepository.findById(result.getId()).orElse(null);
        assertThat(savedPat).isNotNull();
        assertThat(savedPat.getScope()).isEqualTo(PATScope.ADMIN);
    }

    @Test
    @DisplayName("Should create bootstrap PAT created by SYSTEM")
    void shouldCreateBootstrapPATCreatedBySystem() {
        // When
        CreateBootstrapPATUseCase.CreateBootstrapPATResult result = useCase.execute();

        // Then
        assertThat(result.getCreatedBy()).isEqualTo("SYSTEM");

        // Verify in database
        PersonalAccessToken savedPat = patRepository.findById(result.getId()).orElse(null);
        assertThat(savedPat).isNotNull();
        assertThat(savedPat.getCreatedBy()).isEqualTo("SYSTEM");
    }
}

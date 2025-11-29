package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.IntegrationTestBase;
import com.ffl.playoffs.domain.model.PATScope;
import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

/**
 * Integration tests for ValidatePATUseCase
 * Tests PAT validation including expiration, revocation, and scope checking
 */
@DisplayName("ValidatePATUseCase Integration Tests")
class ValidatePATUseCaseTest extends IntegrationTestBase {

    @Autowired
    private PersonalAccessTokenRepository tokenRepository;

    @Autowired
    private UserRepository userRepository;

    private ValidatePATUseCase useCase;
    private UUID testUserId;

    @Override
    protected void baseSetUp() {
        super.baseSetUp();
        useCase = new ValidatePATUseCase(tokenRepository, userRepository);

        // Create a test user
        User user = new User("pat-user@example.com", "PAT User", "google-pat", Role.ADMIN);
        user = userRepository.save(user);
        testUserId = user.getId();
    }

    @Test
    @DisplayName("Should validate valid token successfully")
    void shouldValidateValidToken() {
        // Given
        String tokenIdentifier = "abc123";
        String fullToken = "pat_" + tokenIdentifier + "_secret456";

        PersonalAccessToken pat = new PersonalAccessToken(
                "Test Token",
                tokenIdentifier,
                "hash_of_token",  // In real scenario, this would be BCrypt hash
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                testUserId.toString()
        );
        tokenRepository.save(pat);

        var command = new ValidatePATUseCase.ValidatePATCommand(fullToken);

        // When
        ValidatePATUseCase.ValidationResult result = useCase.execute(command);

        // Then
        assertThat(result.isValid()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Token is valid");
        assertThat(result.getToken()).isNotNull();
        assertThat(result.getToken().getId()).isEqualTo(pat.getId());
        assertThat(result.getUser()).isNotNull();
        assertThat(result.getUser().getId()).isEqualTo(testUserId);
        assertThat(result.getScope()).isEqualTo(PATScope.WRITE);

        // Verify last used timestamp was updated
        PersonalAccessToken updatedPat = tokenRepository.findById(pat.getId()).orElse(null);
        assertThat(updatedPat).isNotNull();
        assertThat(updatedPat.getLastUsedAt()).isNotNull();
    }

    @Test
    @DisplayName("Should validate token with matching scope requirement")
    void shouldValidateTokenWithMatchingScope() {
        // Given
        String tokenIdentifier = "def456";
        String fullToken = "pat_" + tokenIdentifier + "_secret789";

        PersonalAccessToken pat = new PersonalAccessToken(
                "Read Token",
                tokenIdentifier,
                "hash_of_token",
                PATScope.READ_ONLY,
                LocalDateTime.now().plusDays(30),
                testUserId
        );
        tokenRepository.save(pat);

        var command = new ValidatePATUseCase.ValidatePATCommand(fullToken, PATScope.READ_ONLY);

        // When
        ValidatePATUseCase.ValidationResult result = useCase.execute(command);

        // Then
        assertThat(result.isValid()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Token is valid");
        assertThat(result.getScope()).isEqualTo(PATScope.READ_ONLY);
    }

    @Test
    @DisplayName("Should reject token with insufficient scope")
    void shouldRejectTokenWithInsufficientScope() {
        // Given - READ_ONLY token trying to access WRITE endpoint
        String tokenIdentifier = "ghi789";
        String fullToken = "pat_" + tokenIdentifier + "_secret111";

        PersonalAccessToken pat = new PersonalAccessToken(
                "Limited Token",
                tokenIdentifier,
                "hash_of_token",
                PATScope.READ_ONLY,
                LocalDateTime.now().plusDays(30),
                testUserId
        );
        tokenRepository.save(pat);

        var command = new ValidatePATUseCase.ValidatePATCommand(fullToken, PATScope.WRITE);

        // When
        ValidatePATUseCase.ValidationResult result = useCase.execute(command);

        // Then
        assertThat(result.isValid()).isFalse();
        assertThat(result.getMessage()).contains("Insufficient scope");
        assertThat(result.getMessage()).contains("Required: WRITE");
        assertThat(result.getMessage()).contains("Has: READ_ONLY");
    }

    @Test
    @DisplayName("Should validate ADMIN scope has all permissions")
    void shouldValidateAdminScopeHasAllPermissions() {
        // Given
        String tokenIdentifier = "admin123";
        String fullToken = "pat_" + tokenIdentifier + "_adminsecret";

        PersonalAccessToken pat = new PersonalAccessToken(
                "Admin Token",
                tokenIdentifier,
                "hash_of_token",
                PATScope.ADMIN,
                LocalDateTime.now().plusDays(30),
                testUserId
        );
        tokenRepository.save(pat);

        // Test with WRITE requirement
        var writeCommand = new ValidatePATUseCase.ValidatePATCommand(fullToken, PATScope.WRITE);
        ValidatePATUseCase.ValidationResult writeResult = useCase.execute(writeCommand);
        assertThat(writeResult.isValid()).isTrue();

        // Test with READ_ONLY requirement
        var readCommand = new ValidatePATUseCase.ValidatePATCommand(fullToken, PATScope.READ_ONLY);
        ValidatePATUseCase.ValidationResult readResult = useCase.execute(readCommand);
        assertThat(readResult.isValid()).isTrue();
    }

    @Test
    @DisplayName("Should validate WRITE scope has READ_ONLY permission")
    void shouldValidateWriteScopeHasReadOnlyPermission() {
        // Given
        String tokenIdentifier = "write123";
        String fullToken = "pat_" + tokenIdentifier + "_writesecret";

        PersonalAccessToken pat = new PersonalAccessToken(
                "Write Token",
                tokenIdentifier,
                "hash_of_token",
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                testUserId
        );
        tokenRepository.save(pat);

        var command = new ValidatePATUseCase.ValidatePATCommand(fullToken, PATScope.READ_ONLY);

        // When
        ValidatePATUseCase.ValidationResult result = useCase.execute(command);

        // Then
        assertThat(result.isValid()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Token is valid");
    }

    @Test
    @DisplayName("Should reject WRITE scope for ADMIN requirement")
    void shouldRejectWriteScopeForAdminRequirement() {
        // Given
        String tokenIdentifier = "writeonly";
        String fullToken = "pat_" + tokenIdentifier + "_secret";

        PersonalAccessToken pat = new PersonalAccessToken(
                "Write Token",
                tokenIdentifier,
                "hash_of_token",
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                testUserId
        );
        tokenRepository.save(pat);

        var command = new ValidatePATUseCase.ValidatePATCommand(fullToken, PATScope.ADMIN);

        // When
        ValidatePATUseCase.ValidationResult result = useCase.execute(command);

        // Then
        assertThat(result.isValid()).isFalse();
        assertThat(result.getMessage()).contains("Insufficient scope");
    }

    @Test
    @DisplayName("Should reject expired token")
    void shouldRejectExpiredToken() {
        // Given - token expired yesterday
        String tokenIdentifier = "expired123";
        String fullToken = "pat_" + tokenIdentifier + "_expiredsecret";

        PersonalAccessToken pat = new PersonalAccessToken(
                "Expired Token",
                tokenIdentifier,
                "hash_of_token",
                PATScope.WRITE,
                LocalDateTime.now().minusDays(1),  // Expired yesterday
                testUserId
        );
        tokenRepository.save(pat);

        var command = new ValidatePATUseCase.ValidatePATCommand(fullToken);

        // When
        ValidatePATUseCase.ValidationResult result = useCase.execute(command);

        // Then
        assertThat(result.isValid()).isFalse();
        assertThat(result.getMessage()).isEqualTo("Token has expired");
    }

    @Test
    @DisplayName("Should reject revoked token")
    void shouldRejectRevokedToken() {
        // Given
        String tokenIdentifier = "revoked123";
        String fullToken = "pat_" + tokenIdentifier + "_revokedsecret";

        PersonalAccessToken pat = new PersonalAccessToken(
                "Revoked Token",
                tokenIdentifier,
                "hash_of_token",
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                testUserId
        );
        pat.revoke();
        tokenRepository.save(pat);

        var command = new ValidatePATUseCase.ValidatePATCommand(fullToken);

        // When
        ValidatePATUseCase.ValidationResult result = useCase.execute(command);

        // Then
        assertThat(result.isValid()).isFalse();
        assertThat(result.getMessage()).isEqualTo("Token has been revoked");
    }

    @Test
    @DisplayName("Should throw exception when token not found")
    void shouldThrowExceptionWhenTokenNotFound() {
        // Given - token identifier that doesn't exist
        String fullToken = "pat_nonexistent_secret";

        var command = new ValidatePATUseCase.ValidatePATCommand(fullToken);

        // When/Then
        assertThatThrownBy(() -> useCase.execute(command))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Invalid token");
    }

    @Test
    @DisplayName("Should throw exception for invalid token format")
    void shouldThrowExceptionForInvalidTokenFormat() {
        // Test token without pat_ prefix
        var command1 = new ValidatePATUseCase.ValidatePATCommand("invalid_token_format");
        assertThatThrownBy(() -> useCase.execute(command1))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Invalid PAT format");

        // Test token with only pat_ prefix
        var command2 = new ValidatePATUseCase.ValidatePATCommand("pat_");
        assertThatThrownBy(() -> useCase.execute(command2))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Invalid PAT format");

        // Test token without identifier
        var command3 = new ValidatePATUseCase.ValidatePATCommand("pat__secret");
        assertThatThrownBy(() -> useCase.execute(command3))
                .isInstanceOf(IllegalArgumentException.class);
    }

    @Test
    @DisplayName("Should update last used timestamp on successful validation")
    void shouldUpdateLastUsedTimestamp() {
        // Given
        String tokenIdentifier = "timestamp123";
        String fullToken = "pat_" + tokenIdentifier + "_secret";

        PersonalAccessToken pat = new PersonalAccessToken(
                "Timestamp Token",
                tokenIdentifier,
                "hash_of_token",
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                testUserId
        );
        tokenRepository.save(pat);

        // Verify initially no last used timestamp
        assertThat(pat.getLastUsedAt()).isNull();

        var command = new ValidatePATUseCase.ValidatePATCommand(fullToken);

        // When - validate token
        LocalDateTime beforeValidation = LocalDateTime.now();
        useCase.execute(command);
        LocalDateTime afterValidation = LocalDateTime.now();

        // Then - verify last used was updated
        PersonalAccessToken updatedPat = tokenRepository.findById(pat.getId()).orElse(null);
        assertThat(updatedPat).isNotNull();
        assertThat(updatedPat.getLastUsedAt()).isNotNull();
        assertThat(updatedPat.getLastUsedAt()).isBetween(beforeValidation, afterValidation);
    }

    @Test
    @DisplayName("Should not update last used timestamp for expired token")
    void shouldNotUpdateLastUsedForExpiredToken() {
        // Given
        String tokenIdentifier = "notupdated";
        String fullToken = "pat_" + tokenIdentifier + "_secret";

        PersonalAccessToken pat = new PersonalAccessToken(
                "Expired No Update",
                tokenIdentifier,
                "hash_of_token",
                PATScope.WRITE,
                LocalDateTime.now().minusDays(1),  // Expired
                testUserId
        );
        tokenRepository.save(pat);

        var command = new ValidatePATUseCase.ValidatePATCommand(fullToken);

        // When
        useCase.execute(command);

        // Then - last used should still be null
        PersonalAccessToken updatedPat = tokenRepository.findById(pat.getId()).orElse(null);
        assertThat(updatedPat).isNotNull();
        assertThat(updatedPat.getLastUsedAt()).isNull();
    }

    @Test
    @DisplayName("Should validate token without expiration date")
    void shouldValidateTokenWithoutExpirationDate() {
        // Given - token with null expiration (never expires)
        String tokenIdentifier = "noexpiry";
        String fullToken = "pat_" + tokenIdentifier + "_secret";

        PersonalAccessToken pat = new PersonalAccessToken(
                "No Expiry Token",
                tokenIdentifier,
                "hash_of_token",
                PATScope.WRITE,
                null,  // No expiration
                testUserId
        );
        tokenRepository.save(pat);

        var command = new ValidatePATUseCase.ValidatePATCommand(fullToken);

        // When
        ValidatePATUseCase.ValidationResult result = useCase.execute(command);

        // Then
        assertThat(result.isValid()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Token is valid");
    }

    @Test
    @DisplayName("Should extract token identifier correctly from various formats")
    void shouldExtractTokenIdentifierCorrectly() {
        // Given - various valid token formats
        String tokenIdentifier = "complex_id_with_underscores";
        String fullToken = "pat_" + tokenIdentifier + "_secret_with_underscores";

        PersonalAccessToken pat = new PersonalAccessToken(
                "Complex Token",
                tokenIdentifier,
                "hash_of_token",
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                testUserId
        );
        tokenRepository.save(pat);

        var command = new ValidatePATUseCase.ValidatePATCommand(fullToken);

        // When
        ValidatePATUseCase.ValidationResult result = useCase.execute(command);

        // Then
        assertThat(result.isValid()).isTrue();
        assertThat(result.getToken().getTokenIdentifier()).isEqualTo(tokenIdentifier);
    }

    @Test
    @DisplayName("Should return user context in validation result")
    void shouldReturnUserContextInValidationResult() {
        // Given
        String tokenIdentifier = "usercontext";
        String fullToken = "pat_" + tokenIdentifier + "_secret";

        PersonalAccessToken pat = new PersonalAccessToken(
                "User Context Token",
                tokenIdentifier,
                "hash_of_token",
                PATScope.ADMIN,
                LocalDateTime.now().plusDays(30),
                testUserId
        );
        tokenRepository.save(pat);

        var command = new ValidatePATUseCase.ValidatePATCommand(fullToken);

        // When
        ValidatePATUseCase.ValidationResult result = useCase.execute(command);

        // Then
        assertThat(result.isValid()).isTrue();
        assertThat(result.getUser()).isNotNull();
        assertThat(result.getUser().getId()).isEqualTo(testUserId);
        assertThat(result.getUser().getEmail()).isEqualTo("pat-user@example.com");
        assertThat(result.getUser().getName()).isEqualTo("PAT User");
        assertThat(result.getUser().getRole()).isEqualTo(Role.ADMIN);
    }
}

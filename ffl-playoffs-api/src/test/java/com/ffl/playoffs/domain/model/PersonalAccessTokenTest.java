package com.ffl.playoffs.domain.model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("PersonalAccessToken Domain Entity Tests")
class PersonalAccessTokenTest {

    private UUID userId;

    @BeforeEach
    void setUp() {
        userId = UUID.randomUUID();
    }

    @Nested
    @DisplayName("Construction")
    class Construction {

        @Test
        @DisplayName("should create PAT with default constructor")
        void shouldCreatePATWithDefaultConstructor() {
            // When
            PersonalAccessToken pat = new PersonalAccessToken();

            // Then
            assertThat(pat.getId()).isNotNull();
            assertThat(pat.getCreatedAt()).isNotNull();
            assertThat(pat.isRevoked()).isFalse();
        }

        @Test
        @DisplayName("should create PAT with full constructor")
        void shouldCreatePATWithFullConstructor() {
            // Given
            String name = "CI/CD Token";
            String tokenIdentifier = "pat_abc123";
            String tokenHash = "$2a$10$...";
            PATScope scope = PATScope.WRITE;
            LocalDateTime expiresAt = LocalDateTime.now().plusDays(90);

            // When
            PersonalAccessToken pat = new PersonalAccessToken(
                name, tokenIdentifier, tokenHash, scope, expiresAt, userId
            );

            // Then
            assertThat(pat.getName()).isEqualTo(name);
            assertThat(pat.getTokenIdentifier()).isEqualTo(tokenIdentifier);
            assertThat(pat.getTokenHash()).isEqualTo(tokenHash);
            assertThat(pat.getScope()).isEqualTo(scope);
            assertThat(pat.getExpiresAt()).isEqualTo(expiresAt);
            assertThat(pat.getCreatedBy()).isEqualTo(userId);
            assertThat(pat.isRevoked()).isFalse();
        }
    }

    @Nested
    @DisplayName("Token Validation")
    class TokenValidation {

        @Test
        @DisplayName("should be valid when not revoked and not expired")
        void shouldBeValidWhenNotRevokedAndNotExpired() {
            // Given
            PersonalAccessToken pat = new PersonalAccessToken(
                "Test Token", "pat_123", "hash", PATScope.READ_ONLY,
                LocalDateTime.now().plusDays(30), userId
            );

            // Then
            assertThat(pat.isValid()).isTrue();
        }

        @Test
        @DisplayName("should be invalid when revoked")
        void shouldBeInvalidWhenRevoked() {
            // Given
            PersonalAccessToken pat = new PersonalAccessToken(
                "Test Token", "pat_123", "hash", PATScope.READ_ONLY,
                LocalDateTime.now().plusDays(30), userId
            );

            // When
            pat.revoke();

            // Then
            assertThat(pat.isValid()).isFalse();
        }

        @Test
        @DisplayName("should be invalid when expired")
        void shouldBeInvalidWhenExpired() {
            // Given
            PersonalAccessToken pat = new PersonalAccessToken(
                "Test Token", "pat_123", "hash", PATScope.READ_ONLY,
                LocalDateTime.now().minusDays(1), userId
            );

            // Then
            assertThat(pat.isValid()).isFalse();
        }

        @Test
        @DisplayName("should be valid when expiresAt is null (no expiration)")
        void shouldBeValidWhenNoExpiration() {
            // Given
            PersonalAccessToken pat = new PersonalAccessToken(
                "Test Token", "pat_123", "hash", PATScope.READ_ONLY,
                null, userId
            );

            // Then
            assertThat(pat.isValid()).isTrue();
        }

        @Test
        @DisplayName("isExpired should return true when past expiration")
        void isExpiredShouldReturnTrueWhenPastExpiration() {
            // Given
            PersonalAccessToken pat = new PersonalAccessToken(
                "Test Token", "pat_123", "hash", PATScope.READ_ONLY,
                LocalDateTime.now().minusHours(1), userId
            );

            // Then
            assertThat(pat.isExpired()).isTrue();
        }

        @Test
        @DisplayName("isExpired should return false when before expiration")
        void isExpiredShouldReturnFalseWhenBeforeExpiration() {
            // Given
            PersonalAccessToken pat = new PersonalAccessToken(
                "Test Token", "pat_123", "hash", PATScope.READ_ONLY,
                LocalDateTime.now().plusHours(1), userId
            );

            // Then
            assertThat(pat.isExpired()).isFalse();
        }

        @Test
        @DisplayName("isExpired should return false when no expiration set")
        void isExpiredShouldReturnFalseWhenNoExpiration() {
            // Given
            PersonalAccessToken pat = new PersonalAccessToken(
                "Test Token", "pat_123", "hash", PATScope.READ_ONLY,
                null, userId
            );

            // Then
            assertThat(pat.isExpired()).isFalse();
        }
    }

    @Nested
    @DisplayName("Scope Validation")
    class ScopeValidation {

        @Test
        @DisplayName("ADMIN scope should have all permissions")
        void adminScopeShouldHaveAllPermissions() {
            // Given
            PersonalAccessToken pat = new PersonalAccessToken(
                "Admin Token", "pat_admin", "hash", PATScope.ADMIN,
                null, userId
            );

            // Then
            assertThat(pat.hasScope(PATScope.READ_ONLY)).isTrue();
            assertThat(pat.hasScope(PATScope.WRITE)).isTrue();
            assertThat(pat.hasScope(PATScope.ADMIN)).isTrue();
        }

        @Test
        @DisplayName("WRITE scope should have WRITE and READ_ONLY permissions")
        void writeScopeShouldHaveWriteAndReadPermissions() {
            // Given
            PersonalAccessToken pat = new PersonalAccessToken(
                "Write Token", "pat_write", "hash", PATScope.WRITE,
                null, userId
            );

            // Then
            assertThat(pat.hasScope(PATScope.READ_ONLY)).isTrue();
            assertThat(pat.hasScope(PATScope.WRITE)).isTrue();
            assertThat(pat.hasScope(PATScope.ADMIN)).isFalse();
        }

        @Test
        @DisplayName("READ_ONLY scope should only have READ_ONLY permission")
        void readOnlyScopeShouldOnlyHaveReadPermission() {
            // Given
            PersonalAccessToken pat = new PersonalAccessToken(
                "Read Token", "pat_read", "hash", PATScope.READ_ONLY,
                null, userId
            );

            // Then
            assertThat(pat.hasScope(PATScope.READ_ONLY)).isTrue();
            assertThat(pat.hasScope(PATScope.WRITE)).isFalse();
            assertThat(pat.hasScope(PATScope.ADMIN)).isFalse();
        }
    }

    @Nested
    @DisplayName("Revocation")
    class Revocation {

        @Test
        @DisplayName("should revoke token")
        void shouldRevokeToken() {
            // Given
            PersonalAccessToken pat = new PersonalAccessToken(
                "Test Token", "pat_123", "hash", PATScope.READ_ONLY,
                null, userId
            );
            assertThat(pat.isRevoked()).isFalse();

            // When
            pat.revoke();

            // Then
            assertThat(pat.isRevoked()).isTrue();
            assertThat(pat.isValid()).isFalse();
        }

        @Test
        @DisplayName("should throw exception when revoking already revoked token")
        void shouldThrowExceptionWhenRevokingAlreadyRevokedToken() {
            // Given
            PersonalAccessToken pat = new PersonalAccessToken(
                "Test Token", "pat_123", "hash", PATScope.READ_ONLY,
                null, userId
            );
            pat.revoke();

            // When/Then
            assertThatThrownBy(() -> pat.revoke())
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("already revoked");
        }
    }

    @Nested
    @DisplayName("Last Used Tracking")
    class LastUsedTracking {

        @Test
        @DisplayName("should update last used timestamp")
        void shouldUpdateLastUsedTimestamp() {
            // Given
            PersonalAccessToken pat = new PersonalAccessToken(
                "Test Token", "pat_123", "hash", PATScope.READ_ONLY,
                null, userId
            );
            assertThat(pat.getLastUsedAt()).isNull();

            LocalDateTime beforeUpdate = LocalDateTime.now();

            // When
            pat.updateLastUsed();

            // Then
            assertThat(pat.getLastUsedAt()).isNotNull();
            assertThat(pat.getLastUsedAt()).isAfterOrEqualTo(beforeUpdate);
        }

        @Test
        @DisplayName("should update last used multiple times")
        void shouldUpdateLastUsedMultipleTimes() throws InterruptedException {
            // Given
            PersonalAccessToken pat = new PersonalAccessToken(
                "Test Token", "pat_123", "hash", PATScope.READ_ONLY,
                null, userId
            );

            // When
            pat.updateLastUsed();
            LocalDateTime firstUse = pat.getLastUsedAt();

            Thread.sleep(10);

            pat.updateLastUsed();
            LocalDateTime secondUse = pat.getLastUsedAt();

            // Then
            assertThat(secondUse).isAfterOrEqualTo(firstUse);
        }
    }

    @Nested
    @DisplayName("validateOrThrow Method")
    class ValidateOrThrow {

        @Test
        @DisplayName("should not throw exception for valid token")
        void shouldNotThrowExceptionForValidToken() {
            // Given
            PersonalAccessToken pat = new PersonalAccessToken(
                "Test Token", "pat_123", "hash", PATScope.READ_ONLY,
                LocalDateTime.now().plusDays(30), userId
            );

            // When/Then
            assertThatCode(() -> pat.validateOrThrow())
                .doesNotThrowAnyException();
        }

        @Test
        @DisplayName("should throw InvalidTokenException when revoked")
        void shouldThrowInvalidTokenExceptionWhenRevoked() {
            // Given
            PersonalAccessToken pat = new PersonalAccessToken(
                "Test Token", "pat_123", "hash", PATScope.READ_ONLY,
                LocalDateTime.now().plusDays(30), userId
            );
            pat.revoke();

            // When/Then
            assertThatThrownBy(() -> pat.validateOrThrow())
                .isInstanceOf(PersonalAccessToken.InvalidTokenException.class)
                .hasMessageContaining("revoked");
        }

        @Test
        @DisplayName("should throw InvalidTokenException when expired")
        void shouldThrowInvalidTokenExceptionWhenExpired() {
            // Given
            PersonalAccessToken pat = new PersonalAccessToken(
                "Test Token", "pat_123", "hash", PATScope.READ_ONLY,
                LocalDateTime.now().minusDays(1), userId
            );

            // When/Then
            assertThatThrownBy(() -> pat.validateOrThrow())
                .isInstanceOf(PersonalAccessToken.InvalidTokenException.class)
                .hasMessageContaining("expired");
        }
    }

    @Nested
    @DisplayName("Getters and Setters")
    class GettersAndSetters {

        private PersonalAccessToken pat;

        @BeforeEach
        void setUp() {
            pat = new PersonalAccessToken();
        }

        @Test
        @DisplayName("should get and set name")
        void shouldGetAndSetName() {
            // When
            pat.setName("New Token Name");

            // Then
            assertThat(pat.getName()).isEqualTo("New Token Name");
        }

        @Test
        @DisplayName("should get and set tokenIdentifier")
        void shouldGetAndSetTokenIdentifier() {
            // When
            pat.setTokenIdentifier("pat_new123");

            // Then
            assertThat(pat.getTokenIdentifier()).isEqualTo("pat_new123");
        }

        @Test
        @DisplayName("should get and set tokenHash")
        void shouldGetAndSetTokenHash() {
            // When
            pat.setTokenHash("$2a$10$newhash");

            // Then
            assertThat(pat.getTokenHash()).isEqualTo("$2a$10$newhash");
        }

        @Test
        @DisplayName("should get and set scope")
        void shouldGetAndSetScope() {
            // When
            pat.setScope(PATScope.ADMIN);

            // Then
            assertThat(pat.getScope()).isEqualTo(PATScope.ADMIN);
        }

        @Test
        @DisplayName("should get and set expiresAt")
        void shouldGetAndSetExpiresAt() {
            // Given
            LocalDateTime expiration = LocalDateTime.now().plusDays(60);

            // When
            pat.setExpiresAt(expiration);

            // Then
            assertThat(pat.getExpiresAt()).isEqualTo(expiration);
        }

        @Test
        @DisplayName("should get and set createdBy")
        void shouldGetAndSetCreatedBy() {
            // Given
            UUID newUserId = UUID.randomUUID();

            // When
            pat.setCreatedBy(newUserId);

            // Then
            assertThat(pat.getCreatedBy()).isEqualTo(newUserId);
        }
    }
}

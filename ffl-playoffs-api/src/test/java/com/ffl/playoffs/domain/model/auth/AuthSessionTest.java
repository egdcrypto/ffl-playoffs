package com.ffl.playoffs.domain.model.auth;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.EnumSet;
import java.util.Set;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("AuthSession Tests")
class AuthSessionTest {

    private UUID userId;
    private UUID patId;
    private String googleId;
    private Set<Permission> permissions;

    @BeforeEach
    void setUp() {
        userId = UUID.randomUUID();
        patId = UUID.randomUUID();
        googleId = "google-" + UUID.randomUUID();
        permissions = EnumSet.of(Permission.VIEW_ROSTER, Permission.BUILD_ROSTER, Permission.VIEW_STANDINGS);
    }

    @Nested
    @DisplayName("createGoogleSession tests")
    class CreateGoogleSessionTests {

        @Test
        @DisplayName("should create session with valid parameters")
        void shouldCreateSessionWithValidParameters() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");

            assertThat(session.getId()).isNotNull();
            assertThat(session.getUserId()).isEqualTo(userId);
            assertThat(session.getGoogleId()).isEqualTo(googleId);
            assertThat(session.getSessionToken()).isNotNull().hasSize(64);
            assertThat(session.getRefreshToken()).isNotNull().hasSize(64);
            assertThat(session.getAuthType()).isEqualTo(AuthSession.AuthType.GOOGLE_OAUTH);
            assertThat(session.getStatus()).isEqualTo(SessionStatus.ACTIVE);
            assertThat(session.getPermissions()).containsExactlyInAnyOrderElementsOf(permissions);
            assertThat(session.getCreatedAt()).isNotNull();
            assertThat(session.getExpiresAt()).isAfter(Instant.now());
            assertThat(session.getRefreshExpiresAt()).isAfter(session.getExpiresAt());
            assertThat(session.getIpAddress()).isEqualTo("192.168.1.1");
            assertThat(session.getUserAgent()).isEqualTo("Mozilla/5.0");
        }

        @Test
        @DisplayName("should throw exception for null userId")
        void shouldThrowExceptionForNullUserId() {
            assertThatThrownBy(() -> AuthSession.createGoogleSession(
                    null, googleId, permissions, "192.168.1.1", "Mozilla/5.0"))
                    .isInstanceOf(NullPointerException.class);
        }

        @Test
        @DisplayName("should throw exception for null googleId")
        void shouldThrowExceptionForNullGoogleId() {
            assertThatThrownBy(() -> AuthSession.createGoogleSession(
                    userId, null, permissions, "192.168.1.1", "Mozilla/5.0"))
                    .isInstanceOf(NullPointerException.class);
        }
    }

    @Nested
    @DisplayName("createPATSession tests")
    class CreatePATSessionTests {

        @Test
        @DisplayName("should create PAT session with valid parameters")
        void shouldCreatePATSessionWithValidParameters() {
            AuthSession session = AuthSession.createPATSession(
                    patId, permissions, "10.0.0.1", "curl/7.64.1");

            assertThat(session.getId()).isNotNull();
            assertThat(session.getPatId()).isEqualTo(patId);
            assertThat(session.getSessionToken()).isNotNull().hasSize(64);
            assertThat(session.getRefreshToken()).isNull();
            assertThat(session.getAuthType()).isEqualTo(AuthSession.AuthType.PAT);
            assertThat(session.getStatus()).isEqualTo(SessionStatus.ACTIVE);
            assertThat(session.getPermissions()).containsExactlyInAnyOrderElementsOf(permissions);
            assertThat(session.getIpAddress()).isEqualTo("10.0.0.1");
            assertThat(session.getUserAgent()).isEqualTo("curl/7.64.1");
        }

        @Test
        @DisplayName("should throw exception for null patId")
        void shouldThrowExceptionForNullPatId() {
            assertThatThrownBy(() -> AuthSession.createPATSession(
                    null, permissions, "10.0.0.1", "curl/7.64.1"))
                    .isInstanceOf(NullPointerException.class);
        }
    }

    @Nested
    @DisplayName("validation tests")
    class ValidationTests {

        @Test
        @DisplayName("isValid should return true for active non-expired session")
        void isValidShouldReturnTrueForActiveNonExpired() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");
            assertThat(session.isValid()).isTrue();
        }

        @Test
        @DisplayName("isValid should return false for expired session")
        void isValidShouldReturnFalseForExpired() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");
            session.setExpiresAt(Instant.now().minus(1, ChronoUnit.HOURS));
            assertThat(session.isValid()).isFalse();
        }

        @Test
        @DisplayName("isExpired should return true for past expiration")
        void isExpiredShouldReturnTrueForPastExpiration() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");
            session.setExpiresAt(Instant.now().minus(1, ChronoUnit.HOURS));
            assertThat(session.isExpired()).isTrue();
        }

        @Test
        @DisplayName("isRefreshExpired should return true for null refresh token expiry")
        void isRefreshExpiredShouldReturnTrueForNull() {
            AuthSession session = AuthSession.createPATSession(
                    patId, permissions, "10.0.0.1", "curl/7.64.1");
            assertThat(session.isRefreshExpired()).isTrue();
        }
    }

    @Nested
    @DisplayName("invalidate tests")
    class InvalidateTests {

        @Test
        @DisplayName("should invalidate active session")
        void shouldInvalidateActiveSession() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");

            session.invalidate();

            assertThat(session.getStatus()).isEqualTo(SessionStatus.INVALIDATED);
            assertThat(session.getInvalidatedAt()).isNotNull();
        }

        @Test
        @DisplayName("should throw exception when already invalidated")
        void shouldThrowExceptionWhenAlreadyInvalidated() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");
            session.invalidate();

            assertThatThrownBy(() -> session.invalidate())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot invalidate session");
        }
    }

    @Nested
    @DisplayName("revoke tests")
    class RevokeTests {

        @Test
        @DisplayName("should revoke active session")
        void shouldRevokeActiveSession() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");

            session.revoke();

            assertThat(session.getStatus()).isEqualTo(SessionStatus.REVOKED);
            assertThat(session.getInvalidatedAt()).isNotNull();
        }

        @Test
        @DisplayName("should throw exception when already revoked")
        void shouldThrowExceptionWhenAlreadyRevoked() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");
            session.revoke();

            assertThatThrownBy(() -> session.revoke())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot revoke session");
        }
    }

    @Nested
    @DisplayName("refresh tests")
    class RefreshTests {

        @Test
        @DisplayName("should refresh active session with new token")
        void shouldRefreshActiveSessionWithNewToken() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");
            String originalToken = session.getSessionToken();
            Instant originalExpiry = session.getExpiresAt();

            String newToken = session.refresh();

            assertThat(newToken).isNotEqualTo(originalToken);
            assertThat(session.getSessionToken()).isEqualTo(newToken);
            assertThat(session.getExpiresAt()).isAfter(originalExpiry);
        }

        @Test
        @DisplayName("should throw exception when refresh token expired")
        void shouldThrowExceptionWhenRefreshTokenExpired() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");
            session.setRefreshExpiresAt(Instant.now().minus(1, ChronoUnit.HOURS));

            assertThatThrownBy(() -> session.refresh())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Refresh token has expired");
        }

        @Test
        @DisplayName("should throw exception when session invalidated")
        void shouldThrowExceptionWhenSessionInvalidated() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");
            session.invalidate();

            assertThatThrownBy(() -> session.refresh())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot refresh session");
        }
    }

    @Nested
    @DisplayName("permission tests")
    class PermissionTests {

        @Test
        @DisplayName("hasPermission should return true when permission exists")
        void hasPermissionShouldReturnTrueWhenExists() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");

            assertThat(session.hasPermission(Permission.VIEW_ROSTER)).isTrue();
            assertThat(session.hasPermission(Permission.BUILD_ROSTER)).isTrue();
        }

        @Test
        @DisplayName("hasPermission should return false when permission missing")
        void hasPermissionShouldReturnFalseWhenMissing() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");

            assertThat(session.hasPermission(Permission.INVITE_ADMINS)).isFalse();
            assertThat(session.hasPermission(Permission.CREATE_LEAGUE)).isFalse();
        }

        @Test
        @DisplayName("hasAllPermissions should return true when all exist")
        void hasAllPermissionsShouldReturnTrueWhenAllExist() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");

            Set<Permission> required = EnumSet.of(Permission.VIEW_ROSTER, Permission.BUILD_ROSTER);
            assertThat(session.hasAllPermissions(required)).isTrue();
        }

        @Test
        @DisplayName("hasAllPermissions should return false when some missing")
        void hasAllPermissionsShouldReturnFalseWhenSomeMissing() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");

            Set<Permission> required = EnumSet.of(Permission.VIEW_ROSTER, Permission.CREATE_LEAGUE);
            assertThat(session.hasAllPermissions(required)).isFalse();
        }

        @Test
        @DisplayName("hasAnyPermission should return true when at least one exists")
        void hasAnyPermissionShouldReturnTrueWhenAtLeastOneExists() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");

            Set<Permission> required = EnumSet.of(Permission.CREATE_LEAGUE, Permission.VIEW_ROSTER);
            assertThat(session.hasAnyPermission(required)).isTrue();
        }

        @Test
        @DisplayName("hasAnyPermission should return false when none exist")
        void hasAnyPermissionShouldReturnFalseWhenNoneExist() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");

            Set<Permission> required = EnumSet.of(Permission.CREATE_LEAGUE, Permission.INVITE_ADMINS);
            assertThat(session.hasAnyPermission(required)).isFalse();
        }
    }

    @Nested
    @DisplayName("token validation tests")
    class TokenValidationTests {

        @Test
        @DisplayName("validateToken should return true for matching token")
        void validateTokenShouldReturnTrueForMatchingToken() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");

            assertThat(session.validateToken(session.getSessionToken())).isTrue();
        }

        @Test
        @DisplayName("validateToken should return false for non-matching token")
        void validateTokenShouldReturnFalseForNonMatchingToken() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");

            assertThat(session.validateToken("wrong-token")).isFalse();
        }

        @Test
        @DisplayName("validateRefreshToken should return true for matching token")
        void validateRefreshTokenShouldReturnTrueForMatchingToken() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");

            assertThat(session.validateRefreshToken(session.getRefreshToken())).isTrue();
        }
    }

    @Nested
    @DisplayName("utility tests")
    class UtilityTests {

        @Test
        @DisplayName("getRemainingSeconds should return positive for valid session")
        void getRemainingSecondsShouldReturnPositiveForValid() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");

            assertThat(session.getRemainingSeconds()).isPositive();
        }

        @Test
        @DisplayName("getRemainingSeconds should return zero for expired session")
        void getRemainingSecondsShouldReturnZeroForExpired() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");
            session.setExpiresAt(Instant.now().minus(1, ChronoUnit.HOURS));

            assertThat(session.getRemainingSeconds()).isZero();
        }

        @Test
        @DisplayName("isUserSession should return true for Google OAuth")
        void isUserSessionShouldReturnTrueForGoogleOAuth() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");
            assertThat(session.isUserSession()).isTrue();
            assertThat(session.isPATSession()).isFalse();
        }

        @Test
        @DisplayName("isPATSession should return true for PAT")
        void isPATSessionShouldReturnTrueForPAT() {
            AuthSession session = AuthSession.createPATSession(
                    patId, permissions, "10.0.0.1", "curl/7.64.1");
            assertThat(session.isPATSession()).isTrue();
            assertThat(session.isUserSession()).isFalse();
        }

        @Test
        @DisplayName("updateLastActivity should update timestamp")
        void updateLastActivityShouldUpdateTimestamp() {
            AuthSession session = AuthSession.createGoogleSession(
                    userId, googleId, permissions, "192.168.1.1", "Mozilla/5.0");
            Instant originalActivity = session.getLastActivityAt();

            // Small delay to ensure time difference
            try { Thread.sleep(10); } catch (InterruptedException ignored) {}

            session.updateLastActivity();

            assertThat(session.getLastActivityAt()).isAfterOrEqualTo(originalActivity);
        }
    }

    @Nested
    @DisplayName("AuthType tests")
    class AuthTypeTests {

        @Test
        @DisplayName("should have correct codes")
        void shouldHaveCorrectCodes() {
            assertThat(AuthSession.AuthType.GOOGLE_OAUTH.getCode()).isEqualTo("google_oauth");
            assertThat(AuthSession.AuthType.PAT.getCode()).isEqualTo("pat");
        }

        @Test
        @DisplayName("should resolve from code")
        void shouldResolveFromCode() {
            assertThat(AuthSession.AuthType.fromCode("google_oauth")).isEqualTo(AuthSession.AuthType.GOOGLE_OAUTH);
            assertThat(AuthSession.AuthType.fromCode("pat")).isEqualTo(AuthSession.AuthType.PAT);
        }

        @Test
        @DisplayName("should throw exception for unknown code")
        void shouldThrowExceptionForUnknownCode() {
            assertThatThrownBy(() -> AuthSession.AuthType.fromCode("unknown"))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Unknown auth type code");
        }
    }
}

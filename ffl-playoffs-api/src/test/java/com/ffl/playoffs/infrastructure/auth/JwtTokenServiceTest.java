package com.ffl.playoffs.infrastructure.auth;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Role;
import io.jsonwebtoken.Claims;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("JwtTokenService Tests")
class JwtTokenServiceTest {

    private JwtTokenService jwtTokenService;
    private User testUser;

    @BeforeEach
    void setUp() {
        jwtTokenService = new JwtTokenService(
                "test-access-secret-key-32-chars!",
                "test-refresh-secret-key-32chars!",
                900000L,  // 15 minutes
                604800000L,  // 7 days
                "ffl-playoffs-test"
        );

        testUser = new User("test@example.com", "Test User", "google123", Role.PLAYER);
        testUser.setId(UUID.randomUUID());
    }

    @Nested
    @DisplayName("Access Token Tests")
    class AccessTokenTests {

        @Test
        @DisplayName("should generate valid access token")
        void shouldGenerateValidAccessToken() {
            // Act
            String token = jwtTokenService.generateAccessToken(testUser);

            // Assert
            assertNotNull(token);
            assertFalse(token.isEmpty());
        }

        @Test
        @DisplayName("should validate and extract claims from access token")
        void shouldValidateAndExtractClaims() {
            // Arrange
            String token = jwtTokenService.generateAccessToken(testUser);

            // Act
            Claims claims = jwtTokenService.validateAccessToken(token);

            // Assert
            assertNotNull(claims);
            assertEquals(testUser.getId().toString(), claims.getSubject());
            assertEquals("test@example.com", claims.get("email", String.class));
            assertEquals("Test User", claims.get("name", String.class));
            assertEquals("PLAYER", claims.get("role", String.class));
            assertEquals("access", claims.get("type", String.class));
        }

        @Test
        @DisplayName("should return null for invalid access token")
        void shouldReturnNullForInvalidToken() {
            // Act
            Claims claims = jwtTokenService.validateAccessToken("invalid-token");

            // Assert
            assertNull(claims);
        }

        @Test
        @DisplayName("should return null when validating refresh token as access token")
        void shouldReturnNullWhenValidatingRefreshAsAccess() {
            // Arrange
            String refreshToken = jwtTokenService.generateRefreshToken(testUser);

            // Act
            Claims claims = jwtTokenService.validateAccessToken(refreshToken);

            // Assert
            assertNull(claims);
        }

        @Test
        @DisplayName("should extract user ID from claims")
        void shouldExtractUserId() {
            // Arrange
            String token = jwtTokenService.generateAccessToken(testUser);
            Claims claims = jwtTokenService.validateAccessToken(token);

            // Act
            UUID userId = jwtTokenService.extractUserId(claims);

            // Assert
            assertEquals(testUser.getId(), userId);
        }
    }

    @Nested
    @DisplayName("Refresh Token Tests")
    class RefreshTokenTests {

        @Test
        @DisplayName("should generate valid refresh token")
        void shouldGenerateValidRefreshToken() {
            // Act
            String token = jwtTokenService.generateRefreshToken(testUser);

            // Assert
            assertNotNull(token);
            assertFalse(token.isEmpty());
        }

        @Test
        @DisplayName("should validate and extract claims from refresh token")
        void shouldValidateAndExtractClaims() {
            // Arrange
            String token = jwtTokenService.generateRefreshToken(testUser);

            // Act
            Claims claims = jwtTokenService.validateRefreshToken(token);

            // Assert
            assertNotNull(claims);
            assertEquals(testUser.getId().toString(), claims.getSubject());
            assertEquals("refresh", claims.get("type", String.class));
            assertNotNull(claims.getId());  // Unique token ID for revocation
        }

        @Test
        @DisplayName("should return null for invalid refresh token")
        void shouldReturnNullForInvalidToken() {
            // Act
            Claims claims = jwtTokenService.validateRefreshToken("invalid-token");

            // Assert
            assertNull(claims);
        }

        @Test
        @DisplayName("should return null when validating access token as refresh token")
        void shouldReturnNullWhenValidatingAccessAsRefresh() {
            // Arrange
            String accessToken = jwtTokenService.generateAccessToken(testUser);

            // Act
            Claims claims = jwtTokenService.validateRefreshToken(accessToken);

            // Assert
            assertNull(claims);
        }

        @Test
        @DisplayName("should generate unique token IDs for each refresh token")
        void shouldGenerateUniqueTokenIds() {
            // Arrange
            String token1 = jwtTokenService.generateRefreshToken(testUser);
            String token2 = jwtTokenService.generateRefreshToken(testUser);

            Claims claims1 = jwtTokenService.validateRefreshToken(token1);
            Claims claims2 = jwtTokenService.validateRefreshToken(token2);

            // Assert
            assertNotEquals(claims1.getId(), claims2.getId());
        }
    }

    @Nested
    @DisplayName("Token Expiration Tests")
    class TokenExpirationTests {

        @Test
        @DisplayName("should return correct access token expiration seconds")
        void shouldReturnCorrectAccessExpiration() {
            // Act
            long expirationSeconds = jwtTokenService.getAccessTokenExpirationSeconds();

            // Assert
            assertEquals(900L, expirationSeconds);  // 15 minutes = 900 seconds
        }

        @Test
        @DisplayName("should return correct refresh token expiration seconds")
        void shouldReturnCorrectRefreshExpiration() {
            // Act
            long expirationSeconds = jwtTokenService.getRefreshTokenExpirationSeconds();

            // Assert
            assertEquals(604800L, expirationSeconds);  // 7 days = 604800 seconds
        }
    }

    @Nested
    @DisplayName("Secret Padding Tests")
    class SecretPaddingTests {

        @Test
        @DisplayName("should work with short secret by padding")
        void shouldWorkWithShortSecret() {
            // Arrange
            JwtTokenService serviceWithShortSecret = new JwtTokenService(
                    "short",  // Less than 32 chars
                    "short",
                    900000L,
                    604800000L,
                    "test"
            );

            // Act
            String token = serviceWithShortSecret.generateAccessToken(testUser);
            Claims claims = serviceWithShortSecret.validateAccessToken(token);

            // Assert
            assertNotNull(token);
            assertNotNull(claims);
            assertEquals(testUser.getId().toString(), claims.getSubject());
        }

        @Test
        @DisplayName("should work with long secret without modification")
        void shouldWorkWithLongSecret() {
            // Arrange
            JwtTokenService serviceWithLongSecret = new JwtTokenService(
                    "this-is-a-very-long-secret-key-that-is-more-than-32-characters",
                    "this-is-a-very-long-secret-key-that-is-more-than-32-characters",
                    900000L,
                    604800000L,
                    "test"
            );

            // Act
            String token = serviceWithLongSecret.generateAccessToken(testUser);
            Claims claims = serviceWithLongSecret.validateAccessToken(token);

            // Assert
            assertNotNull(token);
            assertNotNull(claims);
        }
    }

    @Nested
    @DisplayName("Different User Roles Tests")
    class UserRoleTests {

        @Test
        @DisplayName("should include ADMIN role in token")
        void shouldIncludeAdminRole() {
            // Arrange
            User adminUser = new User("admin@example.com", "Admin User", "google456", Role.ADMIN);
            adminUser.setId(UUID.randomUUID());

            // Act
            String token = jwtTokenService.generateAccessToken(adminUser);
            Claims claims = jwtTokenService.validateAccessToken(token);

            // Assert
            assertEquals("ADMIN", claims.get("role", String.class));
        }

        @Test
        @DisplayName("should include SUPER_ADMIN role in token")
        void shouldIncludeSuperAdminRole() {
            // Arrange
            User superAdminUser = new User("superadmin@example.com", "Super Admin", "google789", Role.SUPER_ADMIN);
            superAdminUser.setId(UUID.randomUUID());

            // Act
            String token = jwtTokenService.generateAccessToken(superAdminUser);
            Claims claims = jwtTokenService.validateAccessToken(token);

            // Assert
            assertEquals("SUPER_ADMIN", claims.get("role", String.class));
        }
    }
}

package com.ffl.playoffs.infrastructure.adapter.rest;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ffl.playoffs.application.dto.auth.GoogleLoginRequest;
import com.ffl.playoffs.application.dto.auth.RefreshTokenRequest;
import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.PATScope;
import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.UserRepository;
import com.ffl.playoffs.infrastructure.auth.AuthenticationResult;
import com.ffl.playoffs.infrastructure.auth.JwtTokenService;
import com.ffl.playoffs.infrastructure.auth.TokenValidator;
import io.jsonwebtoken.Claims;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(AuthController.class)
@DisplayName("AuthController Tests")
class AuthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private TokenValidator tokenValidator;

    @MockBean
    private JwtTokenService jwtTokenService;

    @MockBean
    private UserRepository userRepository;

    private User testUser;
    private UUID testUserId;

    @BeforeEach
    void setUp() {
        testUserId = UUID.randomUUID();
        testUser = new User("test@example.com", "Test User", "google123", Role.PLAYER);
        testUser.setId(testUserId);
        testUser.setCreatedAt(LocalDateTime.now());
        testUser.setActive(true);
    }

    private Claims createMockClaims(String subject, String email, String role) {
        Claims claims = mock(Claims.class);
        when(claims.getSubject()).thenReturn(subject);
        when(claims.get("email", String.class)).thenReturn(email);
        when(claims.get("role", String.class)).thenReturn(role);
        return claims;
    }

    @Nested
    @DisplayName("POST /api/v1/auth/google/login")
    class GoogleLoginTests {

        @Test
        @DisplayName("should return tokens on successful Google OAuth login")
        @WithMockUser
        void shouldReturnTokensOnSuccessfulLogin() throws Exception {
            // Arrange
            GoogleLoginRequest request = new GoogleLoginRequest("valid-google-token");
            when(tokenValidator.validateGoogleJWT("valid-google-token"))
                    .thenReturn(AuthenticationResult.success(testUser));
            when(jwtTokenService.generateAccessToken(any(User.class))).thenReturn("access-token-123");
            when(jwtTokenService.generateRefreshToken(any(User.class))).thenReturn("refresh-token-123");
            when(jwtTokenService.getAccessTokenExpirationSeconds()).thenReturn(900L);

            // Act & Assert
            mockMvc.perform(post("/api/v1/auth/google/login")
                            .with(csrf())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(request)))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.accessToken").value("access-token-123"))
                    .andExpect(jsonPath("$.refreshToken").value("refresh-token-123"))
                    .andExpect(jsonPath("$.tokenType").value("Bearer"))
                    .andExpect(jsonPath("$.expiresIn").value(900));
        }

        @Test
        @DisplayName("should return 401 on invalid Google token")
        @WithMockUser
        void shouldReturn401OnInvalidToken() throws Exception {
            // Arrange
            GoogleLoginRequest request = new GoogleLoginRequest("invalid-token");
            when(tokenValidator.validateGoogleJWT("invalid-token"))
                    .thenReturn(AuthenticationResult.failure("Invalid token"));

            // Act & Assert
            mockMvc.perform(post("/api/v1/auth/google/login")
                            .with(csrf())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(request)))
                    .andExpect(status().isUnauthorized());
        }

        @Test
        @DisplayName("should return 400 on missing idToken")
        @WithMockUser
        void shouldReturn400OnMissingIdToken() throws Exception {
            // Arrange
            GoogleLoginRequest request = new GoogleLoginRequest();

            // Act & Assert
            mockMvc.perform(post("/api/v1/auth/google/login")
                            .with(csrf())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(request)))
                    .andExpect(status().isBadRequest());
        }
    }

    @Nested
    @DisplayName("GET /api/v1/auth/validate-token")
    class ValidateTokenTests {

        @Test
        @DisplayName("should validate JWT access token successfully")
        @WithMockUser
        void shouldValidateJwtTokenSuccessfully() throws Exception {
            // Arrange
            Claims claims = createMockClaims(testUserId.toString(), "test@example.com", "PLAYER");

            when(jwtTokenService.validateAccessToken("valid-jwt-token")).thenReturn(claims);
            when(jwtTokenService.extractUserId(claims)).thenReturn(testUserId);

            // Act & Assert
            mockMvc.perform(get("/api/v1/auth/validate-token")
                            .header("Authorization", "Bearer valid-jwt-token"))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.valid").value(true))
                    .andExpect(jsonPath("$.userId").value(testUserId.toString()))
                    .andExpect(jsonPath("$.email").value("test@example.com"))
                    .andExpect(jsonPath("$.role").value("PLAYER"));
        }

        @Test
        @DisplayName("should validate PAT token successfully")
        @WithMockUser
        void shouldValidatePATTokenSuccessfully() throws Exception {
            // Arrange
            UUID patUserId = UUID.randomUUID();
            PersonalAccessToken pat = new PersonalAccessToken(
                    "Test PAT",
                    "test_abc123",
                    "hashedToken",
                    PATScope.READ_ONLY,
                    LocalDateTime.now().plusDays(30),
                    patUserId.toString()
            );

            when(tokenValidator.validatePAT("pat_test_abc123"))
                    .thenReturn(AuthenticationResult.success(pat));

            // Act & Assert
            mockMvc.perform(get("/api/v1/auth/validate-token")
                            .header("Authorization", "Bearer pat_test_abc123"))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.valid").value(true))
                    .andExpect(jsonPath("$.role").value("PAT"))
                    .andExpect(jsonPath("$.userId").value(patUserId.toString()));
        }

        @Test
        @DisplayName("should return invalid on expired token")
        @WithMockUser
        void shouldReturnInvalidOnExpiredToken() throws Exception {
            // Arrange
            when(jwtTokenService.validateAccessToken("expired-token")).thenReturn(null);

            // Act & Assert
            mockMvc.perform(get("/api/v1/auth/validate-token")
                            .header("Authorization", "Bearer expired-token"))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.valid").value(false))
                    .andExpect(jsonPath("$.error").value("Invalid or expired token"));
        }

        @Test
        @DisplayName("should return invalid on missing authorization header")
        @WithMockUser
        void shouldReturnInvalidOnMissingHeader() throws Exception {
            // Act & Assert
            mockMvc.perform(get("/api/v1/auth/validate-token"))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.valid").value(false))
                    .andExpect(jsonPath("$.error").value("No authorization header"));
        }
    }

    @Nested
    @DisplayName("POST /api/v1/auth/refresh")
    class RefreshTokenTests {

        @Test
        @DisplayName("should return new tokens on valid refresh token")
        @WithMockUser
        void shouldReturnNewTokensOnValidRefreshToken() throws Exception {
            // Arrange
            RefreshTokenRequest request = new RefreshTokenRequest("valid-refresh-token");
            Claims claims = createMockClaims(testUserId.toString(), null, null);

            when(jwtTokenService.validateRefreshToken("valid-refresh-token")).thenReturn(claims);
            when(jwtTokenService.extractUserId(claims)).thenReturn(testUserId);
            when(userRepository.findById(testUserId)).thenReturn(Optional.of(testUser));
            when(jwtTokenService.generateAccessToken(any(User.class))).thenReturn("new-access-token");
            when(jwtTokenService.generateRefreshToken(any(User.class))).thenReturn("new-refresh-token");
            when(jwtTokenService.getAccessTokenExpirationSeconds()).thenReturn(900L);

            // Act & Assert
            mockMvc.perform(post("/api/v1/auth/refresh")
                            .with(csrf())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(request)))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.accessToken").value("new-access-token"))
                    .andExpect(jsonPath("$.refreshToken").value("new-refresh-token"))
                    .andExpect(jsonPath("$.tokenType").value("Bearer"))
                    .andExpect(jsonPath("$.expiresIn").value(900));
        }

        @Test
        @DisplayName("should return 401 on invalid refresh token")
        @WithMockUser
        void shouldReturn401OnInvalidRefreshToken() throws Exception {
            // Arrange
            RefreshTokenRequest request = new RefreshTokenRequest("invalid-refresh-token");
            when(jwtTokenService.validateRefreshToken("invalid-refresh-token")).thenReturn(null);

            // Act & Assert
            mockMvc.perform(post("/api/v1/auth/refresh")
                            .with(csrf())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(request)))
                    .andExpect(status().isUnauthorized());
        }

        @Test
        @DisplayName("should return 401 when user not found")
        @WithMockUser
        void shouldReturn401WhenUserNotFound() throws Exception {
            // Arrange
            RefreshTokenRequest request = new RefreshTokenRequest("valid-refresh-token");
            Claims claims = createMockClaims(testUserId.toString(), null, null);

            when(jwtTokenService.validateRefreshToken("valid-refresh-token")).thenReturn(claims);
            when(jwtTokenService.extractUserId(claims)).thenReturn(testUserId);
            when(userRepository.findById(testUserId)).thenReturn(Optional.empty());

            // Act & Assert
            mockMvc.perform(post("/api/v1/auth/refresh")
                            .with(csrf())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(request)))
                    .andExpect(status().isUnauthorized());
        }

        @Test
        @DisplayName("should return 401 when user is deactivated")
        @WithMockUser
        void shouldReturn401WhenUserDeactivated() throws Exception {
            // Arrange
            testUser.setActive(false);
            RefreshTokenRequest request = new RefreshTokenRequest("valid-refresh-token");
            Claims claims = createMockClaims(testUserId.toString(), null, null);

            when(jwtTokenService.validateRefreshToken("valid-refresh-token")).thenReturn(claims);
            when(jwtTokenService.extractUserId(claims)).thenReturn(testUserId);
            when(userRepository.findById(testUserId)).thenReturn(Optional.of(testUser));

            // Act & Assert
            mockMvc.perform(post("/api/v1/auth/refresh")
                            .with(csrf())
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(request)))
                    .andExpect(status().isUnauthorized());
        }
    }

    @Nested
    @DisplayName("GET /api/v1/auth/me")
    class GetCurrentUserTests {

        @Test
        @DisplayName("should return user info on valid access token")
        @WithMockUser
        void shouldReturnUserInfoOnValidToken() throws Exception {
            // Arrange
            Claims claims = createMockClaims(testUserId.toString(), null, null);

            when(jwtTokenService.validateAccessToken("valid-access-token")).thenReturn(claims);
            when(jwtTokenService.extractUserId(claims)).thenReturn(testUserId);
            when(userRepository.findById(testUserId)).thenReturn(Optional.of(testUser));

            // Act & Assert
            mockMvc.perform(get("/api/v1/auth/me")
                            .header("Authorization", "Bearer valid-access-token"))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.id").value(testUserId.toString()))
                    .andExpect(jsonPath("$.email").value("test@example.com"))
                    .andExpect(jsonPath("$.name").value("Test User"))
                    .andExpect(jsonPath("$.role").value("PLAYER"))
                    .andExpect(jsonPath("$.active").value(true));
        }

        @Test
        @DisplayName("should return 401 on missing authorization header")
        @WithMockUser
        void shouldReturn401OnMissingHeader() throws Exception {
            // Act & Assert
            mockMvc.perform(get("/api/v1/auth/me"))
                    .andExpect(status().isUnauthorized());
        }

        @Test
        @DisplayName("should return 401 on invalid access token")
        @WithMockUser
        void shouldReturn401OnInvalidToken() throws Exception {
            // Arrange
            when(jwtTokenService.validateAccessToken("invalid-token")).thenReturn(null);

            // Act & Assert
            mockMvc.perform(get("/api/v1/auth/me")
                            .header("Authorization", "Bearer invalid-token"))
                    .andExpect(status().isUnauthorized());
        }

        @Test
        @DisplayName("should return 401 when user not found")
        @WithMockUser
        void shouldReturn401WhenUserNotFound() throws Exception {
            // Arrange
            Claims claims = createMockClaims(testUserId.toString(), null, null);

            when(jwtTokenService.validateAccessToken("valid-token")).thenReturn(claims);
            when(jwtTokenService.extractUserId(claims)).thenReturn(testUserId);
            when(userRepository.findById(testUserId)).thenReturn(Optional.empty());

            // Act & Assert
            mockMvc.perform(get("/api/v1/auth/me")
                            .header("Authorization", "Bearer valid-token"))
                    .andExpect(status().isUnauthorized());
        }
    }
}

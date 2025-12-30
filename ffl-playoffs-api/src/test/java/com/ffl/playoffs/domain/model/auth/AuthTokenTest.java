package com.ffl.playoffs.domain.model.auth;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("AuthToken Value Object Tests")
class AuthTokenTest {

    @Test
    @DisplayName("should detect PAT token type")
    void shouldDetectPATTokenType() {
        AuthToken token = AuthToken.of("pat_abc123_secret456");

        assertThat(token.isPAT()).isTrue();
        assertThat(token.isGoogleOAuth()).isFalse();
        assertThat(token.getType()).isEqualTo(AuthenticationType.PAT);
    }

    @Test
    @DisplayName("should detect Google OAuth token type")
    void shouldDetectGoogleOAuthTokenType() {
        AuthToken token = AuthToken.of("eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.test");

        assertThat(token.isGoogleOAuth()).isTrue();
        assertThat(token.isPAT()).isFalse();
        assertThat(token.getType()).isEqualTo(AuthenticationType.GOOGLE_OAUTH);
    }

    @Test
    @DisplayName("should strip Bearer prefix")
    void shouldStripBearerPrefix() {
        AuthToken token = AuthToken.of("Bearer pat_abc123_secret456");

        assertThat(token.getRawToken()).isEqualTo("pat_abc123_secret456");
        assertThat(token.isPAT()).isTrue();
    }

    @Test
    @DisplayName("should create PAT token explicitly")
    void shouldCreatePATTokenExplicitly() {
        AuthToken token = AuthToken.pat("pat_test_secret");

        assertThat(token.isPAT()).isTrue();
        assertThat(token.getRawToken()).isEqualTo("pat_test_secret");
    }

    @Test
    @DisplayName("should create Google JWT token explicitly")
    void shouldCreateGoogleJwtTokenExplicitly() {
        AuthToken token = AuthToken.googleJwt("eyJhbGciOiJSUzI1NiJ9.test");

        assertThat(token.isGoogleOAuth()).isTrue();
        assertThat(token.getRawToken()).isEqualTo("eyJhbGciOiJSUzI1NiJ9.test");
    }

    @Test
    @DisplayName("should throw for null token")
    void shouldThrowForNullToken() {
        assertThatThrownBy(() -> AuthToken.of(null))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("null or blank");
    }

    @Test
    @DisplayName("should throw for blank token")
    void shouldThrowForBlankToken() {
        assertThatThrownBy(() -> AuthToken.of("   "))
                .isInstanceOf(IllegalArgumentException.class);
    }

    @Test
    @DisplayName("should throw for invalid PAT prefix")
    void shouldThrowForInvalidPATPrefix() {
        assertThatThrownBy(() -> AuthToken.pat("invalid_token"))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("pat_");
    }

    @Test
    @DisplayName("should mask token for logging")
    void shouldMaskTokenForLogging() {
        AuthToken token = AuthToken.of("pat_abc123_secretvalue");

        String masked = token.getMaskedToken();

        assertThat(masked).startsWith("pat_");
        assertThat(masked).contains("...");
        assertThat(masked).doesNotContain("secretvalue");
    }

    @Test
    @DisplayName("should implement equals correctly")
    void shouldImplementEqualsCorrectly() {
        AuthToken token1 = AuthToken.of("pat_abc123_secret");
        AuthToken token2 = AuthToken.of("pat_abc123_secret");
        AuthToken token3 = AuthToken.of("pat_different_token");

        assertThat(token1).isEqualTo(token2);
        assertThat(token1).isNotEqualTo(token3);
    }
}

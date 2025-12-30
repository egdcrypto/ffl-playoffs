package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.model.auth.AuthenticationType;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("AuthSession Aggregate Tests")
class AuthSessionTest {

    @Test
    @DisplayName("should create session with required fields")
    void shouldCreateSessionWithRequiredFields() {
        UUID principalId = UUID.randomUUID();
        AuthSession session = new AuthSession(principalId, AuthenticationType.GOOGLE_OAUTH, "test@example.com");

        assertThat(session.getId()).isNotNull();
        assertThat(session.getPrincipalId()).isEqualTo(principalId);
        assertThat(session.getAuthenticationType()).isEqualTo(AuthenticationType.GOOGLE_OAUTH);
        assertThat(session.getIdentifier()).isEqualTo("test@example.com");
        assertThat(session.isActive()).isTrue();
        assertThat(session.getCreatedAt()).isNotNull();
    }

    @Test
    @DisplayName("should create session for user")
    void shouldCreateSessionForUser() {
        User user = new User("test@example.com", "Test User", "google123", Role.PLAYER);

        AuthSession session = AuthSession.forUser(user, "192.168.1.1", "Mozilla/5.0");

        assertThat(session.getPrincipalId()).isEqualTo(user.getId());
        assertThat(session.getAuthenticationType()).isEqualTo(AuthenticationType.GOOGLE_OAUTH);
        assertThat(session.getIdentifier()).isEqualTo("test@example.com");
        assertThat(session.getIpAddress()).isEqualTo("192.168.1.1");
        assertThat(session.getUserAgent()).isEqualTo("Mozilla/5.0");
        assertThat(session.getExpiresAt()).isNotNull();
    }

    @Test
    @DisplayName("should create session for PAT")
    void shouldCreateSessionForPAT() {
        UUID patId = UUID.randomUUID();

        AuthSession session = AuthSession.forPAT(patId, "API Token", "10.0.0.1", "curl/7.68.0");

        assertThat(session.getPrincipalId()).isEqualTo(patId);
        assertThat(session.getAuthenticationType()).isEqualTo(AuthenticationType.PAT);
        assertThat(session.getIdentifier()).isEqualTo("API Token");
        assertThat(session.getExpiresAt()).isNull(); // PAT sessions don't expire
    }

    @Test
    @DisplayName("should check if session is valid")
    void shouldCheckIfSessionIsValid() {
        AuthSession session = new AuthSession(UUID.randomUUID(), AuthenticationType.GOOGLE_OAUTH, "test");
        session.setExpiresAt(LocalDateTime.now().plusHours(1));

        assertThat(session.isValid()).isTrue();
    }

    @Test
    @DisplayName("should detect expired session")
    void shouldDetectExpiredSession() {
        AuthSession session = new AuthSession(UUID.randomUUID(), AuthenticationType.GOOGLE_OAUTH, "test");
        session.setExpiresAt(LocalDateTime.now().minusHours(1));

        assertThat(session.isValid()).isFalse();
        assertThat(session.isExpired()).isTrue();
    }

    @Test
    @DisplayName("should terminate session")
    void shouldTerminateSession() {
        AuthSession session = new AuthSession(UUID.randomUUID(), AuthenticationType.GOOGLE_OAUTH, "test");

        session.terminate("User logout");

        assertThat(session.isActive()).isFalse();
        assertThat(session.isValid()).isFalse();
        assertThat(session.getTerminationReason()).isEqualTo("User logout");
        assertThat(session.getTerminatedAt()).isNotNull();
    }

    @Test
    @DisplayName("should throw when terminating already terminated session")
    void shouldThrowWhenTerminatingAlreadyTerminatedSession() {
        AuthSession session = new AuthSession(UUID.randomUUID(), AuthenticationType.GOOGLE_OAUTH, "test");
        session.terminate("First termination");

        assertThatThrownBy(() -> session.terminate("Second termination"))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("already terminated");
    }

    @Test
    @DisplayName("should update activity")
    void shouldUpdateActivity() {
        AuthSession session = new AuthSession(UUID.randomUUID(), AuthenticationType.GOOGLE_OAUTH, "test");
        LocalDateTime before = session.getLastActivityAt();

        // Small delay to ensure time difference
        try { Thread.sleep(10); } catch (InterruptedException e) { }

        session.updateActivity();

        assertThat(session.getLastActivityAt()).isAfterOrEqualTo(before);
    }

    @Test
    @DisplayName("should throw when updating activity on inactive session")
    void shouldThrowWhenUpdatingActivityOnInactiveSession() {
        AuthSession session = new AuthSession(UUID.randomUUID(), AuthenticationType.GOOGLE_OAUTH, "test");
        session.terminate("Terminated");

        assertThatThrownBy(() -> session.updateActivity())
                .isInstanceOf(IllegalStateException.class);
    }

    @Test
    @DisplayName("should extend session expiration")
    void shouldExtendSessionExpiration() {
        AuthSession session = new AuthSession(UUID.randomUUID(), AuthenticationType.GOOGLE_OAUTH, "test");
        session.setExpiresAt(LocalDateTime.now().plusHours(1));
        LocalDateTime originalExpiry = session.getExpiresAt();

        session.extend(24);

        assertThat(session.getExpiresAt()).isAfter(originalExpiry);
    }

    @Test
    @DisplayName("should detect idle session")
    void shouldDetectIdleSession() {
        AuthSession session = new AuthSession(UUID.randomUUID(), AuthenticationType.GOOGLE_OAUTH, "test");
        session.setLastActivityAt(LocalDateTime.now().minusMinutes(60));

        assertThat(session.isIdle(30)).isTrue();
        assertThat(session.isIdle(120)).isFalse();
    }

    @Test
    @DisplayName("should calculate session duration")
    void shouldCalculateSessionDuration() {
        AuthSession session = new AuthSession(UUID.randomUUID(), AuthenticationType.GOOGLE_OAUTH, "test");
        session.setCreatedAt(LocalDateTime.now().minusMinutes(30));

        long duration = session.getDurationMinutes();

        assertThat(duration).isBetween(29L, 31L);
    }

    @Test
    @DisplayName("should implement equals based on ID")
    void shouldImplementEqualsBasedOnId() {
        UUID sharedId = UUID.randomUUID();

        AuthSession session1 = new AuthSession(UUID.randomUUID(), AuthenticationType.GOOGLE_OAUTH, "test1");
        AuthSession session2 = new AuthSession(UUID.randomUUID(), AuthenticationType.GOOGLE_OAUTH, "test2");

        session1.setId(sharedId);
        session2.setId(sharedId);

        assertThat(session1).isEqualTo(session2);
    }
}

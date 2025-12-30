package com.ffl.playoffs.domain.model.auth;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.PATScope;
import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.model.Role;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;

import static org.assertj.core.api.Assertions.*;

@DisplayName("AuthenticationContext Value Object Tests")
class AuthenticationContextTest {

    @Test
    @DisplayName("should create context for user")
    void shouldCreateContextForUser() {
        User user = new User("test@example.com", "Test User", "google123", Role.ADMIN);

        AuthenticationContext context = AuthenticationContext.forUser(user);

        assertThat(context.isAuthenticated()).isTrue();
        assertThat(context.isUserAuth()).isTrue();
        assertThat(context.isPATAuth()).isFalse();
        assertThat(context.getUser()).isPresent();
        assertThat(context.getAuthenticationType()).isEqualTo(AuthenticationType.GOOGLE_OAUTH);
        assertThat(context.getIdentifier()).isEqualTo("test@example.com");
    }

    @Test
    @DisplayName("should create context for PAT")
    void shouldCreateContextForPAT() {
        PersonalAccessToken pat = new PersonalAccessToken(
                "API Token",
                "abc123",
                "hashedValue",
                PATScope.ADMIN,
                LocalDateTime.now().plusDays(30),
                "SYSTEM"
        );

        AuthenticationContext context = AuthenticationContext.forPAT(pat);

        assertThat(context.isAuthenticated()).isTrue();
        assertThat(context.isPATAuth()).isTrue();
        assertThat(context.isUserAuth()).isFalse();
        assertThat(context.getPat()).isPresent();
        assertThat(context.getAuthenticationType()).isEqualTo(AuthenticationType.PAT);
        assertThat(context.getIdentifier()).isEqualTo("API Token");
    }

    @Test
    @DisplayName("should create anonymous context")
    void shouldCreateAnonymousContext() {
        AuthenticationContext context = AuthenticationContext.anonymous();

        assertThat(context.isAuthenticated()).isFalse();
        assertThat(context.isUserAuth()).isFalse();
        assertThat(context.isPATAuth()).isFalse();
        assertThat(context.getAuthenticationType()).isEqualTo(AuthenticationType.ANONYMOUS);
    }

    @Test
    @DisplayName("should create failure context")
    void shouldCreateFailureContext() {
        AuthenticationContext context = AuthenticationContext.failure("Invalid token");

        assertThat(context.isAuthenticated()).isFalse();
        assertThat(context.getErrorMessage()).isPresent();
        assertThat(context.getErrorMessage().get()).isEqualTo("Invalid token");
    }

    @Test
    @DisplayName("should check user role")
    void shouldCheckUserRole() {
        User admin = new User("admin@example.com", "Admin", "google456", Role.ADMIN);
        AuthenticationContext context = AuthenticationContext.forUser(admin);

        assertThat(context.hasRole(Role.ADMIN)).isTrue();
        assertThat(context.hasRole(Role.PLAYER)).isTrue();
        assertThat(context.hasRole(Role.SUPER_ADMIN)).isFalse();
        assertThat(context.isAdmin()).isTrue();
        assertThat(context.isSuperAdmin()).isFalse();
    }

    @Test
    @DisplayName("should check super admin role")
    void shouldCheckSuperAdminRole() {
        User superAdmin = new User("super@example.com", "Super", "google789", Role.SUPER_ADMIN);
        AuthenticationContext context = AuthenticationContext.forUser(superAdmin);

        assertThat(context.hasRole(Role.SUPER_ADMIN)).isTrue();
        assertThat(context.hasRole(Role.ADMIN)).isTrue();
        assertThat(context.hasRole(Role.PLAYER)).isTrue();
        assertThat(context.isSuperAdmin()).isTrue();
        assertThat(context.isAdmin()).isTrue();
    }

    @Test
    @DisplayName("should check PAT scope")
    void shouldCheckPATScope() {
        PersonalAccessToken pat = new PersonalAccessToken(
                "Write Token",
                "abc123",
                "hashedValue",
                PATScope.WRITE,
                LocalDateTime.now().plusDays(30),
                "SYSTEM"
        );

        AuthenticationContext context = AuthenticationContext.forPAT(pat);

        assertThat(context.hasScope(PATScope.WRITE)).isTrue();
        assertThat(context.hasScope(PATScope.READ_ONLY)).isTrue();
        assertThat(context.hasScope(PATScope.ADMIN)).isFalse();
    }

    @Test
    @DisplayName("should get principal ID for user")
    void shouldGetPrincipalIdForUser() {
        User user = new User("test@example.com", "Test", "google123", Role.PLAYER);
        AuthenticationContext context = AuthenticationContext.forUser(user);

        assertThat(context.getPrincipalId()).isPresent();
        assertThat(context.getPrincipalId().get()).isEqualTo(user.getId());
    }

    @Test
    @DisplayName("should get principal ID for PAT")
    void shouldGetPrincipalIdForPAT() {
        PersonalAccessToken pat = new PersonalAccessToken(
                "Token",
                "abc",
                "hash",
                PATScope.READ_ONLY,
                null,
                "SYSTEM"
        );
        AuthenticationContext context = AuthenticationContext.forPAT(pat);

        assertThat(context.getPrincipalId()).isPresent();
        assertThat(context.getPrincipalId().get()).isEqualTo(pat.getId());
    }
}

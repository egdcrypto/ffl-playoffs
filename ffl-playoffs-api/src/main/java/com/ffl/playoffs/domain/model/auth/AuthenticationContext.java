package com.ffl.playoffs.domain.model.auth;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.PATScope;
import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.model.Role;

import java.util.Objects;
import java.util.Optional;
import java.util.UUID;

/**
 * Value object representing the current authentication context.
 * Contains either user context (Google OAuth) or PAT context.
 * Immutable.
 */
public final class AuthenticationContext {

    private final boolean authenticated;
    private final AuthenticationType authenticationType;
    private final User user;
    private final PersonalAccessToken pat;
    private final String errorMessage;
    private final String identifier;

    private AuthenticationContext(
            boolean authenticated,
            AuthenticationType authenticationType,
            User user,
            PersonalAccessToken pat,
            String errorMessage,
            String identifier) {
        this.authenticated = authenticated;
        this.authenticationType = authenticationType;
        this.user = user;
        this.pat = pat;
        this.errorMessage = errorMessage;
        this.identifier = identifier;
    }

    /**
     * Create a successful user authentication context
     */
    public static AuthenticationContext forUser(User user) {
        Objects.requireNonNull(user, "User cannot be null");
        return new AuthenticationContext(
                true,
                AuthenticationType.GOOGLE_OAUTH,
                user,
                null,
                null,
                user.getEmail()
        );
    }

    /**
     * Create a successful PAT authentication context
     */
    public static AuthenticationContext forPAT(PersonalAccessToken pat) {
        Objects.requireNonNull(pat, "PAT cannot be null");
        return new AuthenticationContext(
                true,
                AuthenticationType.PAT,
                null,
                pat,
                null,
                pat.getName()
        );
    }

    /**
     * Create an anonymous (unauthenticated) context
     */
    public static AuthenticationContext anonymous() {
        return new AuthenticationContext(
                false,
                AuthenticationType.ANONYMOUS,
                null,
                null,
                null,
                "anonymous"
        );
    }

    /**
     * Create a failed authentication context
     */
    public static AuthenticationContext failure(String errorMessage) {
        return new AuthenticationContext(
                false,
                AuthenticationType.ANONYMOUS,
                null,
                null,
                errorMessage,
                null
        );
    }

    public boolean isAuthenticated() {
        return authenticated;
    }

    public AuthenticationType getAuthenticationType() {
        return authenticationType;
    }

    public Optional<User> getUser() {
        return Optional.ofNullable(user);
    }

    public Optional<PersonalAccessToken> getPat() {
        return Optional.ofNullable(pat);
    }

    public Optional<String> getErrorMessage() {
        return Optional.ofNullable(errorMessage);
    }

    public String getIdentifier() {
        return identifier;
    }

    public boolean isUserAuth() {
        return user != null;
    }

    public boolean isPATAuth() {
        return pat != null;
    }

    /**
     * Get the principal ID (user ID or PAT ID)
     */
    public Optional<UUID> getPrincipalId() {
        if (user != null) {
            return Optional.of(user.getId());
        }
        if (pat != null) {
            return Optional.of(pat.getId());
        }
        return Optional.empty();
    }

    /**
     * Check if the context has the required role
     */
    public boolean hasRole(Role requiredRole) {
        if (user != null) {
            return user.hasRole(requiredRole);
        }
        return false;
    }

    /**
     * Check if the context has the required PAT scope
     */
    public boolean hasScope(PATScope requiredScope) {
        if (pat != null) {
            return pat.hasScope(requiredScope);
        }
        return false;
    }

    /**
     * Check if the context is a super admin
     */
    public boolean isSuperAdmin() {
        return user != null && user.isSuperAdmin();
    }

    /**
     * Check if the context is an admin (includes super admin)
     */
    public boolean isAdmin() {
        return user != null && user.isAdmin();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AuthenticationContext that = (AuthenticationContext) o;
        return authenticated == that.authenticated &&
                authenticationType == that.authenticationType &&
                Objects.equals(identifier, that.identifier);
    }

    @Override
    public int hashCode() {
        return Objects.hash(authenticated, authenticationType, identifier);
    }

    @Override
    public String toString() {
        return "AuthenticationContext{" +
                "authenticated=" + authenticated +
                ", type=" + authenticationType +
                ", identifier='" + identifier + '\'' +
                '}';
    }
}

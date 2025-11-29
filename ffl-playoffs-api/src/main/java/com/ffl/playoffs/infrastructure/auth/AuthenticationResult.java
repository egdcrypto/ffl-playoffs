package com.ffl.playoffs.infrastructure.auth;

import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.aggregate.User;

/**
 * Result of token authentication
 * Contains either user context (Google OAuth) or PAT context
 */
public class AuthenticationResult {
    private final boolean authenticated;
    private final User user;
    private final PersonalAccessToken pat;
    private final String errorMessage;
    private final String identifier;

    private AuthenticationResult(boolean authenticated, User user, PersonalAccessToken pat,
                                 String errorMessage, String identifier) {
        this.authenticated = authenticated;
        this.user = user;
        this.pat = pat;
        this.errorMessage = errorMessage;
        this.identifier = identifier;
    }

    /**
     * Creates a successful user authentication result
     */
    public static AuthenticationResult success(User user) {
        return new AuthenticationResult(true, user, null, null, user.getEmail());
    }

    /**
     * Creates a successful PAT authentication result
     */
    public static AuthenticationResult success(PersonalAccessToken pat) {
        return new AuthenticationResult(true, null, pat, null, pat.getName());
    }

    /**
     * Creates a failed authentication result
     */
    public static AuthenticationResult failure(String errorMessage) {
        return new AuthenticationResult(false, null, null, errorMessage, null);
    }

    public boolean isAuthenticated() {
        return authenticated;
    }

    public User getUser() {
        return user;
    }

    public PersonalAccessToken getPat() {
        return pat;
    }

    public String getErrorMessage() {
        return errorMessage;
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
}

package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.AuthenticationContext;
import com.ffl.playoffs.domain.service.ResourceOwnershipValidator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.UUID;

/**
 * Use case for validating resource ownership before allowing access.
 * This is called from the API layer to validate ownership after role-based
 * access has been verified.
 */
public class ValidateResourceOwnershipUseCase {

    private static final Logger log = LoggerFactory.getLogger(ValidateResourceOwnershipUseCase.class);

    private final ResourceOwnershipValidator ownershipValidator;

    public ValidateResourceOwnershipUseCase(ResourceOwnershipValidator ownershipValidator) {
        this.ownershipValidator = ownershipValidator;
    }

    /**
     * Validates that the authenticated context has access to the specified league.
     *
     * @param ctx the authentication context
     * @param leagueId the league ID to check
     * @throws ResourceAccessDeniedException if access is denied
     */
    public void validateLeagueAccess(AuthenticationContext ctx, UUID leagueId) {
        if (!ownershipValidator.canAccessLeague(ctx, leagueId)) {
            log.warn("Access denied: {} cannot access league {}", getContextDescription(ctx), leagueId);
            throw new ResourceAccessDeniedException("LEAGUE_ACCESS_DENIED",
                    "You do not have access to this league");
        }
    }

    /**
     * Validates that the authenticated context can modify the specified roster.
     *
     * @param ctx the authentication context
     * @param rosterId the roster ID to check
     * @throws ResourceAccessDeniedException if access is denied
     */
    public void validateRosterModification(AuthenticationContext ctx, UUID rosterId) {
        if (!ownershipValidator.canModifyRoster(ctx, rosterId)) {
            log.warn("Access denied: {} cannot modify roster {}", getContextDescription(ctx), rosterId);
            throw new ResourceAccessDeniedException("ROSTER_MODIFICATION_DENIED",
                    "You do not have permission to modify this roster");
        }
    }

    /**
     * Validates that the authenticated context can access the specified user's data.
     *
     * @param ctx the authentication context
     * @param userId the user ID to check
     * @throws ResourceAccessDeniedException if access is denied
     */
    public void validateUserAccess(AuthenticationContext ctx, UUID userId) {
        if (!ownershipValidator.canAccessUser(ctx, userId)) {
            log.warn("Access denied: {} cannot access user {}", getContextDescription(ctx), userId);
            throw new ResourceAccessDeniedException("USER_ACCESS_DENIED",
                    "You do not have access to this user's data");
        }
    }

    /**
     * Validates that the authenticated context can modify the specified team selection.
     *
     * @param ctx the authentication context
     * @param selectionId the selection ID to check
     * @throws ResourceAccessDeniedException if access is denied
     */
    public void validateTeamSelectionModification(AuthenticationContext ctx, UUID selectionId) {
        if (!ownershipValidator.canModifyTeamSelection(ctx, selectionId)) {
            log.warn("Access denied: {} cannot modify selection {}", getContextDescription(ctx), selectionId);
            throw new ResourceAccessDeniedException("SELECTION_MODIFICATION_DENIED",
                    "You do not have permission to modify this team selection");
        }
    }

    /**
     * Validates that the user is a member of the specified league.
     *
     * @param userId the user ID
     * @param leagueId the league ID
     * @throws ResourceAccessDeniedException if the user is not a member
     */
    public void validateLeagueMembership(UUID userId, UUID leagueId) {
        if (!ownershipValidator.isLeagueMember(userId, leagueId)) {
            log.warn("Access denied: user {} is not a member of league {}", userId, leagueId);
            throw new ResourceAccessDeniedException("NOT_LEAGUE_MEMBER",
                    "You are not a member of this league");
        }
    }

    /**
     * Validates that the user owns the specified league.
     *
     * @param userId the user ID
     * @param leagueId the league ID
     * @throws ResourceAccessDeniedException if the user does not own the league
     */
    public void validateLeagueOwnership(UUID userId, UUID leagueId) {
        if (!ownershipValidator.isLeagueOwner(userId, leagueId)) {
            log.warn("Access denied: user {} does not own league {}", userId, leagueId);
            throw new ResourceAccessDeniedException("NOT_LEAGUE_OWNER",
                    "League not owned by user");
        }
    }

    private String getContextDescription(AuthenticationContext ctx) {
        if (ctx.isUser()) {
            return String.format("User[id=%s, role=%s]", ctx.getUserId(), ctx.getRole());
        } else {
            return String.format("PAT[id=%s, scope=%s]", ctx.getPatId(), ctx.getScope());
        }
    }

    /**
     * Exception thrown when resource access is denied.
     */
    public static class ResourceAccessDeniedException extends RuntimeException {
        private final String errorCode;

        public ResourceAccessDeniedException(String errorCode, String message) {
            super(message);
            this.errorCode = errorCode;
        }

        public String getErrorCode() {
            return errorCode;
        }
    }
}

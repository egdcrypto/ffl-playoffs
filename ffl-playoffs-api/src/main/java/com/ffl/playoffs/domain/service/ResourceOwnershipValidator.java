package com.ffl.playoffs.domain.service;

import com.ffl.playoffs.domain.model.AuthenticationContext;

import java.util.UUID;

/**
 * Domain service for validating resource ownership.
 * Ensures users can only access resources they own or are members of.
 */
public interface ResourceOwnershipValidator {

    /**
     * Checks if the authenticated context can access the specified league.
     * - SUPER_ADMIN can access any league
     * - ADMIN can only access leagues they own
     * - PLAYER can only access leagues they are a member of
     * - PAT with ADMIN scope can access any league
     * - PAT with WRITE/READ_ONLY scope follows the same rules as users
     *
     * @param ctx the authentication context
     * @param leagueId the league to check access for
     * @return true if the context can access the league
     */
    boolean canAccessLeague(AuthenticationContext ctx, UUID leagueId);

    /**
     * Checks if the authenticated context can modify the specified roster.
     * - SUPER_ADMIN can modify any roster
     * - ADMIN can modify rosters in leagues they own
     * - PLAYER can only modify their own roster
     * - PAT with ADMIN scope can modify any roster
     * - PAT with WRITE scope can modify rosters in leagues they're authorized for
     *
     * @param ctx the authentication context
     * @param rosterId the roster to check access for
     * @return true if the context can modify the roster
     */
    boolean canModifyRoster(AuthenticationContext ctx, UUID rosterId);

    /**
     * Checks if the authenticated context can access the specified user's data.
     * - SUPER_ADMIN can access any user
     * - ADMIN can access users in leagues they own
     * - PLAYER can only access their own user data
     * - PAT with ADMIN scope can access any user
     * - PAT with lower scopes follow restricted access rules
     *
     * @param ctx the authentication context
     * @param userId the user to check access for
     * @return true if the context can access the user's data
     */
    boolean canAccessUser(AuthenticationContext ctx, UUID userId);

    /**
     * Checks if the authenticated context can modify the specified team selection.
     * - SUPER_ADMIN can modify any selection
     * - ADMIN can modify selections in leagues they own
     * - PLAYER can only modify their own selections
     *
     * @param ctx the authentication context
     * @param selectionId the team selection to check access for
     * @return true if the context can modify the selection
     */
    boolean canModifyTeamSelection(AuthenticationContext ctx, UUID selectionId);

    /**
     * Checks if the user is a member of the specified league.
     *
     * @param userId the user ID
     * @param leagueId the league ID
     * @return true if the user is a member of the league
     */
    boolean isLeagueMember(UUID userId, UUID leagueId);

    /**
     * Checks if the user is the owner of the specified league.
     *
     * @param userId the user ID
     * @param leagueId the league ID
     * @return true if the user owns the league
     */
    boolean isLeagueOwner(UUID userId, UUID leagueId);
}

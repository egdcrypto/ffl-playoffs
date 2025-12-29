package com.ffl.playoffs.infrastructure.adapter.service;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.model.AuthenticationContext;
import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.model.PATScope;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.model.TeamSelection;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.RosterRepository;
import com.ffl.playoffs.domain.port.TeamSelectionRepository;
import com.ffl.playoffs.domain.service.ResourceOwnershipValidator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.UUID;

/**
 * Infrastructure implementation of ResourceOwnershipValidator.
 * Validates resource ownership by querying repositories.
 */
@Service
public class ResourceOwnershipValidatorImpl implements ResourceOwnershipValidator {

    private static final Logger log = LoggerFactory.getLogger(ResourceOwnershipValidatorImpl.class);

    private final LeagueRepository leagueRepository;
    private final LeaguePlayerRepository leaguePlayerRepository;
    private final RosterRepository rosterRepository;
    private final TeamSelectionRepository teamSelectionRepository;

    public ResourceOwnershipValidatorImpl(
            LeagueRepository leagueRepository,
            LeaguePlayerRepository leaguePlayerRepository,
            RosterRepository rosterRepository,
            TeamSelectionRepository teamSelectionRepository) {
        this.leagueRepository = leagueRepository;
        this.leaguePlayerRepository = leaguePlayerRepository;
        this.rosterRepository = rosterRepository;
        this.teamSelectionRepository = teamSelectionRepository;
    }

    @Override
    public boolean canAccessLeague(AuthenticationContext ctx, UUID leagueId) {
        // Super admin or PAT with ADMIN scope can access any league
        if (ctx.isUser() && ctx.isSuperAdmin()) {
            log.debug("Super admin {} accessing league {}", ctx.getUserId(), leagueId);
            return true;
        }
        if (ctx.isPAT() && ctx.getScope() == PATScope.ADMIN) {
            log.debug("PAT with ADMIN scope accessing league {}", leagueId);
            return true;
        }

        if (ctx.isUser()) {
            // Admin can only access leagues they own
            if (ctx.getRole() == Role.ADMIN) {
                return isLeagueOwner(ctx.getUserId(), leagueId);
            }
            // Player can only access leagues they are a member of
            if (ctx.getRole() == Role.PLAYER) {
                return isLeagueMember(ctx.getUserId(), leagueId);
            }
        }

        // PAT with lower scopes follow same rules as users
        if (ctx.isPAT()) {
            // PAT cannot access league-specific resources without league context
            // This would require additional authorization context
            log.debug("PAT {} with scope {} denied access to league {}",
                    ctx.getPatId(), ctx.getScope(), leagueId);
            return false;
        }

        return false;
    }

    @Override
    public boolean canModifyRoster(AuthenticationContext ctx, UUID rosterId) {
        // Super admin or PAT with ADMIN scope can modify any roster
        if (ctx.isUser() && ctx.isSuperAdmin()) {
            log.debug("Super admin {} modifying roster {}", ctx.getUserId(), rosterId);
            return true;
        }
        if (ctx.isPAT() && ctx.getScope() == PATScope.ADMIN) {
            log.debug("PAT with ADMIN scope modifying roster {}", rosterId);
            return true;
        }

        // Find the roster
        Optional<Roster> rosterOpt = rosterRepository.findById(rosterId);
        if (rosterOpt.isEmpty()) {
            log.warn("Roster {} not found", rosterId);
            return false;
        }
        Roster roster = rosterOpt.get();

        // Find the league player
        Optional<LeaguePlayer> leaguePlayerOpt = leaguePlayerRepository.findById(roster.getLeaguePlayerId());
        if (leaguePlayerOpt.isEmpty()) {
            log.warn("LeaguePlayer {} not found for roster {}", roster.getLeaguePlayerId(), rosterId);
            return false;
        }
        LeaguePlayer leaguePlayer = leaguePlayerOpt.get();

        if (ctx.isUser()) {
            // Admin can modify rosters in leagues they own
            if (ctx.isAdmin()) {
                return isLeagueOwner(ctx.getUserId(), leaguePlayer.getLeagueId());
            }
            // Player can only modify their own roster
            return ctx.getUserId().equals(leaguePlayer.getUserId());
        }

        // PAT with WRITE scope can modify rosters (for automated services)
        if (ctx.isPAT() && ctx.getScope() == PATScope.WRITE) {
            return true;
        }

        return false;
    }

    @Override
    public boolean canAccessUser(AuthenticationContext ctx, UUID userId) {
        // Super admin or PAT with ADMIN scope can access any user
        if (ctx.isUser() && ctx.isSuperAdmin()) {
            log.debug("Super admin {} accessing user {}", ctx.getUserId(), userId);
            return true;
        }
        if (ctx.isPAT() && ctx.getScope() == PATScope.ADMIN) {
            log.debug("PAT with ADMIN scope accessing user {}", userId);
            return true;
        }

        if (ctx.isUser()) {
            // Users can always access their own data
            if (ctx.getUserId().equals(userId)) {
                return true;
            }

            // Admin can access users in leagues they own
            if (ctx.isAdmin()) {
                // Check if user is in any league owned by this admin
                return isUserInOwnedLeague(ctx.getUserId(), userId);
            }
        }

        // PAT with lower scopes cannot access user-specific data
        return false;
    }

    @Override
    public boolean canModifyTeamSelection(AuthenticationContext ctx, UUID selectionId) {
        // Super admin or PAT with ADMIN scope can modify any selection
        if (ctx.isUser() && ctx.isSuperAdmin()) {
            log.debug("Super admin {} modifying selection {}", ctx.getUserId(), selectionId);
            return true;
        }
        if (ctx.isPAT() && ctx.getScope() == PATScope.ADMIN) {
            log.debug("PAT with ADMIN scope modifying selection {}", selectionId);
            return true;
        }

        // Find the selection
        Optional<TeamSelection> selectionOpt = teamSelectionRepository.findById(selectionId);
        if (selectionOpt.isEmpty()) {
            log.warn("TeamSelection {} not found", selectionId);
            return false;
        }
        TeamSelection selection = selectionOpt.get();

        if (ctx.isUser()) {
            // Player can only modify their own selections
            // Note: TeamSelection uses Long for playerId, need to convert
            Long userIdAsLong = ctx.getUserId().getMostSignificantBits();
            if (selection.getPlayerId().equals(userIdAsLong)) {
                return true;
            }

            // Admin might be able to modify selections in leagues they own
            // This would require knowing which league the selection belongs to
        }

        // PAT with WRITE scope can modify selections (for automated services)
        if (ctx.isPAT() && ctx.getScope() == PATScope.WRITE) {
            return true;
        }

        return false;
    }

    @Override
    public boolean isLeagueMember(UUID userId, UUID leagueId) {
        Optional<LeaguePlayer> membership = leaguePlayerRepository.findByUserIdAndLeagueId(userId, leagueId);
        if (membership.isEmpty()) {
            return false;
        }
        LeaguePlayer leaguePlayer = membership.get();
        return leaguePlayer.isActive();
    }

    @Override
    public boolean isLeagueOwner(UUID userId, UUID leagueId) {
        Optional<League> leagueOpt = leagueRepository.findById(leagueId);
        if (leagueOpt.isEmpty()) {
            return false;
        }
        League league = leagueOpt.get();
        return userId.equals(league.getOwnerId());
    }

    /**
     * Checks if a user is in any league owned by the admin.
     */
    private boolean isUserInOwnedLeague(UUID adminId, UUID userId) {
        // Get all leagues owned by admin
        var ownedLeagues = leagueRepository.findByAdminId(adminId);

        // Check if user is a member of any of these leagues
        for (League league : ownedLeagues) {
            if (isLeagueMember(userId, league.getId())) {
                return true;
            }
        }

        return false;
    }
}

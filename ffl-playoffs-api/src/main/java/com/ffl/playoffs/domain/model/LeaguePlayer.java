package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * LeaguePlayer entity - Junction table linking User to League/Game
 *
 * Represents league membership with league-scoped player data.
 * Supports multi-league participation - a User can be a member of multiple Leagues.
 *
 * Domain model with no framework dependencies.
 */
public class LeaguePlayer {
    private UUID id;
    private UUID userId;
    private UUID leagueId;  // References Game entity (League/Game are same concept)
    private LeaguePlayerStatus status;
    private LocalDateTime joinedAt;
    private LocalDateTime invitedAt;
    private LocalDateTime lastActiveAt;
    private String invitationToken;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public LeaguePlayer() {
        this.id = UUID.randomUUID();
        this.status = LeaguePlayerStatus.INVITED;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public LeaguePlayer(UUID userId, UUID leagueId) {
        this();
        this.userId = userId;
        this.leagueId = leagueId;
        this.invitedAt = LocalDateTime.now();
    }

    // Business methods

    /**
     * Accept invitation to join the league.
     * Transitions from INVITED to ACTIVE status.
     */
    public void acceptInvitation() {
        if (this.status != LeaguePlayerStatus.INVITED) {
            throw new IllegalStateException(
                "Can only accept invitation when status is INVITED. Current status: " + this.status
            );
        }
        this.status = LeaguePlayerStatus.ACTIVE;
        this.joinedAt = LocalDateTime.now();
        this.lastActiveAt = LocalDateTime.now();
        this.invitationToken = null; // Clear token once accepted
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Decline invitation to join the league.
     * Transitions from INVITED to DECLINED status.
     */
    public void declineInvitation() {
        if (this.status != LeaguePlayerStatus.INVITED) {
            throw new IllegalStateException(
                "Can only decline invitation when status is INVITED. Current status: " + this.status
            );
        }
        this.status = LeaguePlayerStatus.DECLINED;
        this.invitationToken = null; // Clear token
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Deactivate the league player (admin action).
     * Transitions from ACTIVE to INACTIVE status.
     */
    public void deactivate() {
        if (this.status != LeaguePlayerStatus.ACTIVE) {
            throw new IllegalStateException(
                "Can only deactivate ACTIVE players. Current status: " + this.status
            );
        }
        this.status = LeaguePlayerStatus.INACTIVE;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Reactivate an inactive league player (admin action).
     * Transitions from INACTIVE to ACTIVE status.
     */
    public void reactivate() {
        if (this.status != LeaguePlayerStatus.INACTIVE) {
            throw new IllegalStateException(
                "Can only reactivate INACTIVE players. Current status: " + this.status
            );
        }
        this.status = LeaguePlayerStatus.ACTIVE;
        this.lastActiveAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Remove player from league (admin action).
     * Transitions to REMOVED status.
     */
    public void remove() {
        if (this.status == LeaguePlayerStatus.REMOVED) {
            throw new IllegalStateException("Player is already removed from league");
        }
        this.status = LeaguePlayerStatus.REMOVED;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Update last active timestamp.
     * Called when player performs any action in the league.
     */
    public void updateLastActive() {
        if (this.status != LeaguePlayerStatus.ACTIVE) {
            throw new IllegalStateException(
                "Can only update activity for ACTIVE players. Current status: " + this.status
            );
        }
        this.lastActiveAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Check if the player is active in the league.
     *
     * @return true if status is ACTIVE, false otherwise
     */
    public boolean isActive() {
        return this.status == LeaguePlayerStatus.ACTIVE;
    }

    /**
     * Check if the invitation is pending.
     *
     * @return true if status is INVITED, false otherwise
     */
    public boolean isPending() {
        return this.status == LeaguePlayerStatus.INVITED;
    }

    /**
     * Check if the player can participate in league activities.
     * Only ACTIVE players can make roster selections, view detailed stats, etc.
     *
     * @return true if player can participate, false otherwise
     */
    public boolean canParticipate() {
        return this.status == LeaguePlayerStatus.ACTIVE;
    }

    // Getters and Setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public UUID getLeagueId() {
        return leagueId;
    }

    public void setLeagueId(UUID leagueId) {
        this.leagueId = leagueId;
    }

    public LeaguePlayerStatus getStatus() {
        return status;
    }

    public void setStatus(LeaguePlayerStatus status) {
        this.status = status;
        this.updatedAt = LocalDateTime.now();
    }

    public LocalDateTime getJoinedAt() {
        return joinedAt;
    }

    public void setJoinedAt(LocalDateTime joinedAt) {
        this.joinedAt = joinedAt;
    }

    public LocalDateTime getInvitedAt() {
        return invitedAt;
    }

    public void setInvitedAt(LocalDateTime invitedAt) {
        this.invitedAt = invitedAt;
    }

    public LocalDateTime getLastActiveAt() {
        return lastActiveAt;
    }

    public void setLastActiveAt(LocalDateTime lastActiveAt) {
        this.lastActiveAt = lastActiveAt;
    }

    public String getInvitationToken() {
        return invitationToken;
    }

    public void setInvitationToken(String invitationToken) {
        this.invitationToken = invitationToken;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    /**
     * League Player Status enum.
     * Represents the lifecycle of a player's membership in a league.
     */
    public enum LeaguePlayerStatus {
        /**
         * Player has been invited but hasn't responded yet
         */
        INVITED,

        /**
         * Player has accepted invitation and is active in the league
         */
        ACTIVE,

        /**
         * Player declined the invitation
         */
        DECLINED,

        /**
         * Player was active but has been deactivated (admin action)
         */
        INACTIVE,

        /**
         * Player has been removed from the league (admin action)
         */
        REMOVED
    }
}

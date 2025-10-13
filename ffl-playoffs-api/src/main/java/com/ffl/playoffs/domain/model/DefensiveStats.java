package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * DefensiveStats Entity
 * Represents team defense statistics for a specific game
 * Used for calculating fantasy points for DEF/ST position
 * Domain model with no framework dependencies
 */
public class DefensiveStats {
    private UUID id;
    private String teamAbbreviation;  // References NFLTeam (e.g., "KC", "SF")
    private UUID nflGameId;           // References NFLGame
    private Integer week;             // NFL week number
    private Integer season;           // NFL season year

    // Defensive Stats
    private Integer sacks;
    private Integer interceptions;
    private Integer fumblesRecovered;
    private Integer safeties;
    private Integer defensiveTouchdowns;  // INT return TDs + fumble return TDs
    private Integer blockedKicks;         // Blocked punts, FGs, XPs
    private Integer kickReturnTouchdowns;
    private Integer puntReturnTouchdowns;

    // Points/Yards Allowed (for tiered scoring)
    private Integer pointsAllowed;
    private Integer yardsAllowed;
    private Integer passYardsAllowed;
    private Integer rushYardsAllowed;

    // Additional defensive stats
    private Integer tackles;
    private Integer tacklesForLoss;
    private Integer quarterbackHits;
    private Integer passesDefended;

    // Calculated fantasy points
    private Double fantasyPoints;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime syncedAt;  // When stats were last synced from external source

    // Constructors
    public DefensiveStats() {
        this.id = UUID.randomUUID();
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public DefensiveStats(String teamAbbreviation, UUID nflGameId, Integer week, Integer season) {
        this();
        this.teamAbbreviation = teamAbbreviation;
        this.nflGameId = nflGameId;
        this.week = week;
        this.season = season;
    }

    // Business Logic

    /**
     * Calculates standard fantasy points for team defense
     * Uses common DST scoring rules
     * @return calculated fantasy points
     */
    public double calculateStandardPoints() {
        double points = 0.0;

        // Defensive scoring
        if (sacks != null) points += sacks * 1.0;  // 1 point per sack
        if (interceptions != null) points += interceptions * 2.0;  // 2 points per INT
        if (fumblesRecovered != null) points += fumblesRecovered * 2.0;  // 2 points per fumble recovery
        if (safeties != null) points += safeties * 2.0;  // 2 points per safety
        if (defensiveTouchdowns != null) points += defensiveTouchdowns * 6.0;  // 6 points per TD
        if (blockedKicks != null) points += blockedKicks * 2.0;  // 2 points per blocked kick
        if (kickReturnTouchdowns != null) points += kickReturnTouchdowns * 6.0;  // 6 points per KR TD
        if (puntReturnTouchdowns != null) points += puntReturnTouchdowns * 6.0;  // 6 points per PR TD

        // Points allowed (tiered scoring)
        if (pointsAllowed != null) {
            if (pointsAllowed == 0) points += 10.0;
            else if (pointsAllowed <= 6) points += 7.0;
            else if (pointsAllowed <= 13) points += 4.0;
            else if (pointsAllowed <= 20) points += 1.0;
            else if (pointsAllowed <= 27) points += 0.0;
            else if (pointsAllowed <= 34) points -= 1.0;
            else points -= 4.0;  // 35+
        }

        return points;
    }

    /**
     * Calculates points based on yards allowed (alternative/additional scoring)
     * @return calculated points from yards allowed
     */
    public double calculateYardsAllowedPoints() {
        double points = 0.0;

        if (yardsAllowed != null) {
            if (yardsAllowed < 100) points += 5.0;
            else if (yardsAllowed <= 199) points += 3.0;
            else if (yardsAllowed <= 299) points += 2.0;
            else if (yardsAllowed <= 399) points += 0.0;
            else if (yardsAllowed <= 449) points -= 1.0;
            else if (yardsAllowed <= 499) points -= 3.0;
            else points -= 5.0;  // 500+
        }

        return points;
    }

    /**
     * Marks stats as synced from external source
     */
    public void markSynced() {
        this.syncedAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Gets total touchdowns (defensive + special teams)
     * @return total touchdowns
     */
    public int getTotalTouchdowns() {
        int total = 0;
        if (defensiveTouchdowns != null) total += defensiveTouchdowns;
        if (kickReturnTouchdowns != null) total += kickReturnTouchdowns;
        if (puntReturnTouchdowns != null) total += puntReturnTouchdowns;
        return total;
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getTeamAbbreviation() {
        return teamAbbreviation;
    }

    public void setTeamAbbreviation(String teamAbbreviation) {
        this.teamAbbreviation = teamAbbreviation;
    }

    public UUID getNflGameId() {
        return nflGameId;
    }

    public void setNflGameId(UUID nflGameId) {
        this.nflGameId = nflGameId;
    }

    public Integer getWeek() {
        return week;
    }

    public void setWeek(Integer week) {
        this.week = week;
    }

    public Integer getSeason() {
        return season;
    }

    public void setSeason(Integer season) {
        this.season = season;
    }

    public Integer getSacks() {
        return sacks;
    }

    public void setSacks(Integer sacks) {
        this.sacks = sacks;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getInterceptions() {
        return interceptions;
    }

    public void setInterceptions(Integer interceptions) {
        this.interceptions = interceptions;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getFumblesRecovered() {
        return fumblesRecovered;
    }

    public void setFumblesRecovered(Integer fumblesRecovered) {
        this.fumblesRecovered = fumblesRecovered;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getSafeties() {
        return safeties;
    }

    public void setSafeties(Integer safeties) {
        this.safeties = safeties;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getDefensiveTouchdowns() {
        return defensiveTouchdowns;
    }

    public void setDefensiveTouchdowns(Integer defensiveTouchdowns) {
        this.defensiveTouchdowns = defensiveTouchdowns;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getBlockedKicks() {
        return blockedKicks;
    }

    public void setBlockedKicks(Integer blockedKicks) {
        this.blockedKicks = blockedKicks;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getKickReturnTouchdowns() {
        return kickReturnTouchdowns;
    }

    public void setKickReturnTouchdowns(Integer kickReturnTouchdowns) {
        this.kickReturnTouchdowns = kickReturnTouchdowns;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getPuntReturnTouchdowns() {
        return puntReturnTouchdowns;
    }

    public void setPuntReturnTouchdowns(Integer puntReturnTouchdowns) {
        this.puntReturnTouchdowns = puntReturnTouchdowns;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getPointsAllowed() {
        return pointsAllowed;
    }

    public void setPointsAllowed(Integer pointsAllowed) {
        this.pointsAllowed = pointsAllowed;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getYardsAllowed() {
        return yardsAllowed;
    }

    public void setYardsAllowed(Integer yardsAllowed) {
        this.yardsAllowed = yardsAllowed;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getPassYardsAllowed() {
        return passYardsAllowed;
    }

    public void setPassYardsAllowed(Integer passYardsAllowed) {
        this.passYardsAllowed = passYardsAllowed;
    }

    public Integer getRushYardsAllowed() {
        return rushYardsAllowed;
    }

    public void setRushYardsAllowed(Integer rushYardsAllowed) {
        this.rushYardsAllowed = rushYardsAllowed;
    }

    public Integer getTackles() {
        return tackles;
    }

    public void setTackles(Integer tackles) {
        this.tackles = tackles;
    }

    public Integer getTacklesForLoss() {
        return tacklesForLoss;
    }

    public void setTacklesForLoss(Integer tacklesForLoss) {
        this.tacklesForLoss = tacklesForLoss;
    }

    public Integer getQuarterbackHits() {
        return quarterbackHits;
    }

    public void setQuarterbackHits(Integer quarterbackHits) {
        this.quarterbackHits = quarterbackHits;
    }

    public Integer getPassesDefended() {
        return passesDefended;
    }

    public void setPassesDefended(Integer passesDefended) {
        this.passesDefended = passesDefended;
    }

    public Double getFantasyPoints() {
        return fantasyPoints;
    }

    public void setFantasyPoints(Double fantasyPoints) {
        this.fantasyPoints = fantasyPoints;
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

    public LocalDateTime getSyncedAt() {
        return syncedAt;
    }

    public void setSyncedAt(LocalDateTime syncedAt) {
        this.syncedAt = syncedAt;
    }
}

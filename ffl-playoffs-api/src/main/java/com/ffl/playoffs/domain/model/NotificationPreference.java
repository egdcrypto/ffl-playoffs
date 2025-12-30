package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Domain model for user notification preferences.
 * Configures which push notifications the user receives.
 */
public class NotificationPreference {
    private UUID id;
    private String userId;
    private boolean scoreMilestones;
    private boolean rankChanges;
    private boolean individualPlayerTDs;
    private boolean matchupLeadChanges;
    private boolean gameCompletion;
    private boolean quietHoursEnabled;
    private int quietHoursStart;
    private int quietHoursEnd;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public NotificationPreference() {
        this.id = UUID.randomUUID();
        this.scoreMilestones = true;
        this.rankChanges = true;
        this.individualPlayerTDs = false;
        this.matchupLeadChanges = true;
        this.gameCompletion = true;
        this.quietHoursEnabled = false;
        this.quietHoursStart = 23;
        this.quietHoursEnd = 7;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public NotificationPreference(String userId) {
        this();
        this.userId = userId;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public boolean isScoreMilestones() {
        return scoreMilestones;
    }

    public void setScoreMilestones(boolean scoreMilestones) {
        this.scoreMilestones = scoreMilestones;
    }

    public boolean isRankChanges() {
        return rankChanges;
    }

    public void setRankChanges(boolean rankChanges) {
        this.rankChanges = rankChanges;
    }

    public boolean isIndividualPlayerTDs() {
        return individualPlayerTDs;
    }

    public void setIndividualPlayerTDs(boolean individualPlayerTDs) {
        this.individualPlayerTDs = individualPlayerTDs;
    }

    public boolean isMatchupLeadChanges() {
        return matchupLeadChanges;
    }

    public void setMatchupLeadChanges(boolean matchupLeadChanges) {
        this.matchupLeadChanges = matchupLeadChanges;
    }

    public boolean isGameCompletion() {
        return gameCompletion;
    }

    public void setGameCompletion(boolean gameCompletion) {
        this.gameCompletion = gameCompletion;
    }

    public boolean isQuietHoursEnabled() {
        return quietHoursEnabled;
    }

    public void setQuietHoursEnabled(boolean quietHoursEnabled) {
        this.quietHoursEnabled = quietHoursEnabled;
    }

    public int getQuietHoursStart() {
        return quietHoursStart;
    }

    public void setQuietHoursStart(int quietHoursStart) {
        this.quietHoursStart = quietHoursStart;
    }

    public int getQuietHoursEnd() {
        return quietHoursEnd;
    }

    public void setQuietHoursEnd(int quietHoursEnd) {
        this.quietHoursEnd = quietHoursEnd;
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
     * Check if current time is within quiet hours
     * @param currentHour the current hour (0-23)
     * @return true if in quiet hours
     */
    public boolean isInQuietHours(int currentHour) {
        if (!quietHoursEnabled) {
            return false;
        }
        if (quietHoursStart < quietHoursEnd) {
            return currentHour >= quietHoursStart && currentHour < quietHoursEnd;
        } else {
            return currentHour >= quietHoursStart || currentHour < quietHoursEnd;
        }
    }

    public void markUpdated() {
        this.updatedAt = LocalDateTime.now();
    }
}

package com.ffl.playoffs.application.dto;

/**
 * Data Transfer Object for User Notification Preferences
 * Configures which push notifications the user receives
 */
public class NotificationPreferencesDTO {
    private String userId;
    private boolean scoreMilestones;
    private boolean rankChanges;
    private boolean individualPlayerTDs;
    private boolean matchupLeadChanges;
    private boolean gameCompletion;
    private boolean quietHoursEnabled;
    private int quietHoursStart; // Hour of day (0-23)
    private int quietHoursEnd;   // Hour of day (0-23)

    public NotificationPreferencesDTO() {
        // Default preferences
        this.scoreMilestones = true;
        this.rankChanges = true;
        this.individualPlayerTDs = false;
        this.matchupLeadChanges = true;
        this.gameCompletion = true;
        this.quietHoursEnabled = false;
        this.quietHoursStart = 23;
        this.quietHoursEnd = 7;
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
            // Quiet hours span midnight
            return currentHour >= quietHoursStart || currentHour < quietHoursEnd;
        }
    }
}

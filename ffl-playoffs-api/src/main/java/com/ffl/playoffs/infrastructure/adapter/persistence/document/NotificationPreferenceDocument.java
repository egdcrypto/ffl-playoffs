package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

/**
 * MongoDB document for NotificationPreference entity
 * Infrastructure layer persistence model
 */
@Document(collection = "notification_preferences")
public class NotificationPreferenceDocument {

    @Id
    private String id;

    @Indexed(unique = true)
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

    public NotificationPreferenceDocument() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
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
}

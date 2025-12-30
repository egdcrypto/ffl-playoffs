package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.CompoundIndexes;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;

/**
 * MongoDB document for Character entity
 * Infrastructure layer persistence model
 */
@Document(collection = "characters")
@CompoundIndexes({
    @CompoundIndex(name = "user_league_idx", def = "{'userId': 1, 'leagueId': 1}", unique = true),
    @CompoundIndex(name = "league_name_idx", def = "{'leagueId': 1, 'name': 1}"),
    @CompoundIndex(name = "league_status_idx", def = "{'leagueId': 1, 'status': 1}"),
    @CompoundIndex(name = "league_score_idx", def = "{'leagueId': 1, 'totalScore': -1}")
})
public class CharacterDocument {

    @Id
    private String id;

    @Indexed
    private String userId;

    @Indexed
    private String leagueId;

    private String name;
    private String avatarUrl;
    private String status;  // DRAFT, ACTIVE, ELIMINATED

    // Score tracking
    private Double totalScore;
    private Integer weeklyRank;
    private Integer overallRank;

    // Elimination details
    private Integer eliminationWeek;
    private Double eliminationScore;
    private Integer eliminationRank;
    private String eliminationReason;

    // Timestamps
    private Instant createdAt;
    private Instant activatedAt;
    private Instant eliminatedAt;
    private Instant updatedAt;

    public CharacterDocument() {
    }

    // Getters and Setters

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

    public String getLeagueId() {
        return leagueId;
    }

    public void setLeagueId(String leagueId) {
        this.leagueId = leagueId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Double getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(Double totalScore) {
        this.totalScore = totalScore;
    }

    public Integer getWeeklyRank() {
        return weeklyRank;
    }

    public void setWeeklyRank(Integer weeklyRank) {
        this.weeklyRank = weeklyRank;
    }

    public Integer getOverallRank() {
        return overallRank;
    }

    public void setOverallRank(Integer overallRank) {
        this.overallRank = overallRank;
    }

    public Integer getEliminationWeek() {
        return eliminationWeek;
    }

    public void setEliminationWeek(Integer eliminationWeek) {
        this.eliminationWeek = eliminationWeek;
    }

    public Double getEliminationScore() {
        return eliminationScore;
    }

    public void setEliminationScore(Double eliminationScore) {
        this.eliminationScore = eliminationScore;
    }

    public Integer getEliminationRank() {
        return eliminationRank;
    }

    public void setEliminationRank(Integer eliminationRank) {
        this.eliminationRank = eliminationRank;
    }

    public String getEliminationReason() {
        return eliminationReason;
    }

    public void setEliminationReason(String eliminationReason) {
        this.eliminationReason = eliminationReason;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Instant createdAt) {
        this.createdAt = createdAt;
    }

    public Instant getActivatedAt() {
        return activatedAt;
    }

    public void setActivatedAt(Instant activatedAt) {
        this.activatedAt = activatedAt;
    }

    public Instant getEliminatedAt() {
        return eliminatedAt;
    }

    public void setEliminatedAt(Instant eliminatedAt) {
        this.eliminatedAt = eliminatedAt;
    }

    public Instant getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Instant updatedAt) {
        this.updatedAt = updatedAt;
    }
}

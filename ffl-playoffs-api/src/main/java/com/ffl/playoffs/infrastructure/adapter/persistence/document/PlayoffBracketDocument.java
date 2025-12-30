package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * MongoDB document for PlayoffBracket aggregate
 * Infrastructure layer persistence model
 */
@Document(collection = "playoff_brackets")
public class PlayoffBracketDocument {

    @Id
    private String id;

    @Indexed(unique = true)
    private String leagueId;

    private String leagueName;
    private String currentRound; // PlayoffRound enum as string
    private Integer totalPlayers;

    // Tiebreaker configuration
    private TiebreakerConfigurationDocument tiebreakerConfiguration;

    // Player entries
    private List<PlayerBracketEntryDocument> playerEntries;

    // Matchups by round
    private Map<String, List<PlayoffMatchupDocument>> matchupsByRound;

    // Scores by round
    private Map<String, List<RosterScoreDocument>> scoresByRound;

    // Rankings by round
    private Map<String, List<PlayoffRankingDocument>> rankingsByRound;

    // Cumulative scores
    private Map<String, BigDecimal> cumulativeScores;

    // Metadata
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean isComplete;

    public PlayoffBracketDocument() {
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getLeagueId() { return leagueId; }
    public void setLeagueId(String leagueId) { this.leagueId = leagueId; }

    public String getLeagueName() { return leagueName; }
    public void setLeagueName(String leagueName) { this.leagueName = leagueName; }

    public String getCurrentRound() { return currentRound; }
    public void setCurrentRound(String currentRound) { this.currentRound = currentRound; }

    public Integer getTotalPlayers() { return totalPlayers; }
    public void setTotalPlayers(Integer totalPlayers) { this.totalPlayers = totalPlayers; }

    public TiebreakerConfigurationDocument getTiebreakerConfiguration() { return tiebreakerConfiguration; }
    public void setTiebreakerConfiguration(TiebreakerConfigurationDocument tiebreakerConfiguration) {
        this.tiebreakerConfiguration = tiebreakerConfiguration;
    }

    public List<PlayerBracketEntryDocument> getPlayerEntries() { return playerEntries; }
    public void setPlayerEntries(List<PlayerBracketEntryDocument> playerEntries) { this.playerEntries = playerEntries; }

    public Map<String, List<PlayoffMatchupDocument>> getMatchupsByRound() { return matchupsByRound; }
    public void setMatchupsByRound(Map<String, List<PlayoffMatchupDocument>> matchupsByRound) {
        this.matchupsByRound = matchupsByRound;
    }

    public Map<String, List<RosterScoreDocument>> getScoresByRound() { return scoresByRound; }
    public void setScoresByRound(Map<String, List<RosterScoreDocument>> scoresByRound) {
        this.scoresByRound = scoresByRound;
    }

    public Map<String, List<PlayoffRankingDocument>> getRankingsByRound() { return rankingsByRound; }
    public void setRankingsByRound(Map<String, List<PlayoffRankingDocument>> rankingsByRound) {
        this.rankingsByRound = rankingsByRound;
    }

    public Map<String, BigDecimal> getCumulativeScores() { return cumulativeScores; }
    public void setCumulativeScores(Map<String, BigDecimal> cumulativeScores) {
        this.cumulativeScores = cumulativeScores;
    }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public boolean isComplete() { return isComplete; }
    public void setComplete(boolean complete) { isComplete = complete; }

    /**
     * Embedded document for tiebreaker configuration
     */
    public static class TiebreakerConfigurationDocument {
        private List<String> tiebreakerCascade;

        public List<String> getTiebreakerCascade() { return tiebreakerCascade; }
        public void setTiebreakerCascade(List<String> tiebreakerCascade) { this.tiebreakerCascade = tiebreakerCascade; }
    }

    /**
     * Embedded document for player bracket entry
     */
    public static class PlayerBracketEntryDocument {
        private String playerId;
        private String playerName;
        private int seed;
        private BigDecimal regularSeasonScore;
        private String status; // PlayerPlayoffStatus as string
        private String eliminatedInRound;
        private String eliminatedByPlayerId;
        private LocalDateTime eliminatedAt;

        public String getPlayerId() { return playerId; }
        public void setPlayerId(String playerId) { this.playerId = playerId; }

        public String getPlayerName() { return playerName; }
        public void setPlayerName(String playerName) { this.playerName = playerName; }

        public int getSeed() { return seed; }
        public void setSeed(int seed) { this.seed = seed; }

        public BigDecimal getRegularSeasonScore() { return regularSeasonScore; }
        public void setRegularSeasonScore(BigDecimal regularSeasonScore) { this.regularSeasonScore = regularSeasonScore; }

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }

        public String getEliminatedInRound() { return eliminatedInRound; }
        public void setEliminatedInRound(String eliminatedInRound) { this.eliminatedInRound = eliminatedInRound; }

        public String getEliminatedByPlayerId() { return eliminatedByPlayerId; }
        public void setEliminatedByPlayerId(String eliminatedByPlayerId) { this.eliminatedByPlayerId = eliminatedByPlayerId; }

        public LocalDateTime getEliminatedAt() { return eliminatedAt; }
        public void setEliminatedAt(LocalDateTime eliminatedAt) { this.eliminatedAt = eliminatedAt; }
    }
}

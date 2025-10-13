package com.ffl.playoffs.application.dto;

import java.util.List;
import java.util.UUID;

/**
 * Data Transfer Object for Leaderboard Entry
 * Used for API communication
 */
public class LeaderboardEntryDTO {
    private int rank;
    private UUID playerId;
    private String playerName;
    private String email;
    private double totalScore;
    private int gamesWon;
    private int gamesLost;
    private boolean isEliminated;
    private List<String> teamsUsed;
    private List<WeekScoreDTO> weeklyScores;

    public LeaderboardEntryDTO() {
    }

    public int getRank() {
        return rank;
    }

    public void setRank(int rank) {
        this.rank = rank;
    }

    public UUID getPlayerId() {
        return playerId;
    }

    public void setPlayerId(UUID playerId) {
        this.playerId = playerId;
    }

    public String getPlayerName() {
        return playerName;
    }

    public void setPlayerName(String playerName) {
        this.playerName = playerName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public double getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(double totalScore) {
        this.totalScore = totalScore;
    }

    public int getGamesWon() {
        return gamesWon;
    }

    public void setGamesWon(int gamesWon) {
        this.gamesWon = gamesWon;
    }

    public int getGamesLost() {
        return gamesLost;
    }

    public void setGamesLost(int gamesLost) {
        this.gamesLost = gamesLost;
    }

    public boolean isEliminated() {
        return isEliminated;
    }

    public void setEliminated(boolean eliminated) {
        isEliminated = eliminated;
    }

    public List<String> getTeamsUsed() {
        return teamsUsed;
    }

    public void setTeamsUsed(List<String> teamsUsed) {
        this.teamsUsed = teamsUsed;
    }

    public List<WeekScoreDTO> getWeeklyScores() {
        return weeklyScores;
    }

    public void setWeeklyScores(List<WeekScoreDTO> weeklyScores) {
        this.weeklyScores = weeklyScores;
    }

    public static class WeekScoreDTO {
        private int week;
        private double score;
        private String teamName;
        private String outcome;

        public WeekScoreDTO() {
        }

        public int getWeek() {
            return week;
        }

        public void setWeek(int week) {
            this.week = week;
        }

        public double getScore() {
            return score;
        }

        public void setScore(double score) {
            this.score = score;
        }

        public String getTeamName() {
            return teamName;
        }

        public void setTeamName(String teamName) {
            this.teamName = teamName;
        }

        public String getOutcome() {
            return outcome;
        }

        public void setOutcome(String outcome) {
            this.outcome = outcome;
        }
    }
}

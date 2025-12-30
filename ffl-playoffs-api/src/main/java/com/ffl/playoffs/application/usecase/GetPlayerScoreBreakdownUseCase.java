package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.PlayoffRound;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.PositionScore;
import com.ffl.playoffs.domain.model.RosterScore;
import com.ffl.playoffs.domain.port.PlayoffScoreRepository;
import com.ffl.playoffs.domain.port.RosterRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Use case for retrieving detailed score breakdown for a player
 * Shows points per NFL player per week
 */
@Service
@RequiredArgsConstructor
public class GetPlayerScoreBreakdownUseCase {

    private final RosterRepository rosterRepository;
    private final PlayoffScoreRepository scoreRepository;

    /**
     * Execute the use case to get player score breakdown
     * @param command the command containing player ID and optional week filter
     * @return the score breakdown result
     */
    public ScoreBreakdownResult execute(GetScoreBreakdownCommand command) {
        // Get all scores for this player
        List<RosterScore> scores;
        if (command.getWeek() != null) {
            PlayoffRound round = PlayoffRound.fromWeekNumber(command.getWeek());
            Optional<RosterScore> scoreOpt = scoreRepository.findByPlayerIdAndRound(command.getPlayerId(), round);
            scores = scoreOpt.map(List::of).orElse(List.of());
        } else {
            scores = scoreRepository.findByPlayerId(command.getPlayerId());
        }

        // Build weekly breakdowns
        List<WeeklyBreakdown> weeklyBreakdowns = new ArrayList<>();
        BigDecimal totalScore = BigDecimal.ZERO;

        for (RosterScore score : scores) {
            List<PlayerScoreDetail> playerDetails = new ArrayList<>();

            if (score.getPositionScores() != null) {
                for (PositionScore posScore : score.getPositionScores()) {
                    PlayerScoreDetail detail = new PlayerScoreDetail(
                            posScore.getPosition(),
                            posScore.getPlayerName(),
                            posScore.getNflTeam(),
                            posScore.getPoints() != null ? posScore.getPoints() : BigDecimal.ZERO,
                            posScore.isOnBye(),
                            posScore.isActive()
                    );
                    playerDetails.add(detail);
                }
            }

            BigDecimal weekTotal = score.getTotalScore() != null ? score.getTotalScore() : BigDecimal.ZERO;
            totalScore = totalScore.add(weekTotal);

            WeeklyBreakdown breakdown = new WeeklyBreakdown(
                    score.getRound().getWeekNumber(),
                    score.getRound(),
                    weekTotal,
                    playerDetails
            );
            weeklyBreakdowns.add(breakdown);
        }

        return new ScoreBreakdownResult(
                command.getLeagueId(),
                command.getPlayerId(),
                totalScore,
                weeklyBreakdowns
        );
    }

    /**
     * Command for getting score breakdown
     */
    public static class GetScoreBreakdownCommand {
        private final UUID leagueId;
        private final UUID playerId;
        private final Integer week;

        public GetScoreBreakdownCommand(UUID leagueId, UUID playerId, Integer week) {
            this.leagueId = leagueId;
            this.playerId = playerId;
            this.week = week;
        }

        public UUID getLeagueId() { return leagueId; }
        public UUID getPlayerId() { return playerId; }
        public Integer getWeek() { return week; }
    }

    /**
     * Result containing score breakdown
     */
    public static class ScoreBreakdownResult {
        private final UUID leagueId;
        private final UUID playerId;
        private final BigDecimal totalScore;
        private final List<WeeklyBreakdown> weeklyBreakdowns;

        public ScoreBreakdownResult(UUID leagueId, UUID playerId, BigDecimal totalScore,
                                    List<WeeklyBreakdown> weeklyBreakdowns) {
            this.leagueId = leagueId;
            this.playerId = playerId;
            this.totalScore = totalScore;
            this.weeklyBreakdowns = weeklyBreakdowns;
        }

        public UUID getLeagueId() { return leagueId; }
        public UUID getPlayerId() { return playerId; }
        public BigDecimal getTotalScore() { return totalScore; }
        public List<WeeklyBreakdown> getWeeklyBreakdowns() { return weeklyBreakdowns; }
    }

    /**
     * Breakdown for a single week
     */
    public static class WeeklyBreakdown {
        private final int week;
        private final PlayoffRound round;
        private final BigDecimal weekTotal;
        private final List<PlayerScoreDetail> playerDetails;

        public WeeklyBreakdown(int week, PlayoffRound round, BigDecimal weekTotal,
                               List<PlayerScoreDetail> playerDetails) {
            this.week = week;
            this.round = round;
            this.weekTotal = weekTotal;
            this.playerDetails = playerDetails;
        }

        public int getWeek() { return week; }
        public PlayoffRound getRound() { return round; }
        public BigDecimal getWeekTotal() { return weekTotal; }
        public List<PlayerScoreDetail> getPlayerDetails() { return playerDetails; }
    }

    /**
     * Score details for an individual NFL player
     */
    public static class PlayerScoreDetail {
        private final Position position;
        private final String playerName;
        private final String teamCode;
        private final BigDecimal points;
        private final boolean onBye;
        private final boolean active;

        public PlayerScoreDetail(Position position, String playerName, String teamCode,
                                 BigDecimal points, boolean onBye, boolean active) {
            this.position = position;
            this.playerName = playerName;
            this.teamCode = teamCode;
            this.points = points;
            this.onBye = onBye;
            this.active = active;
        }

        public Position getPosition() { return position; }
        public String getPlayerName() { return playerName; }
        public String getTeamCode() { return teamCode; }
        public BigDecimal getPoints() { return points; }
        public boolean isOnBye() { return onBye; }
        public boolean isActive() { return active; }
    }
}

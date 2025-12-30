package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.PlayoffBracket;
import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.model.*;
import com.ffl.playoffs.domain.port.*;
import com.ffl.playoffs.domain.service.PlayoffScoringCalculator;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.*;

/**
 * Use case for calculating playoff scores for a player's roster
 * Implements PPR scoring with milestone bonuses and defensive scoring
 */
@Service
@RequiredArgsConstructor
public class CalculatePlayoffScoreUseCase {

    private final PlayoffBracketRepository bracketRepository;
    private final RosterRepository rosterRepository;
    private final PlayoffScoreRepository scoreRepository;
    private final NflDataProvider nflDataProvider;

    /**
     * Execute the use case to calculate scores for a player's roster
     * @param command the command containing player and round information
     * @return the calculated roster score
     */
    public RosterScore execute(CalculatePlayoffScoreCommand command) {
        // Get the playoff bracket
        PlayoffBracket bracket = bracketRepository.findByLeagueId(command.getLeagueId())
            .orElseThrow(() -> new IllegalArgumentException("Playoff bracket not found for league: " + command.getLeagueId()));

        // Validate player is in the bracket and not eliminated
        if (bracket.isPlayerEliminated(command.getLeaguePlayerId())) {
            throw new IllegalStateException("Player is eliminated from playoffs: " + command.getLeaguePlayerId());
        }

        // Get the player's roster
        Roster roster = rosterRepository.findByLeaguePlayerId(command.getLeaguePlayerId())
            .orElseThrow(() -> new IllegalArgumentException("Roster not found for player: " + command.getLeaguePlayerId()));

        // Validate roster is locked
        if (!roster.isLocked()) {
            throw new IllegalStateException("Roster must be locked before calculating scores");
        }

        // Get scoring configuration
        PlayoffScoringCalculator calculator = new PlayoffScoringCalculator(
            command.getScoringConfig() != null
                ? command.getScoringConfig()
                : PPRScoringConfiguration.defaultConfiguration()
        );

        // Calculate scores for each position
        List<PositionScore> positionScores = new ArrayList<>();

        for (RosterSlot slot : roster.getSlots()) {
            PositionScore positionScore = calculatePositionScore(slot, calculator, command.getNflWeek());
            positionScores.add(positionScore);
        }

        // Create the roster score
        PlayoffBracket.PlayerBracketEntry playerEntry = bracket.getPlayerEntries().get(command.getLeaguePlayerId());
        RosterScore rosterScore = new RosterScore(
            command.getLeaguePlayerId(),
            playerEntry.getPlayerName(),
            command.getRound(),
            positionScores
        );

        // Record the score in the bracket
        bracket.recordScore(rosterScore);
        bracketRepository.save(bracket);

        // Save the score
        scoreRepository.save(rosterScore);

        return rosterScore;
    }

    private PositionScore calculatePositionScore(RosterSlot slot, PlayoffScoringCalculator calculator, int nflWeek) {
        if (slot.isEmpty()) {
            return PositionScore.byeWeek(slot.getPosition(), null, "Empty Slot", "N/A");
        }

        Long nflPlayerId = slot.getNflPlayerId();

        // Fetch player stats from NFL data provider
        Map<String, Object> playerData = nflDataProvider.getPlayerStats(nflPlayerId, nflWeek);

        if (playerData == null || playerData.isEmpty()) {
            // Player didn't play or no data available
            String playerName = getPlayerNameFromData(playerData, nflPlayerId);
            String team = getTeamFromData(playerData);

            // Check if player was on bye
            boolean onBye = checkIfOnBye(playerData);
            if (onBye) {
                return PositionScore.byeWeek(slot.getPosition(), nflPlayerId, playerName, team);
            }

            return PositionScore.didNotPlay(slot.getPosition(), nflPlayerId, playerName, team);
        }

        // Build position stats from NFL data
        PositionScore.PositionStats stats = buildPositionStats(playerData);

        // Calculate the score
        BigDecimal points = calculator.calculatePositionScore(slot.getPosition(), stats);

        return new PositionScore(
            slot.getPosition(),
            nflPlayerId,
            getPlayerNameFromData(playerData, nflPlayerId),
            getTeamFromData(playerData),
            points,
            "ACTIVE",
            stats
        );
    }

    private PositionScore.PositionStats buildPositionStats(Map<String, Object> data) {
        return PositionScore.PositionStats.builder()
            .passingYards(getIntValue(data, "passingYards"))
            .passingTouchdowns(getIntValue(data, "passingTouchdowns"))
            .interceptions(getIntValue(data, "interceptions"))
            .rushingYards(getIntValue(data, "rushingYards"))
            .rushingTouchdowns(getIntValue(data, "rushingTouchdowns"))
            .receivingYards(getIntValue(data, "receivingYards"))
            .receivingTouchdowns(getIntValue(data, "receivingTouchdowns"))
            .receptions(getIntValue(data, "receptions"))
            .fumblesLost(getIntValue(data, "fumblesLost"))
            .sacks(getIntValue(data, "sacks"))
            .defensiveInterceptions(getIntValue(data, "defensiveInterceptions"))
            .fumbleRecoveries(getIntValue(data, "fumbleRecoveries"))
            .defensiveTouchdowns(getIntValue(data, "defensiveTouchdowns"))
            .pointsAllowed(getIntValue(data, "pointsAllowed"))
            .fieldGoalsMade0to39(getIntValue(data, "fieldGoalsMade0to39"))
            .fieldGoalsMade40to49(getIntValue(data, "fieldGoalsMade40to49"))
            .fieldGoalsMade50Plus(getIntValue(data, "fieldGoalsMade50Plus"))
            .extraPointsMade(getIntValue(data, "extraPointsMade"))
            .build();
    }

    private Integer getIntValue(Map<String, Object> data, String key) {
        Object value = data.get(key);
        if (value == null) return null;
        if (value instanceof Integer) return (Integer) value;
        if (value instanceof Number) return ((Number) value).intValue();
        return null;
    }

    private String getPlayerNameFromData(Map<String, Object> data, Long playerId) {
        if (data == null) return "Player " + playerId;
        Object name = data.get("playerName");
        return name != null ? name.toString() : "Player " + playerId;
    }

    private String getTeamFromData(Map<String, Object> data) {
        if (data == null) return "N/A";
        Object team = data.get("team");
        return team != null ? team.toString() : "N/A";
    }

    private boolean checkIfOnBye(Map<String, Object> data) {
        if (data == null) return false;
        Object byeWeek = data.get("onBye");
        return Boolean.TRUE.equals(byeWeek);
    }

    /**
     * Command for calculating playoff score
     */
    public static class CalculatePlayoffScoreCommand {
        private final UUID leagueId;
        private final UUID leaguePlayerId;
        private final PlayoffRound round;
        private final int nflWeek;
        private final PPRScoringConfiguration scoringConfig;

        public CalculatePlayoffScoreCommand(UUID leagueId, UUID leaguePlayerId,
                                            PlayoffRound round, int nflWeek) {
            this(leagueId, leaguePlayerId, round, nflWeek, null);
        }

        public CalculatePlayoffScoreCommand(UUID leagueId, UUID leaguePlayerId,
                                            PlayoffRound round, int nflWeek,
                                            PPRScoringConfiguration scoringConfig) {
            this.leagueId = leagueId;
            this.leaguePlayerId = leaguePlayerId;
            this.round = round;
            this.nflWeek = nflWeek;
            this.scoringConfig = scoringConfig;
        }

        public UUID getLeagueId() { return leagueId; }
        public UUID getLeaguePlayerId() { return leaguePlayerId; }
        public PlayoffRound getRound() { return round; }
        public int getNflWeek() { return nflWeek; }
        public PPRScoringConfiguration getScoringConfig() { return scoringConfig; }
    }
}

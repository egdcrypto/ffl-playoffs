package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.PlayoffBracket;
import com.ffl.playoffs.domain.aggregate.PlayoffMatchup;
import com.ffl.playoffs.domain.model.*;
import com.ffl.playoffs.domain.port.PlayoffBracketRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Use case for getting detailed matchup information
 * Provides head-to-head comparison data for display
 */
@Service
@RequiredArgsConstructor
public class GetMatchupDetailsUseCase {

    private final PlayoffBracketRepository bracketRepository;

    /**
     * Execute the use case to get matchup details
     * @param command the command containing matchup identifiers
     * @return the matchup details
     */
    public MatchupDetailsResult execute(GetMatchupDetailsCommand command) {
        // Get the playoff bracket
        PlayoffBracket bracket = bracketRepository.findByLeagueId(command.getLeagueId())
            .orElseThrow(() -> new IllegalArgumentException("Playoff bracket not found for league: " + command.getLeagueId()));

        // Find the matchup
        Optional<PlayoffMatchup> matchupOpt;
        if (command.getMatchupId() != null) {
            matchupOpt = bracket.getMatchupsForRound(command.getRound()).stream()
                .filter(m -> m.getId().equals(command.getMatchupId()))
                .findFirst();
        } else if (command.getPlayerId() != null) {
            matchupOpt = bracket.findMatchupForPlayer(command.getPlayerId(), command.getRound());
        } else {
            throw new IllegalArgumentException("Either matchupId or playerId must be provided");
        }

        PlayoffMatchup matchup = matchupOpt
            .orElseThrow(() -> new IllegalArgumentException("Matchup not found"));

        // Build the comparison data
        List<PositionComparison> positionComparisons = buildPositionComparisons(matchup);

        return new MatchupDetailsResult(
            matchup.getId(),
            command.getRound(),
            matchup.getStatus(),
            buildPlayerDetails(matchup, true),
            buildPlayerDetails(matchup, false),
            positionComparisons,
            matchup.getWinnerId(),
            matchup.getLoserId(),
            matchup.getMarginOfVictory(),
            matchup.isUpset(),
            matchup.getTiebreakerResult()
        );
    }

    private PlayerMatchupDetails buildPlayerDetails(PlayoffMatchup matchup, boolean isPlayer1) {
        UUID playerId = isPlayer1 ? matchup.getPlayer1Id() : matchup.getPlayer2Id();
        String playerName = isPlayer1 ? matchup.getPlayer1Name() : matchup.getPlayer2Name();
        int seed = isPlayer1 ? matchup.getPlayer1Seed() : matchup.getPlayer2Seed();
        RosterScore score = isPlayer1 ? matchup.getPlayer1Score() : matchup.getPlayer2Score();

        BigDecimal totalScore = score != null ? score.getTotalScore() : null;
        int playersRemaining = 0;
        boolean isComplete = false;

        if (score != null) {
            isComplete = score.isComplete();
            playersRemaining = (int) score.getPositionScores().stream()
                .filter(ps -> !ps.isActive() || !ps.isOnBye())
                .count();
        }

        return new PlayerMatchupDetails(
            playerId,
            playerName,
            seed,
            totalScore,
            playersRemaining,
            isComplete
        );
    }

    private List<PositionComparison> buildPositionComparisons(PlayoffMatchup matchup) {
        List<PositionComparison> comparisons = new ArrayList<>();

        RosterScore score1 = matchup.getPlayer1Score();
        RosterScore score2 = matchup.getPlayer2Score();

        if (score1 == null || score2 == null) {
            return comparisons;
        }

        // Match positions between the two rosters
        List<PositionScore> positions1 = score1.getPositionScores();
        List<PositionScore> positions2 = score2.getPositionScores();

        // Simple position-by-position comparison
        for (int i = 0; i < Math.min(positions1.size(), positions2.size()); i++) {
            PositionScore pos1 = positions1.get(i);
            PositionScore pos2 = positions2.get(i);

            comparisons.add(new PositionComparison(
                pos1.getPosition(),
                pos1.getPlayerName(),
                pos1.getPoints(),
                pos2.getPlayerName(),
                pos2.getPoints()
            ));
        }

        return comparisons;
    }

    /**
     * Command for getting matchup details
     */
    public static class GetMatchupDetailsCommand {
        private final UUID leagueId;
        private final PlayoffRound round;
        private final UUID matchupId;
        private final UUID playerId;

        public GetMatchupDetailsCommand(UUID leagueId, PlayoffRound round, UUID matchupId) {
            this(leagueId, round, matchupId, null);
        }

        public GetMatchupDetailsCommand(UUID leagueId, PlayoffRound round, UUID matchupId, UUID playerId) {
            this.leagueId = leagueId;
            this.round = round;
            this.matchupId = matchupId;
            this.playerId = playerId;
        }

        public static GetMatchupDetailsCommand forPlayer(UUID leagueId, PlayoffRound round, UUID playerId) {
            return new GetMatchupDetailsCommand(leagueId, round, null, playerId);
        }

        public UUID getLeagueId() { return leagueId; }
        public PlayoffRound getRound() { return round; }
        public UUID getMatchupId() { return matchupId; }
        public UUID getPlayerId() { return playerId; }
    }

    /**
     * Result containing matchup details
     */
    public static class MatchupDetailsResult {
        private final UUID matchupId;
        private final PlayoffRound round;
        private final MatchupStatus status;
        private final PlayerMatchupDetails player1;
        private final PlayerMatchupDetails player2;
        private final List<PositionComparison> positionComparisons;
        private final UUID winnerId;
        private final UUID loserId;
        private final BigDecimal marginOfVictory;
        private final boolean isUpset;
        private final TiebreakerResult tiebreakerResult;

        public MatchupDetailsResult(UUID matchupId, PlayoffRound round, MatchupStatus status,
                                    PlayerMatchupDetails player1, PlayerMatchupDetails player2,
                                    List<PositionComparison> positionComparisons,
                                    UUID winnerId, UUID loserId, BigDecimal marginOfVictory,
                                    boolean isUpset, TiebreakerResult tiebreakerResult) {
            this.matchupId = matchupId;
            this.round = round;
            this.status = status;
            this.player1 = player1;
            this.player2 = player2;
            this.positionComparisons = positionComparisons;
            this.winnerId = winnerId;
            this.loserId = loserId;
            this.marginOfVictory = marginOfVictory;
            this.isUpset = isUpset;
            this.tiebreakerResult = tiebreakerResult;
        }

        // Getters
        public UUID getMatchupId() { return matchupId; }
        public PlayoffRound getRound() { return round; }
        public MatchupStatus getStatus() { return status; }
        public PlayerMatchupDetails getPlayer1() { return player1; }
        public PlayerMatchupDetails getPlayer2() { return player2; }
        public List<PositionComparison> getPositionComparisons() { return positionComparisons; }
        public UUID getWinnerId() { return winnerId; }
        public UUID getLoserId() { return loserId; }
        public BigDecimal getMarginOfVictory() { return marginOfVictory; }
        public boolean isUpset() { return isUpset; }
        public TiebreakerResult getTiebreakerResult() { return tiebreakerResult; }
    }

    /**
     * Details for a player in a matchup
     */
    public static class PlayerMatchupDetails {
        private final UUID playerId;
        private final String playerName;
        private final int seed;
        private final BigDecimal totalScore;
        private final int playersRemaining;
        private final boolean isComplete;

        public PlayerMatchupDetails(UUID playerId, String playerName, int seed,
                                    BigDecimal totalScore, int playersRemaining, boolean isComplete) {
            this.playerId = playerId;
            this.playerName = playerName;
            this.seed = seed;
            this.totalScore = totalScore;
            this.playersRemaining = playersRemaining;
            this.isComplete = isComplete;
        }

        public UUID getPlayerId() { return playerId; }
        public String getPlayerName() { return playerName; }
        public int getSeed() { return seed; }
        public BigDecimal getTotalScore() { return totalScore; }
        public int getPlayersRemaining() { return playersRemaining; }
        public boolean isComplete() { return isComplete; }
    }

    /**
     * Position-by-position comparison
     */
    public static class PositionComparison {
        private final Position position;
        private final String player1Name;
        private final BigDecimal player1Points;
        private final String player2Name;
        private final BigDecimal player2Points;

        public PositionComparison(Position position, String player1Name, BigDecimal player1Points,
                                  String player2Name, BigDecimal player2Points) {
            this.position = position;
            this.player1Name = player1Name;
            this.player1Points = player1Points;
            this.player2Name = player2Name;
            this.player2Points = player2Points;
        }

        public Position getPosition() { return position; }
        public String getPlayer1Name() { return player1Name; }
        public BigDecimal getPlayer1Points() { return player1Points; }
        public String getPlayer2Name() { return player2Name; }
        public BigDecimal getPlayer2Points() { return player2Points; }
    }
}

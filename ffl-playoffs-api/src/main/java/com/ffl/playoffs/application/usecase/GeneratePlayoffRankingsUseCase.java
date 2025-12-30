package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.PlayoffBracket;
import com.ffl.playoffs.domain.model.PlayoffRanking;
import com.ffl.playoffs.domain.model.PlayoffRound;
import com.ffl.playoffs.domain.port.PlayoffBracketRepository;
import com.ffl.playoffs.domain.port.PlayoffRankingRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

/**
 * Use case for generating playoff rankings
 * Supports both weekly and cumulative rankings
 */
@Service
@RequiredArgsConstructor
public class GeneratePlayoffRankingsUseCase {

    private final PlayoffBracketRepository bracketRepository;
    private final PlayoffRankingRepository rankingRepository;

    /**
     * Execute the use case to generate rankings for a round
     * @param command the command containing league and round information
     * @return the generated rankings
     */
    public GenerateRankingsResult execute(GenerateRankingsCommand command) {
        // Get the playoff bracket
        PlayoffBracket bracket = bracketRepository.findByLeagueId(command.getLeagueId())
            .orElseThrow(() -> new IllegalArgumentException("Playoff bracket not found for league: " + command.getLeagueId()));

        // Calculate rankings
        List<PlayoffRanking> rankings = bracket.calculateRankings(
            command.getRound(),
            command.isCumulative()
        );

        // Save rankings
        rankingRepository.saveAll(rankings);

        // Save updated bracket
        bracketRepository.save(bracket);

        return new GenerateRankingsResult(
            command.getLeagueId(),
            command.getRound(),
            command.isCumulative(),
            rankings
        );
    }

    /**
     * Get current rankings without recalculating
     * @param command the command containing league and round information
     * @return existing rankings
     */
    public List<PlayoffRanking> getCurrentRankings(GenerateRankingsCommand command) {
        return rankingRepository.findByLeagueIdAndRound(
            command.getLeagueId(),
            command.getRound(),
            command.isCumulative()
        );
    }

    /**
     * Get ranking history for a specific player
     * @param leaguePlayerId the player's league ID
     * @return list of rankings across rounds
     */
    public List<PlayoffRanking> getPlayerRankingHistory(UUID leaguePlayerId) {
        return rankingRepository.findByPlayerId(leaguePlayerId);
    }

    /**
     * Command for generating rankings
     */
    public static class GenerateRankingsCommand {
        private final UUID leagueId;
        private final PlayoffRound round;
        private final boolean cumulative;

        public GenerateRankingsCommand(UUID leagueId, PlayoffRound round, boolean cumulative) {
            this.leagueId = leagueId;
            this.round = round;
            this.cumulative = cumulative;
        }

        public UUID getLeagueId() { return leagueId; }
        public PlayoffRound getRound() { return round; }
        public boolean isCumulative() { return cumulative; }
    }

    /**
     * Result of generating rankings
     */
    public static class GenerateRankingsResult {
        private final UUID leagueId;
        private final PlayoffRound round;
        private final boolean cumulative;
        private final List<PlayoffRanking> rankings;

        public GenerateRankingsResult(UUID leagueId, PlayoffRound round,
                                      boolean cumulative, List<PlayoffRanking> rankings) {
            this.leagueId = leagueId;
            this.round = round;
            this.cumulative = cumulative;
            this.rankings = rankings;
        }

        public UUID getLeagueId() { return leagueId; }
        public PlayoffRound getRound() { return round; }
        public boolean isCumulative() { return cumulative; }
        public List<PlayoffRanking> getRankings() { return rankings; }
    }
}

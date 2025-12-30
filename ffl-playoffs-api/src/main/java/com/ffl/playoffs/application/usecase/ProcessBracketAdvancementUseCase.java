package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.PlayoffBracket;
import com.ffl.playoffs.domain.aggregate.PlayoffMatchup;
import com.ffl.playoffs.domain.model.MatchupStatus;
import com.ffl.playoffs.domain.model.PlayoffRound;
import com.ffl.playoffs.domain.model.TiebreakerResult;
import com.ffl.playoffs.domain.port.PlayoffBracketRepository;
import com.ffl.playoffs.domain.service.TiebreakerResolver;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Use case for processing bracket advancement after a playoff round completes
 * Determines winners, handles tiebreakers, eliminates losers, and advances winners
 */
@Service
@RequiredArgsConstructor
public class ProcessBracketAdvancementUseCase {

    private final PlayoffBracketRepository bracketRepository;

    /**
     * Execute the use case to process round results and advance the bracket
     * @param command the command containing league and round information
     * @return the result containing eliminated players and advancement info
     */
    public ProcessBracketAdvancementResult execute(ProcessBracketAdvancementCommand command) {
        // Get the playoff bracket
        PlayoffBracket bracket = bracketRepository.findByLeagueId(command.getLeagueId())
            .orElseThrow(() -> new IllegalArgumentException("Playoff bracket not found for league: " + command.getLeagueId()));

        // Get matchups for the round
        List<PlayoffMatchup> matchups = bracket.getMatchupsForRound(command.getRound());
        if (matchups.isEmpty()) {
            throw new IllegalStateException("No matchups found for round: " + command.getRound());
        }

        // Create tiebreaker resolver
        TiebreakerResolver tiebreakerResolver = new TiebreakerResolver(bracket.getTiebreakerConfiguration());

        List<UUID> eliminatedPlayers = new ArrayList<>();
        List<UUID> advancingPlayers = new ArrayList<>();
        List<MatchupResult> matchupResults = new ArrayList<>();

        // Process each matchup
        for (PlayoffMatchup matchup : matchups) {
            if (matchup.getStatus() == MatchupStatus.COMPLETED) {
                // Already processed
                if (matchup.getLoserId() != null) {
                    eliminatedPlayers.add(matchup.getLoserId());
                }
                if (matchup.getWinnerId() != null) {
                    advancingPlayers.add(matchup.getWinnerId());
                }
                continue;
            }

            // Check if matchup is ready to process
            if (!matchup.isReadyForResult()) {
                continue;
            }

            // Try to determine winner by score
            boolean winnerDetermined = matchup.determineWinner();

            if (!winnerDetermined && matchup.getStatus() == MatchupStatus.TIED) {
                // Need tiebreaker resolution
                TiebreakerResult tiebreakerResult = tiebreakerResolver.resolveTie(
                    matchup.getPlayer1Score(),
                    matchup.getPlayer2Score(),
                    matchup.getPlayer1Seed(),
                    matchup.getPlayer2Seed()
                );

                matchup.applyTiebreakerResult(tiebreakerResult);
            }

            // Record the result
            if (matchup.getStatus() == MatchupStatus.COMPLETED) {
                if (matchup.getLoserId() != null) {
                    eliminatedPlayers.add(matchup.getLoserId());
                }
                if (matchup.getWinnerId() != null) {
                    advancingPlayers.add(matchup.getWinnerId());
                }

                matchupResults.add(new MatchupResult(
                    matchup.getId(),
                    matchup.getWinnerId(),
                    matchup.getLoserId(),
                    matchup.getMarginOfVictory(),
                    matchup.isUpset(),
                    matchup.getTiebreakerResult()
                ));
            }
        }

        // Process round results to update bracket state
        bracket.processRoundResults(command.getRound());

        // Save the updated bracket
        bracketRepository.save(bracket);

        return new ProcessBracketAdvancementResult(
            command.getLeagueId(),
            command.getRound(),
            eliminatedPlayers,
            advancingPlayers,
            matchupResults,
            bracket.isComplete()
        );
    }

    /**
     * Command for processing bracket advancement
     */
    public static class ProcessBracketAdvancementCommand {
        private final UUID leagueId;
        private final PlayoffRound round;

        public ProcessBracketAdvancementCommand(UUID leagueId, PlayoffRound round) {
            this.leagueId = leagueId;
            this.round = round;
        }

        public UUID getLeagueId() { return leagueId; }
        public PlayoffRound getRound() { return round; }
    }

    /**
     * Result of processing bracket advancement
     */
    public static class ProcessBracketAdvancementResult {
        private final UUID leagueId;
        private final PlayoffRound round;
        private final List<UUID> eliminatedPlayers;
        private final List<UUID> advancingPlayers;
        private final List<MatchupResult> matchupResults;
        private final boolean playoffsComplete;

        public ProcessBracketAdvancementResult(UUID leagueId, PlayoffRound round,
                                               List<UUID> eliminatedPlayers, List<UUID> advancingPlayers,
                                               List<MatchupResult> matchupResults, boolean playoffsComplete) {
            this.leagueId = leagueId;
            this.round = round;
            this.eliminatedPlayers = eliminatedPlayers;
            this.advancingPlayers = advancingPlayers;
            this.matchupResults = matchupResults;
            this.playoffsComplete = playoffsComplete;
        }

        public UUID getLeagueId() { return leagueId; }
        public PlayoffRound getRound() { return round; }
        public List<UUID> getEliminatedPlayers() { return eliminatedPlayers; }
        public List<UUID> getAdvancingPlayers() { return advancingPlayers; }
        public List<MatchupResult> getMatchupResults() { return matchupResults; }
        public boolean isPlayoffsComplete() { return playoffsComplete; }
    }

    /**
     * Individual matchup result
     */
    public static class MatchupResult {
        private final UUID matchupId;
        private final UUID winnerId;
        private final UUID loserId;
        private final java.math.BigDecimal marginOfVictory;
        private final boolean isUpset;
        private final TiebreakerResult tiebreakerResult;

        public MatchupResult(UUID matchupId, UUID winnerId, UUID loserId,
                             java.math.BigDecimal marginOfVictory, boolean isUpset,
                             TiebreakerResult tiebreakerResult) {
            this.matchupId = matchupId;
            this.winnerId = winnerId;
            this.loserId = loserId;
            this.marginOfVictory = marginOfVictory;
            this.isUpset = isUpset;
            this.tiebreakerResult = tiebreakerResult;
        }

        public UUID getMatchupId() { return matchupId; }
        public UUID getWinnerId() { return winnerId; }
        public UUID getLoserId() { return loserId; }
        public java.math.BigDecimal getMarginOfVictory() { return marginOfVictory; }
        public boolean isUpset() { return isUpset; }
        public TiebreakerResult getTiebreakerResult() { return tiebreakerResult; }
    }
}

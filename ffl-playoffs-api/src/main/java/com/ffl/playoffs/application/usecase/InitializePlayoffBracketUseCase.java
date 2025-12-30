package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.PlayoffBracket;
import com.ffl.playoffs.domain.model.TiebreakerConfiguration;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.PlayoffBracketRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;

/**
 * Use case for initializing a playoff bracket for a league
 * Creates the bracket structure and seeds players based on regular season performance
 */
@Service
@RequiredArgsConstructor
public class InitializePlayoffBracketUseCase {

    private final PlayoffBracketRepository bracketRepository;
    private final LeagueRepository leagueRepository;
    private final LeaguePlayerRepository leaguePlayerRepository;

    /**
     * Execute the use case to initialize a playoff bracket
     * @param command the command containing league ID and player seeding
     * @return the created playoff bracket
     */
    public PlayoffBracket execute(InitializePlayoffBracketCommand command) {
        // Validate league exists
        var league = leagueRepository.findById(command.getLeagueId())
            .orElseThrow(() -> new IllegalArgumentException("League not found: " + command.getLeagueId()));

        // Check if bracket already exists
        if (bracketRepository.existsByLeagueId(command.getLeagueId())) {
            throw new IllegalStateException("Playoff bracket already exists for league: " + command.getLeagueId());
        }

        // Create the bracket
        PlayoffBracket bracket = new PlayoffBracket(command.getLeagueId(), league.getName());

        // Set custom tiebreaker configuration if provided
        if (command.getTiebreakerConfiguration() != null) {
            bracket.setTiebreakerConfiguration(command.getTiebreakerConfiguration());
        }

        // Add players with seeding
        List<PlayerSeed> sortedPlayers = command.getPlayerSeedings().stream()
            .sorted(Comparator.comparingInt(PlayerSeed::getSeed))
            .toList();

        for (PlayerSeed playerSeed : sortedPlayers) {
            bracket.addPlayer(
                playerSeed.getPlayerId(),
                playerSeed.getPlayerName(),
                playerSeed.getSeed(),
                playerSeed.getRegularSeasonScore()
            );
        }

        // Generate the bracket matchups
        bracket.generateBracket();

        // Save and return
        return bracketRepository.save(bracket);
    }

    /**
     * Command for initializing a playoff bracket
     */
    public static class InitializePlayoffBracketCommand {
        private final UUID leagueId;
        private final List<PlayerSeed> playerSeedings;
        private final TiebreakerConfiguration tiebreakerConfiguration;

        public InitializePlayoffBracketCommand(UUID leagueId, List<PlayerSeed> playerSeedings) {
            this(leagueId, playerSeedings, null);
        }

        public InitializePlayoffBracketCommand(UUID leagueId, List<PlayerSeed> playerSeedings,
                                               TiebreakerConfiguration tiebreakerConfiguration) {
            this.leagueId = leagueId;
            this.playerSeedings = playerSeedings;
            this.tiebreakerConfiguration = tiebreakerConfiguration;
        }

        public UUID getLeagueId() { return leagueId; }
        public List<PlayerSeed> getPlayerSeedings() { return playerSeedings; }
        public TiebreakerConfiguration getTiebreakerConfiguration() { return tiebreakerConfiguration; }
    }

    /**
     * Player seed information
     */
    public static class PlayerSeed {
        private final UUID playerId;
        private final String playerName;
        private final int seed;
        private final BigDecimal regularSeasonScore;

        public PlayerSeed(UUID playerId, String playerName, int seed, BigDecimal regularSeasonScore) {
            this.playerId = playerId;
            this.playerName = playerName;
            this.seed = seed;
            this.regularSeasonScore = regularSeasonScore;
        }

        public UUID getPlayerId() { return playerId; }
        public String getPlayerName() { return playerName; }
        public int getSeed() { return seed; }
        public BigDecimal getRegularSeasonScore() { return regularSeasonScore; }
    }
}

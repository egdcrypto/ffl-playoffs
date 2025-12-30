package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.MatchupStatus;
import com.ffl.playoffs.domain.model.PlayerPlayoffStatus;
import com.ffl.playoffs.domain.model.PlayoffRanking;
import com.ffl.playoffs.domain.model.PlayoffRound;
import com.ffl.playoffs.domain.model.RosterScore;
import com.ffl.playoffs.domain.model.TiebreakerConfiguration;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Aggregate root for the Playoff Bracket
 * Manages all matchups, scores, rankings, and bracket progression
 */
public class PlayoffBracket {
    private UUID id;
    private UUID leagueId;
    private String leagueName;
    private PlayoffRound currentRound;
    private int totalPlayers;
    private TiebreakerConfiguration tiebreakerConfiguration;

    // Player tracking
    private Map<UUID, PlayerBracketEntry> playerEntries;

    // Matchups by round
    private Map<PlayoffRound, List<PlayoffMatchup>> matchupsByRound;

    // Scores by round
    private Map<PlayoffRound, List<RosterScore>> scoresByRound;

    // Rankings by round
    private Map<PlayoffRound, List<PlayoffRanking>> rankingsByRound;

    // Cumulative scores
    private Map<UUID, BigDecimal> cumulativeScores;

    // Metadata
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean isComplete;

    public PlayoffBracket() {
        this.id = UUID.randomUUID();
        this.currentRound = PlayoffRound.WILD_CARD;
        this.playerEntries = new HashMap<>();
        this.matchupsByRound = new HashMap<>();
        this.scoresByRound = new HashMap<>();
        this.rankingsByRound = new HashMap<>();
        this.cumulativeScores = new HashMap<>();
        this.tiebreakerConfiguration = TiebreakerConfiguration.defaultConfiguration();
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        this.isComplete = false;

        // Initialize empty matchup lists for each round
        for (PlayoffRound round : PlayoffRound.values()) {
            matchupsByRound.put(round, new ArrayList<>());
            scoresByRound.put(round, new ArrayList<>());
            rankingsByRound.put(round, new ArrayList<>());
        }
    }

    public PlayoffBracket(UUID leagueId, String leagueName) {
        this();
        this.leagueId = leagueId;
        this.leagueName = leagueName;
    }

    // ==================== Player Entry Management ====================

    /**
     * Add a player to the bracket with their seed
     */
    public void addPlayer(UUID playerId, String playerName, int seed, BigDecimal regularSeasonScore) {
        if (playerEntries.containsKey(playerId)) {
            throw new IllegalArgumentException("Player already in bracket: " + playerId);
        }

        PlayerBracketEntry entry = new PlayerBracketEntry(
            playerId, playerName, seed, regularSeasonScore,
            PlayerPlayoffStatus.ACTIVE, PlayoffRound.WILD_CARD
        );
        playerEntries.put(playerId, entry);
        cumulativeScores.put(playerId, BigDecimal.ZERO);
        this.totalPlayers = playerEntries.size();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Get all active players
     */
    public List<PlayerBracketEntry> getActivePlayers() {
        return playerEntries.values().stream()
            .filter(e -> e.getStatus().isCompeting())
            .collect(Collectors.toList());
    }

    /**
     * Get eliminated players
     */
    public List<PlayerBracketEntry> getEliminatedPlayers() {
        return playerEntries.values().stream()
            .filter(e -> e.getStatus() == PlayerPlayoffStatus.ELIMINATED)
            .collect(Collectors.toList());
    }

    // ==================== Bracket Generation ====================

    /**
     * Generate the playoff bracket matchups based on seeding
     * Higher seeds play lower seeds (1v8, 2v7, 3v6, 4v5)
     */
    public void generateBracket() {
        if (playerEntries.isEmpty()) {
            throw new IllegalStateException("Cannot generate bracket without players");
        }

        List<PlayerBracketEntry> sortedPlayers = playerEntries.values().stream()
            .sorted(Comparator.comparingInt(PlayerBracketEntry::getSeed))
            .collect(Collectors.toList());

        int numPlayers = sortedPlayers.size();
        int numMatchups = numPlayers / 2;

        List<PlayoffMatchup> wildCardMatchups = new ArrayList<>();

        for (int i = 0; i < numMatchups; i++) {
            PlayerBracketEntry higherSeed = sortedPlayers.get(i);
            PlayerBracketEntry lowerSeed = sortedPlayers.get(numPlayers - 1 - i);

            PlayoffMatchup matchup = new PlayoffMatchup(this.id, PlayoffRound.WILD_CARD, i + 1);
            matchup.setPlayer1(higherSeed.getPlayerId(), higherSeed.getPlayerName(), higherSeed.getSeed());
            matchup.setPlayer2(lowerSeed.getPlayerId(), lowerSeed.getPlayerName(), lowerSeed.getSeed());
            wildCardMatchups.add(matchup);
        }

        matchupsByRound.put(PlayoffRound.WILD_CARD, wildCardMatchups);
        this.updatedAt = LocalDateTime.now();
    }

    // ==================== Scoring ====================

    /**
     * Record a roster score for a player in a round
     */
    public void recordScore(RosterScore score) {
        PlayoffRound round = score.getRound();
        List<RosterScore> roundScores = scoresByRound.get(round);

        // Remove existing score for this player if present
        roundScores.removeIf(s -> s.getLeaguePlayerId().equals(score.getLeaguePlayerId()));
        roundScores.add(score);

        // Update cumulative score
        BigDecimal currentCumulative = cumulativeScores.getOrDefault(score.getLeaguePlayerId(), BigDecimal.ZERO);
        cumulativeScores.put(score.getLeaguePlayerId(), currentCumulative.add(score.getTotalScore()));

        // Update matchup if applicable
        updateMatchupScore(round, score);

        this.updatedAt = LocalDateTime.now();
    }

    private void updateMatchupScore(PlayoffRound round, RosterScore score) {
        List<PlayoffMatchup> roundMatchups = matchupsByRound.get(round);
        for (PlayoffMatchup matchup : roundMatchups) {
            if (matchup.hasPlayer(score.getLeaguePlayerId())) {
                if (matchup.getPlayer1Id().equals(score.getLeaguePlayerId())) {
                    matchup.updatePlayer1Score(score);
                } else {
                    matchup.updatePlayer2Score(score);
                }
                break;
            }
        }
    }

    // ==================== Rankings ====================

    /**
     * Calculate and store rankings for a round
     */
    public List<PlayoffRanking> calculateRankings(PlayoffRound round, boolean cumulative) {
        List<RosterScore> scores;
        Map<UUID, BigDecimal> scoreMap = new HashMap<>();

        if (cumulative) {
            scoreMap.putAll(cumulativeScores);
        } else {
            scores = scoresByRound.get(round);
            for (RosterScore score : scores) {
                scoreMap.put(score.getLeaguePlayerId(), score.getTotalScore());
            }
        }

        // Get previous rankings for rank change calculation
        Map<UUID, Integer> previousRanks = new HashMap<>();
        if (round != PlayoffRound.WILD_CARD) {
            PlayoffRound prevRound = getPreviousRound(round);
            List<PlayoffRanking> prevRankings = rankingsByRound.get(prevRound);
            for (PlayoffRanking ranking : prevRankings) {
                previousRanks.put(ranking.getLeaguePlayerId(), ranking.getRank());
            }
        }

        // Sort by score descending
        List<Map.Entry<UUID, BigDecimal>> sortedScores = scoreMap.entrySet().stream()
            .sorted(Map.Entry.<UUID, BigDecimal>comparingByValue().reversed())
            .collect(Collectors.toList());

        List<PlayoffRanking> rankings = new ArrayList<>();
        int rank = 1;
        BigDecimal previousScore = null;
        int sameRankCount = 0;

        for (Map.Entry<UUID, BigDecimal> entry : sortedScores) {
            UUID playerId = entry.getKey();
            BigDecimal score = entry.getValue();
            PlayerBracketEntry playerEntry = playerEntries.get(playerId);

            // Handle ties - same score gets same rank
            if (previousScore != null && score.compareTo(previousScore) == 0) {
                sameRankCount++;
            } else {
                rank += sameRankCount;
                sameRankCount = 1;
            }

            PlayoffRanking ranking = PlayoffRanking.builder()
                .leaguePlayerId(playerId)
                .playerName(playerEntry.getPlayerName())
                .rank(rank)
                .previousRank(previousRanks.getOrDefault(playerId, 0))
                .score(score)
                .round(round)
                .isCumulative(cumulative)
                .roundsSurvived(getRoundsSurvived(playerId))
                .status(playerEntry.getStatus())
                .build();

            rankings.add(ranking);
            previousScore = score;
        }

        if (!cumulative) {
            rankingsByRound.put(round, rankings);
        }

        this.updatedAt = LocalDateTime.now();
        return rankings;
    }

    private int getRoundsSurvived(UUID playerId) {
        PlayerBracketEntry entry = playerEntries.get(playerId);
        if (entry == null) return 0;
        return entry.getEliminatedInRound() != null
            ? entry.getEliminatedInRound().getWeekNumber() - 1
            : currentRound.getWeekNumber();
    }

    private PlayoffRound getPreviousRound(PlayoffRound round) {
        return switch (round) {
            case DIVISIONAL -> PlayoffRound.WILD_CARD;
            case CONFERENCE -> PlayoffRound.DIVISIONAL;
            case SUPER_BOWL -> PlayoffRound.CONFERENCE;
            default -> null;
        };
    }

    // ==================== Bracket Progression ====================

    /**
     * Process matchup results for a round and advance winners
     */
    public List<UUID> processRoundResults(PlayoffRound round) {
        List<PlayoffMatchup> matchups = matchupsByRound.get(round);
        List<UUID> eliminatedPlayers = new ArrayList<>();

        for (PlayoffMatchup matchup : matchups) {
            if (matchup.getStatus() != MatchupStatus.COMPLETED) {
                // Try to determine winner
                if (matchup.isReadyForResult()) {
                    matchup.determineWinner();
                }
            }

            if (matchup.getStatus() == MatchupStatus.COMPLETED && matchup.getLoserId() != null) {
                UUID loserId = matchup.getLoserId();
                PlayerBracketEntry loserEntry = playerEntries.get(loserId);
                loserEntry.eliminate(round, matchup.getWinnerId());
                eliminatedPlayers.add(loserId);
            }
        }

        // If all matchups complete, advance to next round
        if (allMatchupsComplete(round) && !round.isFinalRound()) {
            advanceToNextRound(round);
        } else if (round.isFinalRound() && allMatchupsComplete(round)) {
            // Championship complete
            declareChampion();
        }

        this.updatedAt = LocalDateTime.now();
        return eliminatedPlayers;
    }

    private boolean allMatchupsComplete(PlayoffRound round) {
        return matchupsByRound.get(round).stream()
            .allMatch(m -> m.getStatus() == MatchupStatus.COMPLETED);
    }

    private void advanceToNextRound(PlayoffRound completedRound) {
        PlayoffRound nextRound = completedRound.getNextRound();
        if (nextRound == null) return;

        List<PlayoffMatchup> completedMatchups = matchupsByRound.get(completedRound);
        List<UUID> winners = completedMatchups.stream()
            .map(PlayoffMatchup::getWinnerId)
            .collect(Collectors.toList());

        // Get winner entries sorted by original seed
        List<PlayerBracketEntry> winnerEntries = winners.stream()
            .map(playerEntries::get)
            .sorted(Comparator.comparingInt(PlayerBracketEntry::getSeed))
            .collect(Collectors.toList());

        // Create next round matchups
        List<PlayoffMatchup> nextMatchups = new ArrayList<>();
        int numMatchups = winnerEntries.size() / 2;

        for (int i = 0; i < numMatchups; i++) {
            PlayerBracketEntry higherSeed = winnerEntries.get(i);
            PlayerBracketEntry lowerSeed = winnerEntries.get(winnerEntries.size() - 1 - i);

            PlayoffMatchup matchup = new PlayoffMatchup(this.id, nextRound, i + 1);
            matchup.setPlayer1(higherSeed.getPlayerId(), higherSeed.getPlayerName(), higherSeed.getSeed());
            matchup.setPlayer2(lowerSeed.getPlayerId(), lowerSeed.getPlayerName(), lowerSeed.getSeed());
            nextMatchups.add(matchup);
        }

        matchupsByRound.put(nextRound, nextMatchups);
        this.currentRound = nextRound;
    }

    private void declareChampion() {
        List<PlayoffMatchup> finalMatchups = matchupsByRound.get(PlayoffRound.SUPER_BOWL);
        if (!finalMatchups.isEmpty()) {
            PlayoffMatchup championship = finalMatchups.get(0);
            UUID winnerId = championship.getWinnerId();

            if (winnerId != null) {
                PlayerBracketEntry champion = playerEntries.get(winnerId);
                champion.setStatus(PlayerPlayoffStatus.CHAMPION);
            } else if (championship.getTiebreakerResult() != null
                && championship.getTiebreakerResult().getMethodUsed() == com.ffl.playoffs.domain.model.TiebreakerMethod.CO_WINNERS) {
                // Co-champions
                playerEntries.get(championship.getPlayer1Id()).setStatus(PlayerPlayoffStatus.CO_CHAMPION);
                playerEntries.get(championship.getPlayer2Id()).setStatus(PlayerPlayoffStatus.CO_CHAMPION);
            }
        }

        this.isComplete = true;
        this.updatedAt = LocalDateTime.now();
    }

    // ==================== Elimination Tracking ====================

    /**
     * Check if a player is eliminated
     */
    public boolean isPlayerEliminated(UUID playerId) {
        PlayerBracketEntry entry = playerEntries.get(playerId);
        return entry != null && entry.getStatus() == PlayerPlayoffStatus.ELIMINATED;
    }

    /**
     * Get elimination summary by round
     */
    public Map<PlayoffRound, Integer> getEliminationSummary() {
        Map<PlayoffRound, Integer> summary = new HashMap<>();
        for (PlayoffRound round : PlayoffRound.values()) {
            int eliminated = (int) playerEntries.values().stream()
                .filter(e -> e.getEliminatedInRound() == round)
                .count();
            summary.put(round, eliminated);
        }
        return summary;
    }

    // ==================== Getters ====================

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }
    public UUID getLeagueId() { return leagueId; }
    public void setLeagueId(UUID leagueId) { this.leagueId = leagueId; }
    public String getLeagueName() { return leagueName; }
    public void setLeagueName(String leagueName) { this.leagueName = leagueName; }
    public PlayoffRound getCurrentRound() { return currentRound; }
    public void setCurrentRound(PlayoffRound currentRound) { this.currentRound = currentRound; }
    public int getTotalPlayers() { return totalPlayers; }
    public void setTotalPlayers(int totalPlayers) { this.totalPlayers = totalPlayers; }
    public TiebreakerConfiguration getTiebreakerConfiguration() { return tiebreakerConfiguration; }
    public void setTiebreakerConfiguration(TiebreakerConfiguration tiebreakerConfiguration) {
        this.tiebreakerConfiguration = tiebreakerConfiguration;
    }

    public Map<UUID, PlayerBracketEntry> getPlayerEntries() {
        return Collections.unmodifiableMap(playerEntries);
    }
    public void setPlayerEntries(Map<UUID, PlayerBracketEntry> playerEntries) {
        this.playerEntries = new HashMap<>(playerEntries);
    }

    public List<PlayoffMatchup> getMatchupsForRound(PlayoffRound round) {
        return Collections.unmodifiableList(matchupsByRound.getOrDefault(round, Collections.emptyList()));
    }
    public Map<PlayoffRound, List<PlayoffMatchup>> getMatchupsByRound() {
        return Collections.unmodifiableMap(matchupsByRound);
    }
    public void setMatchupsByRound(Map<PlayoffRound, List<PlayoffMatchup>> matchupsByRound) {
        this.matchupsByRound = new HashMap<>(matchupsByRound);
    }

    public List<RosterScore> getScoresForRound(PlayoffRound round) {
        return Collections.unmodifiableList(scoresByRound.getOrDefault(round, Collections.emptyList()));
    }
    public Map<PlayoffRound, List<RosterScore>> getScoresByRound() {
        return Collections.unmodifiableMap(scoresByRound);
    }
    public void setScoresByRound(Map<PlayoffRound, List<RosterScore>> scoresByRound) {
        this.scoresByRound = new HashMap<>(scoresByRound);
    }

    public List<PlayoffRanking> getRankingsForRound(PlayoffRound round) {
        return Collections.unmodifiableList(rankingsByRound.getOrDefault(round, Collections.emptyList()));
    }
    public Map<PlayoffRound, List<PlayoffRanking>> getRankingsByRound() {
        return Collections.unmodifiableMap(rankingsByRound);
    }
    public void setRankingsByRound(Map<PlayoffRound, List<PlayoffRanking>> rankingsByRound) {
        this.rankingsByRound = new HashMap<>(rankingsByRound);
    }

    public BigDecimal getCumulativeScore(UUID playerId) {
        return cumulativeScores.getOrDefault(playerId, BigDecimal.ZERO);
    }
    public Map<UUID, BigDecimal> getCumulativeScores() {
        return Collections.unmodifiableMap(cumulativeScores);
    }
    public void setCumulativeScores(Map<UUID, BigDecimal> cumulativeScores) {
        this.cumulativeScores = new HashMap<>(cumulativeScores);
    }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    public boolean isComplete() { return isComplete; }
    public void setComplete(boolean complete) { isComplete = complete; }

    public Optional<PlayoffMatchup> findMatchupForPlayer(UUID playerId, PlayoffRound round) {
        return matchupsByRound.get(round).stream()
            .filter(m -> m.hasPlayer(playerId))
            .findFirst();
    }

    // ==================== Inner Class: PlayerBracketEntry ====================

    /**
     * Tracks a player's status and progress through the bracket
     */
    public static class PlayerBracketEntry {
        private final UUID playerId;
        private final String playerName;
        private final int seed;
        private final BigDecimal regularSeasonScore;
        private PlayerPlayoffStatus status;
        private PlayoffRound eliminatedInRound;
        private UUID eliminatedByPlayerId;
        private LocalDateTime eliminatedAt;

        public PlayerBracketEntry(UUID playerId, String playerName, int seed,
                                  BigDecimal regularSeasonScore, PlayerPlayoffStatus status,
                                  PlayoffRound currentRound) {
            this.playerId = playerId;
            this.playerName = playerName;
            this.seed = seed;
            this.regularSeasonScore = regularSeasonScore;
            this.status = status;
        }

        public void eliminate(PlayoffRound round, UUID eliminatedBy) {
            this.status = PlayerPlayoffStatus.ELIMINATED;
            this.eliminatedInRound = round;
            this.eliminatedByPlayerId = eliminatedBy;
            this.eliminatedAt = LocalDateTime.now();
        }

        // Getters
        public UUID getPlayerId() { return playerId; }
        public String getPlayerName() { return playerName; }
        public int getSeed() { return seed; }
        public BigDecimal getRegularSeasonScore() { return regularSeasonScore; }
        public PlayerPlayoffStatus getStatus() { return status; }
        public void setStatus(PlayerPlayoffStatus status) { this.status = status; }
        public PlayoffRound getEliminatedInRound() { return eliminatedInRound; }
        public UUID getEliminatedByPlayerId() { return eliminatedByPlayerId; }
        public LocalDateTime getEliminatedAt() { return eliminatedAt; }
    }
}

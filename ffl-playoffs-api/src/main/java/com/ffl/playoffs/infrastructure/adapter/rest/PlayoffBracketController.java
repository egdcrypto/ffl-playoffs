package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.usecase.*;
import com.ffl.playoffs.domain.aggregate.PlayoffBracket;
import com.ffl.playoffs.domain.model.PlayoffRanking;
import com.ffl.playoffs.domain.model.PlayoffRound;
import com.ffl.playoffs.domain.model.RosterScore;
import com.ffl.playoffs.domain.port.PlayoffBracketRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * REST controller for playoff bracket management and scoring
 */
@RestController
@RequestMapping("/api/v1/playoffs")
@RequiredArgsConstructor
@Tag(name = "Playoff Management", description = "APIs for managing playoff brackets, scoring, and rankings")
public class PlayoffBracketController {

    private final PlayoffBracketRepository bracketRepository;
    private final InitializePlayoffBracketUseCase initializeBracketUseCase;
    private final CalculatePlayoffScoreUseCase calculateScoreUseCase;
    private final ProcessBracketAdvancementUseCase processBracketUseCase;
    private final GeneratePlayoffRankingsUseCase generateRankingsUseCase;
    private final GetMatchupDetailsUseCase getMatchupDetailsUseCase;

    // ==================== Bracket Management ====================

    @PostMapping("/leagues/{leagueId}/bracket")
    @Operation(summary = "Initialize playoff bracket", description = "Create a new playoff bracket for a league")
    public ResponseEntity<PlayoffBracketDTO> initializeBracket(
            @PathVariable UUID leagueId,
            @RequestBody InitializeBracketRequest request) {

        List<InitializePlayoffBracketUseCase.PlayerSeed> seeds = request.getPlayerSeedings().stream()
            .map(s -> new InitializePlayoffBracketUseCase.PlayerSeed(
                s.getPlayerId(), s.getPlayerName(), s.getSeed(), s.getRegularSeasonScore()))
            .collect(Collectors.toList());

        InitializePlayoffBracketUseCase.InitializePlayoffBracketCommand command =
            new InitializePlayoffBracketUseCase.InitializePlayoffBracketCommand(leagueId, seeds);

        PlayoffBracket bracket = initializeBracketUseCase.execute(command);

        return ResponseEntity.status(HttpStatus.CREATED).body(mapToDTO(bracket));
    }

    @GetMapping("/leagues/{leagueId}/bracket")
    @Operation(summary = "Get playoff bracket", description = "Get the playoff bracket for a league")
    public ResponseEntity<PlayoffBracketDTO> getBracket(@PathVariable UUID leagueId) {
        return bracketRepository.findByLeagueId(leagueId)
            .map(this::mapToDTO)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    // ==================== Scoring ====================

    @PostMapping("/leagues/{leagueId}/scores")
    @Operation(summary = "Calculate player score", description = "Calculate and record a player's score for a playoff round")
    public ResponseEntity<RosterScoreDTO> calculateScore(
            @PathVariable UUID leagueId,
            @RequestBody CalculateScoreRequest request) {

        CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand command =
            new CalculatePlayoffScoreUseCase.CalculatePlayoffScoreCommand(
                leagueId,
                request.getLeaguePlayerId(),
                request.getRound(),
                request.getNflWeek()
            );

        RosterScore score = calculateScoreUseCase.execute(command);

        return ResponseEntity.ok(mapToDTO(score));
    }

    @GetMapping("/leagues/{leagueId}/scores/{round}")
    @Operation(summary = "Get round scores", description = "Get all scores for a playoff round")
    public ResponseEntity<List<RosterScoreDTO>> getRoundScores(
            @PathVariable UUID leagueId,
            @PathVariable PlayoffRound round) {

        return bracketRepository.findByLeagueId(leagueId)
            .map(bracket -> bracket.getScoresForRound(round))
            .map(scores -> scores.stream().map(this::mapToDTO).collect(Collectors.toList()))
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    // ==================== Bracket Advancement ====================

    @PostMapping("/leagues/{leagueId}/advance")
    @Operation(summary = "Process bracket advancement", description = "Process round results and advance winners")
    public ResponseEntity<BracketAdvancementResultDTO> processBracketAdvancement(
            @PathVariable UUID leagueId,
            @RequestBody ProcessAdvancementRequest request) {

        ProcessBracketAdvancementUseCase.ProcessBracketAdvancementCommand command =
            new ProcessBracketAdvancementUseCase.ProcessBracketAdvancementCommand(leagueId, request.getRound());

        ProcessBracketAdvancementUseCase.ProcessBracketAdvancementResult result =
            processBracketUseCase.execute(command);

        return ResponseEntity.ok(mapToDTO(result));
    }

    // ==================== Rankings ====================

    @PostMapping("/leagues/{leagueId}/rankings")
    @Operation(summary = "Generate rankings", description = "Generate rankings for a playoff round")
    public ResponseEntity<RankingsDTO> generateRankings(
            @PathVariable UUID leagueId,
            @RequestBody GenerateRankingsRequest request) {

        GeneratePlayoffRankingsUseCase.GenerateRankingsCommand command =
            new GeneratePlayoffRankingsUseCase.GenerateRankingsCommand(
                leagueId, request.getRound(), request.isCumulative());

        GeneratePlayoffRankingsUseCase.GenerateRankingsResult result =
            generateRankingsUseCase.execute(command);

        return ResponseEntity.ok(mapToDTO(result));
    }

    @GetMapping("/leagues/{leagueId}/rankings/{round}")
    @Operation(summary = "Get round rankings", description = "Get rankings for a playoff round")
    public ResponseEntity<List<PlayoffRankingDTO>> getRoundRankings(
            @PathVariable UUID leagueId,
            @PathVariable PlayoffRound round,
            @RequestParam(defaultValue = "false") boolean cumulative) {

        return bracketRepository.findByLeagueId(leagueId)
            .map(bracket -> bracket.getRankingsForRound(round))
            .map(rankings -> rankings.stream().map(this::mapToDTO).collect(Collectors.toList()))
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    // ==================== Matchups ====================

    @GetMapping("/leagues/{leagueId}/matchups/{round}/{matchupId}")
    @Operation(summary = "Get matchup details", description = "Get detailed head-to-head matchup information")
    public ResponseEntity<MatchupDetailsDTO> getMatchupDetails(
            @PathVariable UUID leagueId,
            @PathVariable PlayoffRound round,
            @PathVariable UUID matchupId) {

        GetMatchupDetailsUseCase.GetMatchupDetailsCommand command =
            new GetMatchupDetailsUseCase.GetMatchupDetailsCommand(leagueId, round, matchupId);

        GetMatchupDetailsUseCase.MatchupDetailsResult result = getMatchupDetailsUseCase.execute(command);

        return ResponseEntity.ok(mapToDTO(result));
    }

    @GetMapping("/leagues/{leagueId}/matchups/{round}")
    @Operation(summary = "Get round matchups", description = "Get all matchups for a playoff round")
    public ResponseEntity<List<MatchupSummaryDTO>> getRoundMatchups(
            @PathVariable UUID leagueId,
            @PathVariable PlayoffRound round) {

        return bracketRepository.findByLeagueId(leagueId)
            .map(bracket -> bracket.getMatchupsForRound(round))
            .map(matchups -> matchups.stream().map(this::mapToSummaryDTO).collect(Collectors.toList()))
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    // ==================== DTOs ====================

    public static class InitializeBracketRequest {
        private List<PlayerSeedDTO> playerSeedings;
        public List<PlayerSeedDTO> getPlayerSeedings() { return playerSeedings; }
        public void setPlayerSeedings(List<PlayerSeedDTO> playerSeedings) { this.playerSeedings = playerSeedings; }
    }

    public static class PlayerSeedDTO {
        private UUID playerId;
        private String playerName;
        private int seed;
        private BigDecimal regularSeasonScore;

        public UUID getPlayerId() { return playerId; }
        public void setPlayerId(UUID playerId) { this.playerId = playerId; }
        public String getPlayerName() { return playerName; }
        public void setPlayerName(String playerName) { this.playerName = playerName; }
        public int getSeed() { return seed; }
        public void setSeed(int seed) { this.seed = seed; }
        public BigDecimal getRegularSeasonScore() { return regularSeasonScore; }
        public void setRegularSeasonScore(BigDecimal regularSeasonScore) { this.regularSeasonScore = regularSeasonScore; }
    }

    public static class CalculateScoreRequest {
        private UUID leaguePlayerId;
        private PlayoffRound round;
        private int nflWeek;

        public UUID getLeaguePlayerId() { return leaguePlayerId; }
        public void setLeaguePlayerId(UUID leaguePlayerId) { this.leaguePlayerId = leaguePlayerId; }
        public PlayoffRound getRound() { return round; }
        public void setRound(PlayoffRound round) { this.round = round; }
        public int getNflWeek() { return nflWeek; }
        public void setNflWeek(int nflWeek) { this.nflWeek = nflWeek; }
    }

    public static class ProcessAdvancementRequest {
        private PlayoffRound round;
        public PlayoffRound getRound() { return round; }
        public void setRound(PlayoffRound round) { this.round = round; }
    }

    public static class GenerateRankingsRequest {
        private PlayoffRound round;
        private boolean cumulative;

        public PlayoffRound getRound() { return round; }
        public void setRound(PlayoffRound round) { this.round = round; }
        public boolean isCumulative() { return cumulative; }
        public void setCumulative(boolean cumulative) { this.cumulative = cumulative; }
    }

    // ==================== Response DTOs ====================

    public static class PlayoffBracketDTO {
        private UUID id;
        private UUID leagueId;
        private String leagueName;
        private PlayoffRound currentRound;
        private int totalPlayers;
        private boolean isComplete;

        // Getters and setters
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
        public boolean isComplete() { return isComplete; }
        public void setComplete(boolean complete) { isComplete = complete; }
    }

    public static class RosterScoreDTO {
        private UUID id;
        private UUID leaguePlayerId;
        private String playerName;
        private PlayoffRound round;
        private BigDecimal totalScore;
        private int totalTouchdowns;
        private int totalTurnovers;
        private boolean isComplete;

        // Getters and setters
        public UUID getId() { return id; }
        public void setId(UUID id) { this.id = id; }
        public UUID getLeaguePlayerId() { return leaguePlayerId; }
        public void setLeaguePlayerId(UUID leaguePlayerId) { this.leaguePlayerId = leaguePlayerId; }
        public String getPlayerName() { return playerName; }
        public void setPlayerName(String playerName) { this.playerName = playerName; }
        public PlayoffRound getRound() { return round; }
        public void setRound(PlayoffRound round) { this.round = round; }
        public BigDecimal getTotalScore() { return totalScore; }
        public void setTotalScore(BigDecimal totalScore) { this.totalScore = totalScore; }
        public int getTotalTouchdowns() { return totalTouchdowns; }
        public void setTotalTouchdowns(int totalTouchdowns) { this.totalTouchdowns = totalTouchdowns; }
        public int getTotalTurnovers() { return totalTurnovers; }
        public void setTotalTurnovers(int totalTurnovers) { this.totalTurnovers = totalTurnovers; }
        public boolean isComplete() { return isComplete; }
        public void setComplete(boolean complete) { isComplete = complete; }
    }

    public static class BracketAdvancementResultDTO {
        private UUID leagueId;
        private PlayoffRound round;
        private List<UUID> eliminatedPlayers;
        private List<UUID> advancingPlayers;
        private boolean playoffsComplete;

        // Getters and setters
        public UUID getLeagueId() { return leagueId; }
        public void setLeagueId(UUID leagueId) { this.leagueId = leagueId; }
        public PlayoffRound getRound() { return round; }
        public void setRound(PlayoffRound round) { this.round = round; }
        public List<UUID> getEliminatedPlayers() { return eliminatedPlayers; }
        public void setEliminatedPlayers(List<UUID> eliminatedPlayers) { this.eliminatedPlayers = eliminatedPlayers; }
        public List<UUID> getAdvancingPlayers() { return advancingPlayers; }
        public void setAdvancingPlayers(List<UUID> advancingPlayers) { this.advancingPlayers = advancingPlayers; }
        public boolean isPlayoffsComplete() { return playoffsComplete; }
        public void setPlayoffsComplete(boolean playoffsComplete) { this.playoffsComplete = playoffsComplete; }
    }

    public static class RankingsDTO {
        private UUID leagueId;
        private PlayoffRound round;
        private boolean cumulative;
        private List<PlayoffRankingDTO> rankings;

        // Getters and setters
        public UUID getLeagueId() { return leagueId; }
        public void setLeagueId(UUID leagueId) { this.leagueId = leagueId; }
        public PlayoffRound getRound() { return round; }
        public void setRound(PlayoffRound round) { this.round = round; }
        public boolean isCumulative() { return cumulative; }
        public void setCumulative(boolean cumulative) { this.cumulative = cumulative; }
        public List<PlayoffRankingDTO> getRankings() { return rankings; }
        public void setRankings(List<PlayoffRankingDTO> rankings) { this.rankings = rankings; }
    }

    public static class PlayoffRankingDTO {
        private UUID leaguePlayerId;
        private String playerName;
        private int rank;
        private int previousRank;
        private int rankChange;
        private BigDecimal score;
        private String status;

        // Getters and setters
        public UUID getLeaguePlayerId() { return leaguePlayerId; }
        public void setLeaguePlayerId(UUID leaguePlayerId) { this.leaguePlayerId = leaguePlayerId; }
        public String getPlayerName() { return playerName; }
        public void setPlayerName(String playerName) { this.playerName = playerName; }
        public int getRank() { return rank; }
        public void setRank(int rank) { this.rank = rank; }
        public int getPreviousRank() { return previousRank; }
        public void setPreviousRank(int previousRank) { this.previousRank = previousRank; }
        public int getRankChange() { return rankChange; }
        public void setRankChange(int rankChange) { this.rankChange = rankChange; }
        public BigDecimal getScore() { return score; }
        public void setScore(BigDecimal score) { this.score = score; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }

    public static class MatchupDetailsDTO {
        private UUID matchupId;
        private PlayoffRound round;
        private String status;
        private PlayerMatchupDTO player1;
        private PlayerMatchupDTO player2;
        private UUID winnerId;
        private boolean isUpset;

        // Getters and setters
        public UUID getMatchupId() { return matchupId; }
        public void setMatchupId(UUID matchupId) { this.matchupId = matchupId; }
        public PlayoffRound getRound() { return round; }
        public void setRound(PlayoffRound round) { this.round = round; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public PlayerMatchupDTO getPlayer1() { return player1; }
        public void setPlayer1(PlayerMatchupDTO player1) { this.player1 = player1; }
        public PlayerMatchupDTO getPlayer2() { return player2; }
        public void setPlayer2(PlayerMatchupDTO player2) { this.player2 = player2; }
        public UUID getWinnerId() { return winnerId; }
        public void setWinnerId(UUID winnerId) { this.winnerId = winnerId; }
        public boolean isUpset() { return isUpset; }
        public void setUpset(boolean upset) { isUpset = upset; }
    }

    public static class PlayerMatchupDTO {
        private UUID playerId;
        private String playerName;
        private int seed;
        private BigDecimal totalScore;

        // Getters and setters
        public UUID getPlayerId() { return playerId; }
        public void setPlayerId(UUID playerId) { this.playerId = playerId; }
        public String getPlayerName() { return playerName; }
        public void setPlayerName(String playerName) { this.playerName = playerName; }
        public int getSeed() { return seed; }
        public void setSeed(int seed) { this.seed = seed; }
        public BigDecimal getTotalScore() { return totalScore; }
        public void setTotalScore(BigDecimal totalScore) { this.totalScore = totalScore; }
    }

    public static class MatchupSummaryDTO {
        private UUID matchupId;
        private int matchupNumber;
        private String status;
        private String player1Name;
        private int player1Seed;
        private BigDecimal player1Score;
        private String player2Name;
        private int player2Seed;
        private BigDecimal player2Score;

        // Getters and setters
        public UUID getMatchupId() { return matchupId; }
        public void setMatchupId(UUID matchupId) { this.matchupId = matchupId; }
        public int getMatchupNumber() { return matchupNumber; }
        public void setMatchupNumber(int matchupNumber) { this.matchupNumber = matchupNumber; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public String getPlayer1Name() { return player1Name; }
        public void setPlayer1Name(String player1Name) { this.player1Name = player1Name; }
        public int getPlayer1Seed() { return player1Seed; }
        public void setPlayer1Seed(int player1Seed) { this.player1Seed = player1Seed; }
        public BigDecimal getPlayer1Score() { return player1Score; }
        public void setPlayer1Score(BigDecimal player1Score) { this.player1Score = player1Score; }
        public String getPlayer2Name() { return player2Name; }
        public void setPlayer2Name(String player2Name) { this.player2Name = player2Name; }
        public int getPlayer2Seed() { return player2Seed; }
        public void setPlayer2Seed(int player2Seed) { this.player2Seed = player2Seed; }
        public BigDecimal getPlayer2Score() { return player2Score; }
        public void setPlayer2Score(BigDecimal player2Score) { this.player2Score = player2Score; }
    }

    // ==================== Mappers ====================

    private PlayoffBracketDTO mapToDTO(PlayoffBracket bracket) {
        PlayoffBracketDTO dto = new PlayoffBracketDTO();
        dto.setId(bracket.getId());
        dto.setLeagueId(bracket.getLeagueId());
        dto.setLeagueName(bracket.getLeagueName());
        dto.setCurrentRound(bracket.getCurrentRound());
        dto.setTotalPlayers(bracket.getTotalPlayers());
        dto.setComplete(bracket.isComplete());
        return dto;
    }

    private RosterScoreDTO mapToDTO(RosterScore score) {
        RosterScoreDTO dto = new RosterScoreDTO();
        dto.setId(score.getId());
        dto.setLeaguePlayerId(score.getLeaguePlayerId());
        dto.setPlayerName(score.getPlayerName());
        dto.setRound(score.getRound());
        dto.setTotalScore(score.getTotalScore());
        dto.setTotalTouchdowns(score.getTotalTouchdowns());
        dto.setTotalTurnovers(score.getTotalTurnovers());
        dto.setComplete(score.isComplete());
        return dto;
    }

    private BracketAdvancementResultDTO mapToDTO(ProcessBracketAdvancementUseCase.ProcessBracketAdvancementResult result) {
        BracketAdvancementResultDTO dto = new BracketAdvancementResultDTO();
        dto.setLeagueId(result.getLeagueId());
        dto.setRound(result.getRound());
        dto.setEliminatedPlayers(result.getEliminatedPlayers());
        dto.setAdvancingPlayers(result.getAdvancingPlayers());
        dto.setPlayoffsComplete(result.isPlayoffsComplete());
        return dto;
    }

    private RankingsDTO mapToDTO(GeneratePlayoffRankingsUseCase.GenerateRankingsResult result) {
        RankingsDTO dto = new RankingsDTO();
        dto.setLeagueId(result.getLeagueId());
        dto.setRound(result.getRound());
        dto.setCumulative(result.isCumulative());
        dto.setRankings(result.getRankings().stream().map(this::mapToDTO).collect(Collectors.toList()));
        return dto;
    }

    private PlayoffRankingDTO mapToDTO(PlayoffRanking ranking) {
        PlayoffRankingDTO dto = new PlayoffRankingDTO();
        dto.setLeaguePlayerId(ranking.getLeaguePlayerId());
        dto.setPlayerName(ranking.getPlayerName());
        dto.setRank(ranking.getRank());
        dto.setPreviousRank(ranking.getPreviousRank());
        dto.setRankChange(ranking.getRankChange());
        dto.setScore(ranking.getScore());
        dto.setStatus(ranking.getStatus().name());
        return dto;
    }

    private MatchupDetailsDTO mapToDTO(GetMatchupDetailsUseCase.MatchupDetailsResult result) {
        MatchupDetailsDTO dto = new MatchupDetailsDTO();
        dto.setMatchupId(result.getMatchupId());
        dto.setRound(result.getRound());
        dto.setStatus(result.getStatus().name());
        dto.setWinnerId(result.getWinnerId());
        dto.setUpset(result.isUpset());

        if (result.getPlayer1() != null) {
            dto.setPlayer1(mapToDTO(result.getPlayer1()));
        }
        if (result.getPlayer2() != null) {
            dto.setPlayer2(mapToDTO(result.getPlayer2()));
        }

        return dto;
    }

    private PlayerMatchupDTO mapToDTO(GetMatchupDetailsUseCase.PlayerMatchupDetails details) {
        PlayerMatchupDTO dto = new PlayerMatchupDTO();
        dto.setPlayerId(details.getPlayerId());
        dto.setPlayerName(details.getPlayerName());
        dto.setSeed(details.getSeed());
        dto.setTotalScore(details.getTotalScore());
        return dto;
    }

    private MatchupSummaryDTO mapToSummaryDTO(com.ffl.playoffs.domain.aggregate.PlayoffMatchup matchup) {
        MatchupSummaryDTO dto = new MatchupSummaryDTO();
        dto.setMatchupId(matchup.getId());
        dto.setMatchupNumber(matchup.getMatchupNumber());
        dto.setStatus(matchup.getStatus().name());
        dto.setPlayer1Name(matchup.getPlayer1Name());
        dto.setPlayer1Seed(matchup.getPlayer1Seed());
        dto.setPlayer2Name(matchup.getPlayer2Name());
        dto.setPlayer2Seed(matchup.getPlayer2Seed());

        if (matchup.getPlayer1Score() != null) {
            dto.setPlayer1Score(matchup.getPlayer1Score().getTotalScore());
        }
        if (matchup.getPlayer2Score() != null) {
            dto.setPlayer2Score(matchup.getPlayer2Score().getTotalScore());
        }

        return dto;
    }
}

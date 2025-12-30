package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.LeaderboardEntryDTO;
import com.ffl.playoffs.application.dto.LeagueStatsDTO;
import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.PageRequest;
import com.ffl.playoffs.application.usecase.GetLeagueStandingsUseCase;
import com.ffl.playoffs.application.usecase.GetLeagueStatsUseCase;
import com.ffl.playoffs.application.usecase.GetWeeklyRankingsUseCase;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

/**
 * Leaderboard REST API
 * Provides endpoints for viewing league standings, rankings, and scores
 * Used by clients to display competitive information
 *
 * Infrastructure layer REST adapter
 */
@RestController
@RequestMapping("/api/v1/leaderboards")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Leaderboards", description = "League standings and rankings")
public class LeaderboardController {

    private final GetLeagueStandingsUseCase getLeagueStandingsUseCase;
    private final GetWeeklyRankingsUseCase getWeeklyRankingsUseCase;
    private final GetLeagueStatsUseCase getLeagueStatsUseCase;

    @GetMapping("/leagues/{leagueId}")
    @Operation(
            summary = "Get league standings",
            description = "Retrieves current standings for a league, sorted by total points",
            responses = {
                    @ApiResponse(responseCode = "200", description = "Standings retrieved successfully",
                            content = @Content(schema = @Schema(implementation = Page.class))),
                    @ApiResponse(responseCode = "404", description = "League not found")
            }
    )
    public ResponseEntity<Page<LeaderboardEntryDTO>> getLeagueStandings(
            @PathVariable UUID leagueId,

            @Parameter(description = "Page number (0-indexed)")
            @RequestParam(defaultValue = "0") int page,

            @Parameter(description = "Page size")
            @RequestParam(defaultValue = "20") int size,

            @Parameter(description = "Include eliminated players")
            @RequestParam(defaultValue = "true") boolean includeEliminated) {

        log.info("Getting league standings for leagueId={}, page={}, size={}, includeEliminated={}",
                leagueId, page, size, includeEliminated);

        PageRequest pageRequest = PageRequest.of(page, size);
        Page<LeaderboardEntryDTO> standings = getLeagueStandingsUseCase.execute(leagueId, pageRequest, includeEliminated);

        return ResponseEntity.ok(standings);
    }

    @GetMapping("/leagues/{leagueId}/week/{week}")
    @Operation(
            summary = "Get weekly rankings",
            description = "Retrieves rankings for a specific week in a league",
            responses = {
                    @ApiResponse(responseCode = "200", description = "Weekly rankings retrieved successfully"),
                    @ApiResponse(responseCode = "400", description = "Invalid week number"),
                    @ApiResponse(responseCode = "404", description = "League not found")
            }
    )
    public ResponseEntity<Page<LeaderboardEntryDTO>> getWeeklyRankings(
            @PathVariable UUID leagueId,
            @PathVariable Integer week,

            @Parameter(description = "Page number (0-indexed)")
            @RequestParam(defaultValue = "0") int page,

            @Parameter(description = "Page size")
            @RequestParam(defaultValue = "20") int size) {

        log.info("Getting weekly rankings for leagueId={}, week={}, page={}, size={}",
                leagueId, week, page, size);

        PageRequest pageRequest = PageRequest.of(page, size);
        Page<LeaderboardEntryDTO> rankings = getWeeklyRankingsUseCase.execute(leagueId, week, pageRequest);

        return ResponseEntity.ok(rankings);
    }

    @GetMapping("/leagues/{leagueId}/players/{playerId}/breakdown")
    @Operation(
            summary = "Get player score breakdown",
            description = "Retrieves detailed score breakdown for a specific player showing points per player per week",
            responses = {
                    @ApiResponse(responseCode = "200", description = "Score breakdown retrieved successfully"),
                    @ApiResponse(responseCode = "404", description = "Player or league not found")
            }
    )
    public ResponseEntity<?> getPlayerScoreBreakdown(
            @PathVariable UUID leagueId,
            @PathVariable UUID playerId,

            @Parameter(description = "Filter by week")
            @RequestParam(required = false) Integer week) {

        log.info("Getting player score breakdown for leagueId={}, playerId={}, week={}",
                leagueId, playerId, week);

        // TODO: Implement GetPlayerScoreBreakdownUseCase when team selection data is available
        return ResponseEntity.ok(Map.of(
                "message", "Player score breakdown - coming soon",
                "leagueId", leagueId.toString(),
                "playerId", playerId.toString(),
                "week", week != null ? week : "all"
        ));
    }

    @GetMapping("/leagues/{leagueId}/stats")
    @Operation(
            summary = "Get league statistics",
            description = "Retrieves aggregate statistics for the entire league",
            responses = {
                    @ApiResponse(responseCode = "200", description = "Statistics retrieved successfully",
                            content = @Content(schema = @Schema(implementation = LeagueStatsDTO.class))),
                    @ApiResponse(responseCode = "404", description = "League not found")
            }
    )
    public ResponseEntity<LeagueStatsDTO> getLeagueStats(
            @PathVariable UUID leagueId) {

        log.info("Getting league stats for leagueId={}", leagueId);

        LeagueStatsDTO stats = getLeagueStatsUseCase.execute(leagueId);

        return ResponseEntity.ok(stats);
    }

    @GetMapping("/leagues/{leagueId}/history")
    @Operation(
            summary = "Get league history",
            description = "Retrieves historical standings showing how rankings changed week by week",
            responses = {
                    @ApiResponse(responseCode = "200", description = "History retrieved successfully"),
                    @ApiResponse(responseCode = "404", description = "League not found")
            }
    )
    public ResponseEntity<?> getLeagueHistory(
            @PathVariable UUID leagueId) {

        log.info("Getting league history for leagueId={}", leagueId);

        // TODO: Implement GetLeagueHistoryUseCase
        return ResponseEntity.ok(Map.of(
                "message", "League history - coming soon",
                "leagueId", leagueId.toString()
        ));
    }

    @GetMapping("/leagues/{leagueId}/matchups")
    @Operation(
            summary = "Get head-to-head matchups",
            description = "Shows head-to-head comparisons between players in the league",
            responses = {
                    @ApiResponse(responseCode = "200", description = "Matchups retrieved successfully"),
                    @ApiResponse(responseCode = "404", description = "League not found")
            }
    )
    public ResponseEntity<?> getMatchups(
            @PathVariable UUID leagueId,

            @Parameter(description = "Week number for matchups")
            @RequestParam(required = false) Integer week) {

        log.info("Getting matchups for leagueId={}, week={}", leagueId, week);

        // TODO: Implement GetMatchupsUseCase
        return ResponseEntity.ok(Map.of(
                "message", "Matchups - coming soon",
                "leagueId", leagueId.toString(),
                "week", week != null ? week : "current"
        ));
    }

    @GetMapping("/games/{gameId}")
    @Operation(
            summary = "Get game standings (legacy)",
            description = "Retrieves standings for a game (deprecated - use /leagues endpoint)",
            deprecated = true
    )
    @Deprecated
    public ResponseEntity<?> getGameStandings(
            @PathVariable UUID gameId,

            @Parameter(description = "Page number (0-indexed)")
            @RequestParam(defaultValue = "0") int page,

            @Parameter(description = "Page size")
            @RequestParam(defaultValue = "20") int size) {

        log.warn("Deprecated endpoint called: /games/{} - redirecting to /leagues endpoint", gameId);

        // Delegate to the league standings endpoint
        return getLeagueStandings(gameId, page, size, true);
    }
}

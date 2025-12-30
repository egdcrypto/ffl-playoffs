package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.usecase.GetLeagueHistoryUseCase;
import com.ffl.playoffs.application.usecase.GetLeagueStandingsUseCase;
import com.ffl.playoffs.application.usecase.GetLeagueStatsUseCase;
import com.ffl.playoffs.application.usecase.GetMatchupsUseCase;
import com.ffl.playoffs.application.usecase.GetPlayerScoreBreakdownUseCase;
import com.ffl.playoffs.application.usecase.GetWeeklyRankingsUseCase;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

/**
 * Leaderboard REST API
 * Provides endpoints for viewing league standings, rankings, and scores
 * Used by clients to display competitive information
 */
@RestController
@RequestMapping("/api/v1/leaderboards")
@RequiredArgsConstructor
@Tag(name = "Leaderboards", description = "League standings and rankings")
public class LeaderboardController {

    private final GetLeagueStandingsUseCase getLeagueStandingsUseCase;
    private final GetWeeklyRankingsUseCase getWeeklyRankingsUseCase;
    private final GetPlayerScoreBreakdownUseCase getPlayerScoreBreakdownUseCase;
    private final GetLeagueStatsUseCase getLeagueStatsUseCase;
    private final GetLeagueHistoryUseCase getLeagueHistoryUseCase;
    private final GetMatchupsUseCase getMatchupsUseCase;

    @GetMapping("/leagues/{leagueId}")
    @Operation(
            summary = "Get league standings",
            description = "Retrieves current standings for a league, sorted by total points"
    )
    public ResponseEntity<?> getLeagueStandings(
            @PathVariable UUID leagueId,

            @Parameter(description = "Include eliminated players")
            @RequestParam(defaultValue = "true") boolean includeEliminated) {

        var command = new GetLeagueStandingsUseCase.GetStandingsCommand(leagueId, includeEliminated);
        var result = getLeagueStandingsUseCase.execute(command);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/leagues/{leagueId}/week/{week}")
    @Operation(
            summary = "Get weekly rankings",
            description = "Retrieves rankings for a specific week in a league"
    )
    public ResponseEntity<?> getWeeklyRankings(
            @PathVariable UUID leagueId,
            @PathVariable Integer week) {

        var command = new GetWeeklyRankingsUseCase.GetWeeklyRankingsCommand(leagueId, week);
        var result = getWeeklyRankingsUseCase.execute(command);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/leagues/{leagueId}/players/{playerId}/breakdown")
    @Operation(
            summary = "Get player score breakdown",
            description = "Retrieves detailed score breakdown for a specific player showing points per player per week"
    )
    public ResponseEntity<?> getPlayerScoreBreakdown(
            @PathVariable UUID leagueId,
            @PathVariable UUID playerId,

            @Parameter(description = "Filter by week")
            @RequestParam(required = false) Integer week) {

        var command = new GetPlayerScoreBreakdownUseCase.GetScoreBreakdownCommand(leagueId, playerId, week);
        var result = getPlayerScoreBreakdownUseCase.execute(command);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/leagues/{leagueId}/stats")
    @Operation(
            summary = "Get league statistics",
            description = "Retrieves aggregate statistics for the entire league"
    )
    public ResponseEntity<?> getLeagueStats(
            @PathVariable UUID leagueId) {

        var command = new GetLeagueStatsUseCase.GetLeagueStatsCommand(leagueId);
        var result = getLeagueStatsUseCase.execute(command);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/leagues/{leagueId}/history")
    @Operation(
            summary = "Get league history",
            description = "Retrieves historical standings showing how rankings changed week by week"
    )
    public ResponseEntity<?> getLeagueHistory(
            @PathVariable UUID leagueId) {

        var command = new GetLeagueHistoryUseCase.GetLeagueHistoryCommand(leagueId);
        var result = getLeagueHistoryUseCase.execute(command);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/leagues/{leagueId}/matchups/{week}")
    @Operation(
            summary = "Get head-to-head matchups",
            description = "Shows head-to-head comparisons between players in the league"
    )
    public ResponseEntity<?> getMatchups(
            @PathVariable UUID leagueId,
            @PathVariable Integer week) {

        var command = new GetMatchupsUseCase.GetMatchupsCommand(leagueId, week);
        var result = getMatchupsUseCase.execute(command);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/games/{gameId}")
    @Operation(
            summary = "Get game standings (legacy)",
            description = "Retrieves standings for a game (deprecated - use /leagues endpoint)"
    )
    @Deprecated
    public ResponseEntity<?> getGameStandings(
            @PathVariable UUID gameId) {

        // TODO: Redirect to league standings
        // This endpoint exists for backward compatibility
        // New clients should use /api/v1/leaderboards/leagues/{leagueId}

        return ResponseEntity.ok(Map.of(
                "message", "Please use /api/v1/leaderboards/leagues/{leagueId} instead",
                "gameId", gameId.toString()
        ));
    }
}

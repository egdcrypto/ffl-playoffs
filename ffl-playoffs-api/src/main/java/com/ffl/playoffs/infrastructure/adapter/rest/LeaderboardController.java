package com.ffl.playoffs.infrastructure.adapter.rest;

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

    // TODO: Inject use cases when implemented:
    // - GetLeagueStandingsUseCase
    // - GetWeeklyRankingsUseCase
    // - GetPlayerScoreBreakdownUseCase
    // - GetLeagueStatsUseCase

    @GetMapping("/leagues/{leagueId}")
    @Operation(
            summary = "Get league standings",
            description = "Retrieves current standings for a league, sorted by total points"
    )
    public ResponseEntity<?> getLeagueStandings(
            @PathVariable UUID leagueId,

            @Parameter(description = "Include eliminated players")
            @RequestParam(defaultValue = "true") boolean includeEliminated) {

        // TODO: Implement GetLeagueStandingsUseCase
        // - Query all league players with their rosters
        // - Calculate total fantasy points for each player
        // - Sort by total points descending
        // - Mark eliminated players
        // - Return standings with: rank, playerId, playerName, totalPoints,
        //   weeklyPoints[], eliminatedWeek, isEliminated

        return ResponseEntity.ok(Map.of(
                "message", "TODO: Implement GetLeagueStandingsUseCase",
                "leagueId", leagueId.toString()
        ));
    }

    @GetMapping("/leagues/{leagueId}/week/{week}")
    @Operation(
            summary = "Get weekly rankings",
            description = "Retrieves rankings for a specific week in a league"
    )
    public ResponseEntity<?> getWeeklyRankings(
            @PathVariable UUID leagueId,
            @PathVariable Integer week) {

        // TODO: Implement GetWeeklyRankingsUseCase
        // - Query all rosters for the specified league and week
        // - Calculate fantasy points for each roster in that week
        // - Sort by week points descending
        // - Return weekly rankings with: rank, playerId, playerName, weekPoints,
        //   rosterPlayers[], totalPoints, movement (up/down from previous week)

        return ResponseEntity.ok(Map.of(
                "message", "TODO: Implement GetWeeklyRankingsUseCase",
                "leagueId", leagueId.toString(),
                "week", week
        ));
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

        // TODO: Implement GetPlayerScoreBreakdownUseCase
        // - Find player's rosters for all weeks (or specific week)
        // - For each roster slot, show:
        //   - NFL player name, position, team
        //   - Week opponent
        //   - Individual stats (yards, TDs, etc.)
        //   - Fantasy points earned
        // - Calculate total points per week
        // - Return detailed breakdown

        return ResponseEntity.ok(Map.of(
                "message", "TODO: Implement GetPlayerScoreBreakdownUseCase",
                "leagueId", leagueId.toString(),
                "playerId", playerId.toString(),
                "week", week != null ? week : "all"
        ));
    }

    @GetMapping("/leagues/{leagueId}/stats")
    @Operation(
            summary = "Get league statistics",
            description = "Retrieves aggregate statistics for the entire league"
    )
    public ResponseEntity<?> getLeagueStats(
            @PathVariable UUID leagueId) {

        // TODO: Implement GetLeagueStatsUseCase
        // - Calculate league-wide statistics:
        //   - Total players
        //   - Active players
        //   - Eliminated players
        //   - Highest single-week score
        //   - Lowest single-week score
        //   - Average weekly score
        //   - Most popular NFL player (selected most often)
        //   - Current leader
        //   - Week standings history
        // - Return aggregate stats

        return ResponseEntity.ok(Map.of(
                "message", "TODO: Implement GetLeagueStatsUseCase",
                "leagueId", leagueId.toString()
        ));
    }

    @GetMapping("/leagues/{leagueId}/history")
    @Operation(
            summary = "Get league history",
            description = "Retrieves historical standings showing how rankings changed week by week"
    )
    public ResponseEntity<?> getLeagueHistory(
            @PathVariable UUID leagueId) {

        // TODO: Implement GetLeagueHistoryUseCase
        // - Query standings for each week
        // - Show rank changes over time for each player
        // - Include elimination events
        // - Return week-by-week standings progression

        return ResponseEntity.ok(Map.of(
                "message", "TODO: Implement GetLeagueHistoryUseCase",
                "leagueId", leagueId.toString()
        ));
    }

    @GetMapping("/leagues/{leagueId}/matchups")
    @Operation(
            summary = "Get head-to-head matchups",
            description = "Shows head-to-head comparisons between players in the league"
    )
    public ResponseEntity<?> getMatchups(
            @PathVariable UUID leagueId,
            @PathVariable Integer week) {

        // TODO: Implement GetMatchupsUseCase
        // - Generate head-to-head matchups for the week
        // - Compare each player's score against others
        // - Show win/loss records
        // - Return matchup grid with scores

        return ResponseEntity.ok(Map.of(
                "message", "TODO: Implement GetMatchupsUseCase",
                "leagueId", leagueId.toString(),
                "week", week
        ));
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

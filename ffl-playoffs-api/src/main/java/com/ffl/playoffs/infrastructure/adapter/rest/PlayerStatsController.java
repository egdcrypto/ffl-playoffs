package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.nfl.PlayerStatsDTO;
import com.ffl.playoffs.application.service.PlayerStatsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Player Statistics REST API
 * Provides endpoints for accessing NFL player weekly statistics
 * Uses MongoDB data synced by the Python nfl-data-sync service
 */
@RestController
@RequestMapping("/api/v1/nfl/stats")
@RequiredArgsConstructor
@Tag(name = "Player Stats", description = "Access NFL player weekly statistics synced from external data sources")
public class PlayerStatsController {

    private final PlayerStatsService statsService;

    @GetMapping("/week/{season}/{week}")
    @Operation(
            summary = "Get all stats for a week",
            description = "Returns all player statistics for a specific week in a season. Includes calculated fantasy points."
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved stats",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = PlayerStatsDTO.class)))
    })
    public ResponseEntity<List<PlayerStatsDTO>> getStatsByWeek(
            @Parameter(description = "NFL season year (e.g., 2024)", required = true)
            @PathVariable int season,

            @Parameter(description = "NFL week number (1-18 regular, 19-22 playoffs)", required = true)
            @PathVariable int week) {

        List<PlayerStatsDTO> stats = statsService.getAllStatsByWeek(season, week);
        return ResponseEntity.ok(stats);
    }

    @GetMapping("/week/{season}/{week}/paged")
    @Operation(
            summary = "Get stats for a week with pagination",
            description = "Returns paginated player statistics for a specific week in a season. Includes calculated fantasy points."
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved stats",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = Page.class)))
    })
    public ResponseEntity<Page<PlayerStatsDTO>> getStatsByWeekPaged(
            @Parameter(description = "NFL season year (e.g., 2024)", required = true)
            @PathVariable int season,

            @Parameter(description = "NFL week number (1-18 regular, 19-22 playoffs)", required = true)
            @PathVariable int week,

            @Parameter(description = "Page number (0-indexed)")
            @RequestParam(defaultValue = "0") int page,

            @Parameter(description = "Page size")
            @RequestParam(defaultValue = "50") int size) {

        Page<PlayerStatsDTO> stats = statsService.getStatsByWeek(season, week, page, size);
        return ResponseEntity.ok(stats);
    }

    @GetMapping("/player/{playerId}")
    @Operation(
            summary = "Get stats for a player",
            description = "Returns all weekly statistics for a specific player. Includes calculated fantasy points."
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved stats",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = PlayerStatsDTO.class)))
    })
    public ResponseEntity<List<PlayerStatsDTO>> getStatsByPlayer(
            @Parameter(description = "The player ID", required = true)
            @PathVariable String playerId) {

        List<PlayerStatsDTO> stats = statsService.getAllStatsByPlayer(playerId);
        return ResponseEntity.ok(stats);
    }

    @GetMapping("/player/{playerId}/season/{season}")
    @Operation(
            summary = "Get stats for a player in a season",
            description = "Returns all weekly statistics for a specific player in a season. Includes calculated fantasy points."
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved stats",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = PlayerStatsDTO.class)))
    })
    public ResponseEntity<List<PlayerStatsDTO>> getStatsByPlayerAndSeason(
            @Parameter(description = "The player ID", required = true)
            @PathVariable String playerId,

            @Parameter(description = "NFL season year (e.g., 2024)", required = true)
            @PathVariable int season) {

        List<PlayerStatsDTO> stats = statsService.getStatsByPlayerAndSeason(playerId, season);
        return ResponseEntity.ok(stats);
    }

    @GetMapping("/player/{playerId}/week/{season}/{week}")
    @Operation(
            summary = "Get stats for a player in a specific week",
            description = "Returns statistics for a specific player in a specific week. Includes calculated fantasy points."
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved stats",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = PlayerStatsDTO.class))),
            @ApiResponse(responseCode = "404", description = "Stats not found")
    })
    public ResponseEntity<PlayerStatsDTO> getStatsByPlayerAndWeek(
            @Parameter(description = "The player ID", required = true)
            @PathVariable String playerId,

            @Parameter(description = "NFL season year (e.g., 2024)", required = true)
            @PathVariable int season,

            @Parameter(description = "NFL week number (1-18 regular, 19-22 playoffs)", required = true)
            @PathVariable int week) {

        return statsService.getStatsByPlayerAndWeek(playerId, season, week)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/position/{position}/week/{season}/{week}")
    @Operation(
            summary = "Get stats by position for a week",
            description = "Returns all player statistics for a specific position in a week. Includes calculated fantasy points."
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved stats",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = PlayerStatsDTO.class)))
    })
    public ResponseEntity<List<PlayerStatsDTO>> getStatsByPosition(
            @Parameter(description = "Position (QB, RB, WR, TE, K, DEF)", required = true)
            @PathVariable String position,

            @Parameter(description = "NFL season year (e.g., 2024)", required = true)
            @PathVariable int season,

            @Parameter(description = "NFL week number (1-18 regular, 19-22 playoffs)", required = true)
            @PathVariable int week) {

        List<PlayerStatsDTO> stats = statsService.getStatsByPosition(position, season, week);
        return ResponseEntity.ok(stats);
    }

    @GetMapping("/team/{team}/week/{season}/{week}")
    @Operation(
            summary = "Get stats by team for a week",
            description = "Returns all player statistics for players on a specific team in a week. Includes calculated fantasy points."
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved stats",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = PlayerStatsDTO.class)))
    })
    public ResponseEntity<List<PlayerStatsDTO>> getStatsByTeam(
            @Parameter(description = "Team abbreviation (e.g., KC, SF, BUF)", required = true)
            @PathVariable String team,

            @Parameter(description = "NFL season year (e.g., 2024)", required = true)
            @PathVariable int season,

            @Parameter(description = "NFL week number (1-18 regular, 19-22 playoffs)", required = true)
            @PathVariable int week) {

        List<PlayerStatsDTO> stats = statsService.getStatsByTeam(team, season, week);
        return ResponseEntity.ok(stats);
    }

    @GetMapping("/top-scorers/week/{season}/{week}")
    @Operation(
            summary = "Get top scorers for a week",
            description = "Returns the top scoring players for a specific week based on touchdowns"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved stats",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = PlayerStatsDTO.class)))
    })
    public ResponseEntity<List<PlayerStatsDTO>> getTopScorersByWeek(
            @Parameter(description = "NFL season year (e.g., 2024)", required = true)
            @PathVariable int season,

            @Parameter(description = "NFL week number (1-18 regular, 19-22 playoffs)", required = true)
            @PathVariable int week,

            @Parameter(description = "Number of top scorers to return")
            @RequestParam(defaultValue = "10") int limit) {

        List<PlayerStatsDTO> stats = statsService.getTopScorersByWeek(season, week, limit);
        return ResponseEntity.ok(stats);
    }
}

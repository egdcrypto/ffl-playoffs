package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.nfl.NFLGameDTO;
import com.ffl.playoffs.application.service.NFLGameService;
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
 * NFL Game REST API
 * Provides endpoints for accessing NFL game schedule and scores
 * Uses MongoDB data synced by the Python nfl-data-sync service
 */
@RestController
@RequestMapping("/api/v1/nfl/games")
@RequiredArgsConstructor
@Tag(name = "NFL Games", description = "Access NFL game schedules and scores synced from external data sources")
public class NFLGameController {

    private final NFLGameService gameService;

    @GetMapping
    @Operation(
            summary = "List NFL games",
            description = "Lists NFL games with optional season and week filters. Returns game schedule and scores from the MongoDB sync."
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved games",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = Page.class)))
    })
    public ResponseEntity<Page<NFLGameDTO>> listGames(
            @Parameter(description = "NFL season year (e.g., 2024)")
            @RequestParam(required = false) Integer season,

            @Parameter(description = "NFL week number (1-18 regular, 19-22 playoffs)")
            @RequestParam(required = false) Integer week,

            @Parameter(description = "Page number (0-indexed)")
            @RequestParam(defaultValue = "0") int page,

            @Parameter(description = "Page size")
            @RequestParam(defaultValue = "20") int size) {

        Page<NFLGameDTO> result = gameService.getGames(season, week, page, size);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/{gameId}")
    @Operation(
            summary = "Get NFL game by ID",
            description = "Retrieves detailed information about a specific NFL game by its game ID"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved game",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = NFLGameDTO.class))),
            @ApiResponse(responseCode = "404", description = "Game not found")
    })
    public ResponseEntity<NFLGameDTO> getGame(
            @Parameter(description = "The game ID", required = true)
            @PathVariable String gameId) {

        return gameService.getGameById(gameId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/week/{season}/{week}")
    @Operation(
            summary = "Get games for a specific week",
            description = "Returns all NFL games scheduled for a specific week in a season"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved games",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = NFLGameDTO.class)))
    })
    public ResponseEntity<List<NFLGameDTO>> getGamesByWeek(
            @Parameter(description = "NFL season year (e.g., 2024)", required = true)
            @PathVariable int season,

            @Parameter(description = "NFL week number (1-18 regular, 19-22 playoffs)", required = true)
            @PathVariable int week) {

        List<NFLGameDTO> games = gameService.getGamesByWeek(season, week);
        return ResponseEntity.ok(games);
    }

    @GetMapping("/active")
    @Operation(
            summary = "Get currently active games",
            description = "Returns all NFL games that are currently in progress or at halftime"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved active games",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = NFLGameDTO.class)))
    })
    public ResponseEntity<List<NFLGameDTO>> getActiveGames() {
        List<NFLGameDTO> games = gameService.getActiveGames();
        return ResponseEntity.ok(games);
    }

    @GetMapping("/status/{status}")
    @Operation(
            summary = "Get games by status",
            description = "Returns all NFL games with a specific status (SCHEDULED, IN_PROGRESS, HALFTIME, FINAL, POSTPONED, CANCELLED)"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved games",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = NFLGameDTO.class)))
    })
    public ResponseEntity<List<NFLGameDTO>> getGamesByStatus(
            @Parameter(description = "Game status (SCHEDULED, IN_PROGRESS, HALFTIME, FINAL, POSTPONED, CANCELLED)", required = true)
            @PathVariable String status) {

        List<NFLGameDTO> games = gameService.getGamesByStatus(status);
        return ResponseEntity.ok(games);
    }

    @GetMapping("/team/{team}/season/{season}")
    @Operation(
            summary = "Get games for a team in a season",
            description = "Returns all NFL games involving a specific team in a season"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved games",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = NFLGameDTO.class)))
    })
    public ResponseEntity<List<NFLGameDTO>> getGamesByTeam(
            @Parameter(description = "Team abbreviation (e.g., KC, SF, BUF)", required = true)
            @PathVariable String team,

            @Parameter(description = "NFL season year (e.g., 2024)", required = true)
            @PathVariable int season) {

        List<NFLGameDTO> games = gameService.getGamesByTeam(team, season);
        return ResponseEntity.ok(games);
    }
}

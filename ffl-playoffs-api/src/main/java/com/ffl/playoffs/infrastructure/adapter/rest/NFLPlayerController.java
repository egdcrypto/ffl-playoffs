package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.nfl.NFLPlayerDTO;
import com.ffl.playoffs.application.service.NFLPlayerService;
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

/**
 * NFL Player REST API
 * Provides endpoints for browsing and searching NFL players
 * Uses MongoDB data synced by the Python nfl-data-sync service
 */
@RestController
@RequestMapping("/api/v1/nfl/players")
@RequiredArgsConstructor
@Tag(name = "NFL Players", description = "Browse and search NFL players synced from external data sources")
public class NFLPlayerController {

    private final NFLPlayerService playerService;
    private final PlayerStatsService statsService;

    @GetMapping
    @Operation(
            summary = "List all NFL players",
            description = "Lists NFL players with pagination. Returns player roster information from the MongoDB sync."
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved players",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = Page.class)))
    })
    public ResponseEntity<Page<NFLPlayerDTO>> listPlayers(
            @Parameter(description = "Page number (0-indexed)")
            @RequestParam(defaultValue = "0") int page,

            @Parameter(description = "Page size")
            @RequestParam(defaultValue = "20") int size) {

        Page<NFLPlayerDTO> result = playerService.getAllPlayers(page, size);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/{playerId}")
    @Operation(
            summary = "Get NFL player by ID",
            description = "Retrieves detailed information about a specific NFL player by their player ID"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved player",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = NFLPlayerDTO.class))),
            @ApiResponse(responseCode = "404", description = "Player not found")
    })
    public ResponseEntity<NFLPlayerDTO> getPlayer(
            @Parameter(description = "The player ID", required = true)
            @PathVariable String playerId) {

        return playerService.getPlayerById(playerId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/team/{team}")
    @Operation(
            summary = "Get players by team",
            description = "Lists all NFL players for a specific team by team abbreviation (e.g., KC, SF, BUF)"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved players",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = Page.class)))
    })
    public ResponseEntity<Page<NFLPlayerDTO>> getPlayersByTeam(
            @Parameter(description = "Team abbreviation (e.g., KC, SF, BUF)", required = true)
            @PathVariable String team,

            @Parameter(description = "Page number (0-indexed)")
            @RequestParam(defaultValue = "0") int page,

            @Parameter(description = "Page size")
            @RequestParam(defaultValue = "50") int size) {

        Page<NFLPlayerDTO> result = playerService.getPlayersByTeam(team, page, size);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/position/{position}")
    @Operation(
            summary = "Get players by position",
            description = "Lists all NFL players for a specific position (QB, RB, WR, TE, K, DEF)"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved players",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = Page.class)))
    })
    public ResponseEntity<Page<NFLPlayerDTO>> getPlayersByPosition(
            @Parameter(description = "Position (QB, RB, WR, TE, K, DEF)", required = true)
            @PathVariable String position,

            @Parameter(description = "Page number (0-indexed)")
            @RequestParam(defaultValue = "0") int page,

            @Parameter(description = "Page size")
            @RequestParam(defaultValue = "50") int size) {

        Page<NFLPlayerDTO> result = playerService.getPlayersByPosition(position, page, size);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/search")
    @Operation(
            summary = "Search players by name",
            description = "Search for NFL players by name (case-insensitive partial match)"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved players",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = Page.class)))
    })
    public ResponseEntity<Page<NFLPlayerDTO>> searchPlayers(
            @Parameter(description = "Search query (player name)", required = true)
            @RequestParam String query,

            @Parameter(description = "Page number (0-indexed)")
            @RequestParam(defaultValue = "0") int page,

            @Parameter(description = "Page size")
            @RequestParam(defaultValue = "20") int size) {

        Page<NFLPlayerDTO> result = playerService.searchPlayersByName(query, page, size);
        return ResponseEntity.ok(result);
    }
}

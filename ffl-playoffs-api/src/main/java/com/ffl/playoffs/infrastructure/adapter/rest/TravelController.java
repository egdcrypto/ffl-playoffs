package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.TravelRouteDTO;
import com.ffl.playoffs.application.usecase.CalculateTravelUseCase;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Travel REST API.
 * Provides endpoints for calculating travel routes and fatigue.
 */
@RestController
@RequestMapping("/api/v1/travel")
@RequiredArgsConstructor
@Tag(name = "Travel", description = "Travel routes and fatigue calculations")
public class TravelController {

    private final CalculateTravelUseCase calculateTravelUseCase;

    @GetMapping("/route")
    @Operation(
            summary = "Calculate travel route",
            description = "Calculates travel route between two stadiums with distance and fatigue"
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Route calculated"),
            @ApiResponse(responseCode = "404", description = "Stadium not found")
    })
    public ResponseEntity<TravelRouteDTO> calculateRoute(
            @Parameter(description = "Origin stadium code")
            @RequestParam String from,

            @Parameter(description = "Destination stadium code")
            @RequestParam String to) {

        return calculateTravelUseCase.calculateRoute(from, to)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/route/teams")
    @Operation(
            summary = "Calculate travel between teams",
            description = "Calculates travel route between two teams' home stadiums"
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Route calculated"),
            @ApiResponse(responseCode = "404", description = "Team stadium not found")
    })
    public ResponseEntity<TravelRouteDTO> calculateTeamTravel(
            @Parameter(description = "Origin team abbreviation")
            @RequestParam String fromTeam,

            @Parameter(description = "Destination team abbreviation")
            @RequestParam String toTeam) {

        return calculateTravelUseCase.calculateTeamTravel(fromTeam, toTeam)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/fatigue")
    @Operation(
            summary = "Get travel fatigue modifier",
            description = "Calculates performance modifier based on travel and rest days"
    )
    @ApiResponse(responseCode = "200", description = "Fatigue modifier calculated")
    public ResponseEntity<FatigueInfo> getTravelFatigue(
            @Parameter(description = "Origin stadium code")
            @RequestParam String from,

            @Parameter(description = "Destination stadium code")
            @RequestParam String to,

            @Parameter(description = "Days since travel")
            @RequestParam int daysSinceTravel) {

        double modifier = calculateTravelUseCase.getTravelFatigueModifier(from, to, daysSinceTravel);
        return ResponseEntity.ok(new FatigueInfo(modifier, daysSinceTravel));
    }

    @GetMapping("/routes/from/{stadiumCode}")
    @Operation(
            summary = "Get all routes from stadium",
            description = "Returns travel routes from a stadium to all other stadiums"
    )
    @ApiResponse(responseCode = "200", description = "Routes retrieved")
    public ResponseEntity<List<TravelRouteDTO>> getRoutesFromStadium(
            @Parameter(description = "Origin stadium code")
            @PathVariable String stadiumCode) {

        return ResponseEntity.ok(calculateTravelUseCase.getRoutesFromStadium(stadiumCode));
    }

    @GetMapping("/routes/team/{teamAbbr}")
    @Operation(
            summary = "Get all routes for team",
            description = "Returns travel routes from a team's home stadium to all away stadiums"
    )
    @ApiResponse(responseCode = "200", description = "Routes retrieved")
    public ResponseEntity<List<TravelRouteDTO>> getRoutesForTeam(
            @Parameter(description = "Team abbreviation")
            @PathVariable String teamAbbr) {

        return ResponseEntity.ok(calculateTravelUseCase.getRoutesForTeam(teamAbbr));
    }

    @GetMapping("/longest")
    @Operation(
            summary = "Get longest travel routes",
            description = "Returns the longest travel routes in the NFL"
    )
    @ApiResponse(responseCode = "200", description = "Routes retrieved")
    public ResponseEntity<List<TravelRouteDTO>> getLongestRoutes(
            @Parameter(description = "Number of routes to return")
            @RequestParam(defaultValue = "10") int limit) {

        return ResponseEntity.ok(calculateTravelUseCase.getLongestRoutes(limit));
    }

    @GetMapping("/coast-to-coast")
    @Operation(
            summary = "Get coast-to-coast routes",
            description = "Returns routes crossing 3+ time zones"
    )
    @ApiResponse(responseCode = "200", description = "Routes retrieved")
    public ResponseEntity<List<TravelRouteDTO>> getCoastToCoastRoutes() {
        return ResponseEntity.ok(calculateTravelUseCase.getCoastToCoastRoutes());
    }

    @GetMapping("/difficulty")
    @Operation(
            summary = "Get travel difficulty score",
            description = "Returns a 0-100 difficulty score for a travel route"
    )
    @ApiResponse(responseCode = "200", description = "Difficulty calculated")
    public ResponseEntity<DifficultyInfo> getTravelDifficulty(
            @Parameter(description = "Origin stadium code")
            @RequestParam String from,

            @Parameter(description = "Destination stadium code")
            @RequestParam String to) {

        int score = calculateTravelUseCase.getTravelDifficultyScore(from, to);
        int restDays = calculateTravelUseCase.getRecommendedRestDays(from, to);
        return ResponseEntity.ok(new DifficultyInfo(score, restDays));
    }

    /**
     * Response record for fatigue information.
     */
    public record FatigueInfo(double performanceModifier, int daysSinceTravel) {
    }

    /**
     * Response record for travel difficulty.
     */
    public record DifficultyInfo(int difficultyScore, int recommendedRestDays) {
    }
}

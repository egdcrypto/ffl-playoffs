package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.StadiumDTO;
import com.ffl.playoffs.application.dto.WeatherZoneDTO;
import com.ffl.playoffs.application.usecase.GetStadiumUseCase;
import com.ffl.playoffs.domain.model.VenueType;
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
 * Stadium REST API.
 * Provides endpoints for retrieving NFL stadium and venue information.
 */
@RestController
@RequestMapping("/api/v1/stadiums")
@RequiredArgsConstructor
@Tag(name = "Stadiums", description = "NFL stadium and venue information")
public class StadiumController {

    private final GetStadiumUseCase getStadiumUseCase;

    @GetMapping
    @Operation(
            summary = "List all stadiums",
            description = "Returns all NFL stadiums with venue details"
    )
    @ApiResponse(responseCode = "200", description = "Successfully retrieved stadiums")
    public ResponseEntity<List<StadiumDTO>> listStadiums() {
        return ResponseEntity.ok(getStadiumUseCase.getAll());
    }

    @GetMapping("/{code}")
    @Operation(
            summary = "Get stadium by code",
            description = "Returns stadium details by unique code"
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Stadium found"),
            @ApiResponse(responseCode = "404", description = "Stadium not found")
    })
    public ResponseEntity<StadiumDTO> getByCode(
            @Parameter(description = "Stadium code (e.g., LAMBEAU, ARROWHEAD)")
            @PathVariable String code) {
        return getStadiumUseCase.getByCode(code)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/team/{teamAbbr}")
    @Operation(
            summary = "Get stadium by team",
            description = "Returns the home stadium for a specific NFL team"
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Stadium found"),
            @ApiResponse(responseCode = "404", description = "Stadium not found for team")
    })
    public ResponseEntity<StadiumDTO> getByTeam(
            @Parameter(description = "Team abbreviation (e.g., KC, GB, NE)")
            @PathVariable String teamAbbr) {
        return getStadiumUseCase.getByTeam(teamAbbr)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/outdoor")
    @Operation(
            summary = "List outdoor stadiums",
            description = "Returns all outdoor stadiums exposed to weather"
    )
    @ApiResponse(responseCode = "200", description = "Successfully retrieved outdoor stadiums")
    public ResponseEntity<List<StadiumDTO>> listOutdoorStadiums() {
        return ResponseEntity.ok(getStadiumUseCase.getOutdoorStadiums());
    }

    @GetMapping("/domes")
    @Operation(
            summary = "List dome stadiums",
            description = "Returns all climate-controlled dome stadiums"
    )
    @ApiResponse(responseCode = "200", description = "Successfully retrieved dome stadiums")
    public ResponseEntity<List<StadiumDTO>> listDomeStadiums() {
        return ResponseEntity.ok(getStadiumUseCase.getDomeStadiums());
    }

    @GetMapping("/retractable")
    @Operation(
            summary = "List retractable roof stadiums",
            description = "Returns all stadiums with retractable roofs"
    )
    @ApiResponse(responseCode = "200", description = "Successfully retrieved retractable roof stadiums")
    public ResponseEntity<List<StadiumDTO>> listRetractableRoofStadiums() {
        return ResponseEntity.ok(getStadiumUseCase.getRetractableRoofStadiums());
    }

    @GetMapping("/venue-type/{type}")
    @Operation(
            summary = "List stadiums by venue type",
            description = "Returns stadiums filtered by venue type"
    )
    @ApiResponse(responseCode = "200", description = "Successfully retrieved stadiums")
    public ResponseEntity<List<StadiumDTO>> listByVenueType(
            @Parameter(description = "Venue type (OUTDOOR, DOME, RETRACTABLE)")
            @PathVariable VenueType type) {
        return ResponseEntity.ok(getStadiumUseCase.getByVenueType(type));
    }

    @GetMapping("/{code}/altitude")
    @Operation(
            summary = "Check if stadium is high altitude",
            description = "Returns altitude information and kicking modifier"
    )
    public ResponseEntity<AltitudeInfo> getAltitudeInfo(
            @Parameter(description = "Stadium code")
            @PathVariable String code) {
        boolean isHigh = getStadiumUseCase.isHighAltitude(code);
        double modifier = getStadiumUseCase.getAltitudeKickingModifier(code);
        return ResponseEntity.ok(new AltitudeInfo(isHigh, modifier));
    }

    // Weather zone endpoints

    @GetMapping("/weather-zones")
    @Operation(
            summary = "List all weather zones",
            description = "Returns all climate zones used by NFL stadiums"
    )
    @ApiResponse(responseCode = "200", description = "Successfully retrieved weather zones")
    public ResponseEntity<List<WeatherZoneDTO>> listWeatherZones() {
        return ResponseEntity.ok(getStadiumUseCase.getAllWeatherZones());
    }

    @GetMapping("/weather-zones/{code}")
    @Operation(
            summary = "Get weather zone by code",
            description = "Returns weather zone details"
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Weather zone found"),
            @ApiResponse(responseCode = "404", description = "Weather zone not found")
    })
    public ResponseEntity<WeatherZoneDTO> getWeatherZone(
            @Parameter(description = "Weather zone code (e.g., GREAT_LAKES, TROPICAL)")
            @PathVariable String code) {
        return getStadiumUseCase.getWeatherZone(code)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/weather-zones/{code}/stadiums")
    @Operation(
            summary = "List stadiums in weather zone",
            description = "Returns all stadiums in a specific weather zone"
    )
    @ApiResponse(responseCode = "200", description = "Successfully retrieved stadiums")
    public ResponseEntity<List<StadiumDTO>> listByWeatherZone(
            @Parameter(description = "Weather zone code")
            @PathVariable String code) {
        return ResponseEntity.ok(getStadiumUseCase.getByWeatherZone(code));
    }

    /**
     * Response record for altitude information.
     */
    public record AltitudeInfo(boolean isHighAltitude, double kickingModifier) {
    }
}

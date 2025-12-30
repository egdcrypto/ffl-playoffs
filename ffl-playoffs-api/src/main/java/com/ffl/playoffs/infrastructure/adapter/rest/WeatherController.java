package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.WeatherConditionsDTO;
import com.ffl.playoffs.application.usecase.GenerateWeatherUseCase;
import com.ffl.playoffs.domain.port.WeatherService.WeatherStatModifiers;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

/**
 * Weather REST API.
 * Provides endpoints for generating and retrieving weather conditions.
 */
@RestController
@RequestMapping("/api/v1/weather")
@RequiredArgsConstructor
@Tag(name = "Weather", description = "Weather generation and conditions")
public class WeatherController {

    private final GenerateWeatherUseCase generateWeatherUseCase;

    @GetMapping("/generate/{stadiumCode}")
    @Operation(
            summary = "Generate weather for stadium",
            description = "Generates weather conditions for a game at the specified stadium"
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Weather generated"),
            @ApiResponse(responseCode = "404", description = "Stadium not found")
    })
    public ResponseEntity<WeatherConditionsDTO> generateWeather(
            @Parameter(description = "Stadium code")
            @PathVariable String stadiumCode,

            @Parameter(description = "Month (1-12)")
            @RequestParam Integer month,

            @Parameter(description = "Random seed for reproducibility")
            @RequestParam(required = false) Long seed) {

        return generateWeatherUseCase.generateGameWeather(stadiumCode, month, seed)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/generate/team/{teamAbbr}")
    @Operation(
            summary = "Generate weather for team's home stadium",
            description = "Generates weather conditions for a game at a team's home stadium"
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Weather generated"),
            @ApiResponse(responseCode = "404", description = "Stadium not found for team")
    })
    public ResponseEntity<WeatherConditionsDTO> generateWeatherForTeam(
            @Parameter(description = "Team abbreviation")
            @PathVariable String teamAbbr,

            @Parameter(description = "Month (1-12)")
            @RequestParam Integer month) {

        return generateWeatherUseCase.generateWeatherForTeam(teamAbbr, month)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/historical/{stadiumCode}")
    @Operation(
            summary = "Get historical weather",
            description = "Retrieves weather conditions for a specific date at a stadium"
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Weather retrieved"),
            @ApiResponse(responseCode = "404", description = "Stadium not found")
    })
    public ResponseEntity<WeatherConditionsDTO> getHistoricalWeather(
            @Parameter(description = "Stadium code")
            @PathVariable String stadiumCode,

            @Parameter(description = "Date (yyyy-MM-dd)")
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {

        return generateWeatherUseCase.getHistoricalWeather(stadiumCode, date)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/modifiers/{stadiumCode}")
    @Operation(
            summary = "Get weather stat modifiers",
            description = "Calculates stat modifiers for weather conditions at a stadium"
    )
    @ApiResponse(responseCode = "200", description = "Modifiers calculated")
    public ResponseEntity<WeatherStatModifiers> getStatModifiers(
            @Parameter(description = "Stadium code")
            @PathVariable String stadiumCode,

            @Parameter(description = "Month (1-12)")
            @RequestParam Integer month) {

        return ResponseEntity.ok(generateWeatherUseCase.getStatModifiers(stadiumCode, month));
    }

    @GetMapping("/threat-check/{stadiumCode}")
    @Operation(
            summary = "Check for game-threatening weather",
            description = "Determines if weather could potentially postpone a game"
    )
    @ApiResponse(responseCode = "200", description = "Threat check completed")
    public ResponseEntity<WeatherThreatInfo> checkWeatherThreat(
            @Parameter(description = "Stadium code")
            @PathVariable String stadiumCode,

            @Parameter(description = "Month (1-12)")
            @RequestParam Integer month) {

        boolean isThreat = generateWeatherUseCase.isGameThreateningWeather(stadiumCode, month);
        return ResponseEntity.ok(new WeatherThreatInfo(isThreat));
    }

    @GetMapping("/ideal")
    @Operation(
            summary = "Get ideal weather conditions",
            description = "Returns reference ideal weather conditions (dome-like)"
    )
    @ApiResponse(responseCode = "200", description = "Ideal conditions returned")
    public ResponseEntity<WeatherConditionsDTO> getIdealConditions() {
        return ResponseEntity.ok(generateWeatherUseCase.getIdealConditions());
    }

    /**
     * Response record for weather threat information.
     */
    public record WeatherThreatInfo(boolean isGameThreatening) {
    }
}

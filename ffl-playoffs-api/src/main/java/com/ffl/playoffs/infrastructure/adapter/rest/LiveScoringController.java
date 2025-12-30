package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.LiveLeaderboardDTO;
import com.ffl.playoffs.application.dto.LiveScoreDTO;
import com.ffl.playoffs.application.dto.NotificationPreferencesDTO;
import com.ffl.playoffs.application.service.LiveLeaderboardService;
import com.ffl.playoffs.application.service.LiveScoringService;
import com.ffl.playoffs.application.service.PushNotificationService;
import com.ffl.playoffs.infrastructure.scheduler.LiveScoringScheduler;
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

import java.util.Map;

/**
 * REST API for Live Scoring operations
 * Provides endpoints for real-time score data and leaderboard
 */
@RestController
@RequestMapping("/api/v1/live-scores")
@RequiredArgsConstructor
@Tag(name = "Live Scoring", description = "Real-time score updates and leaderboard data")
public class LiveScoringController {

    private final LiveScoringService liveScoringService;
    private final LiveLeaderboardService leaderboardService;
    private final PushNotificationService notificationService;
    private final LiveScoringScheduler scheduler;

    @GetMapping("/leagues/{leagueId}/leaderboard")
    @Operation(
            summary = "Get live leaderboard",
            description = "Returns the current live leaderboard with real-time scores and rankings"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved leaderboard",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = LiveLeaderboardDTO.class)))
    })
    public ResponseEntity<LiveLeaderboardDTO> getLiveLeaderboard(
            @Parameter(description = "League ID", required = true)
            @PathVariable String leagueId,

            @Parameter(description = "Page number (0-indexed)")
            @RequestParam(defaultValue = "0") int page,

            @Parameter(description = "Page size")
            @RequestParam(defaultValue = "25") int size) {

        LiveLeaderboardDTO leaderboard = leaderboardService.getLeaderboard(leagueId, page, size);
        return ResponseEntity.ok(leaderboard);
    }

    @GetMapping("/leagues/{leagueId}/matchup")
    @Operation(
            summary = "Get matchup leaderboard",
            description = "Returns head-to-head matchup between two players"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved matchup")
    })
    public ResponseEntity<LiveLeaderboardDTO> getMatchupLeaderboard(
            @Parameter(description = "League ID", required = true)
            @PathVariable String leagueId,

            @Parameter(description = "First player ID", required = true)
            @RequestParam String player1Id,

            @Parameter(description = "Second player ID", required = true)
            @RequestParam String player2Id) {

        LiveLeaderboardDTO matchup = leaderboardService.getMatchupLeaderboard(leagueId, player1Id, player2Id);
        return ResponseEntity.ok(matchup);
    }

    @GetMapping("/players/{leaguePlayerId}")
    @Operation(
            summary = "Get player's live score",
            description = "Returns current live score for a specific league player"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved score",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = LiveScoreDTO.class))),
            @ApiResponse(responseCode = "404", description = "Player not found")
    })
    public ResponseEntity<LiveScoreDTO> getPlayerLiveScore(
            @Parameter(description = "League Player ID", required = true)
            @PathVariable String leaguePlayerId) {

        return liveScoringService.getLiveScore(leaguePlayerId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/players/{leaguePlayerId}/snapshot")
    @Operation(
            summary = "Get score snapshot",
            description = "Returns a score snapshot for reconnecting clients"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved snapshot")
    })
    public ResponseEntity<LiveScoreDTO> getScoreSnapshot(
            @Parameter(description = "League Player ID", required = true)
            @PathVariable String leaguePlayerId) {

        LiveScoreDTO snapshot = liveScoringService.getScoreSnapshot(leaguePlayerId);
        return ResponseEntity.ok(snapshot);
    }

    @GetMapping("/status")
    @Operation(
            summary = "Get polling status",
            description = "Returns current status of the live scoring polling service"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved status")
    })
    public ResponseEntity<LiveScoringScheduler.PollingStatus> getPollingStatus() {
        return ResponseEntity.ok(scheduler.getPollingStatus());
    }

    @PostMapping("/admin/trigger-poll")
    @Operation(
            summary = "Trigger manual poll",
            description = "Manually triggers a score polling cycle (admin only)"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Poll triggered successfully")
    })
    public ResponseEntity<Map<String, String>> triggerPoll() {
        scheduler.triggerPoll();
        return ResponseEntity.ok(Map.of("status", "Poll triggered"));
    }

    @PostMapping("/admin/clear-cache/{leagueId}")
    @Operation(
            summary = "Clear score cache",
            description = "Clears cached scores for a league (admin only)"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Cache cleared successfully")
    })
    public ResponseEntity<Map<String, String>> clearCache(
            @Parameter(description = "League ID", required = true)
            @PathVariable String leagueId) {

        liveScoringService.clearCaches(leagueId);
        leaderboardService.clearCache(leagueId);
        return ResponseEntity.ok(Map.of("status", "Cache cleared for league " + leagueId));
    }

    @PutMapping("/admin/week/{week}")
    @Operation(
            summary = "Set current week",
            description = "Updates the current NFL week for polling (admin only)"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Week updated successfully")
    })
    public ResponseEntity<Map<String, String>> setCurrentWeek(
            @Parameter(description = "Week number", required = true)
            @PathVariable int week) {

        scheduler.setCurrentWeek(week);
        return ResponseEntity.ok(Map.of("status", "Current week set to " + week));
    }

    // Notification preference endpoints

    @GetMapping("/notifications/preferences/{userId}")
    @Operation(
            summary = "Get notification preferences",
            description = "Returns notification preferences for a user"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved preferences",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = NotificationPreferencesDTO.class)))
    })
    public ResponseEntity<NotificationPreferencesDTO> getNotificationPreferences(
            @Parameter(description = "User ID", required = true)
            @PathVariable String userId) {

        NotificationPreferencesDTO prefs = notificationService.getPreferences(userId);
        return ResponseEntity.ok(prefs);
    }

    @PutMapping("/notifications/preferences/{userId}")
    @Operation(
            summary = "Update notification preferences",
            description = "Updates notification preferences for a user"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Preferences updated successfully")
    })
    public ResponseEntity<NotificationPreferencesDTO> updateNotificationPreferences(
            @Parameter(description = "User ID", required = true)
            @PathVariable String userId,

            @RequestBody NotificationPreferencesDTO preferences) {

        notificationService.updatePreferences(userId, preferences);
        return ResponseEntity.ok(preferences);
    }

    @PostMapping("/notifications/devices")
    @Operation(
            summary = "Register device for push notifications",
            description = "Registers a device token for receiving push notifications"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Device registered successfully")
    })
    public ResponseEntity<Map<String, String>> registerDevice(
            @RequestBody DeviceRegistrationRequest request) {

        notificationService.registerDevice(request.userId(), request.deviceToken(), request.platform());
        return ResponseEntity.ok(Map.of("status", "Device registered"));
    }

    public record DeviceRegistrationRequest(
            String userId,
            String deviceToken,
            String platform
    ) {}
}

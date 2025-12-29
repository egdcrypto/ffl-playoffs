package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.usecase.*;
import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.model.PlayerInvitation;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import com.ffl.playoffs.domain.port.LeagueRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * REST Controller for Admin League Management.
 * Provides endpoints for league lifecycle, player invitations, and configuration.
 */
@RestController
@RequestMapping("/api/v1/admin/leagues")
@RequiredArgsConstructor
@Tag(name = "Admin League Management", description = "APIs for admins to manage their leagues")
public class AdminLeagueController {

    private final LeagueLifecycleUseCase leagueLifecycleUseCase;
    private final InvitePlayerToLeagueUseCase invitePlayerUseCase;
    private final AcceptLeagueInvitationUseCase acceptInvitationUseCase;
    private final ConfigureLeagueScoringUseCase configureScoringUseCase;
    private final CloneLeagueSettingsUseCase cloneLeagueUseCase;
    private final RemovePlayerFromLeagueUseCase removePlayerUseCase;
    private final LeagueRepository leagueRepository;
    private final LeaguePlayerRepository leaguePlayerRepository;

    // ==================== League Lifecycle ====================

    @PostMapping("/{leagueId}/activate")
    @Operation(summary = "Activate a league", description = "Activates a league so players can make selections")
    public ResponseEntity<LeagueResponse> activateLeague(
            @PathVariable UUID leagueId,
            @RequestHeader("X-Admin-User-Id") UUID adminUserId) {

        LeagueLifecycleUseCase.LifecycleCommand command =
                new LeagueLifecycleUseCase.LifecycleCommand(leagueId, adminUserId);
        League league = leagueLifecycleUseCase.activate(command);
        return ResponseEntity.ok(toLeagueResponse(league));
    }

    @PostMapping("/{leagueId}/deactivate")
    @Operation(summary = "Deactivate a league", description = "Deactivates a league, preventing new selections")
    public ResponseEntity<LeagueResponse> deactivateLeague(
            @PathVariable UUID leagueId,
            @RequestHeader("X-Admin-User-Id") UUID adminUserId) {

        LeagueLifecycleUseCase.LifecycleCommand command =
                new LeagueLifecycleUseCase.LifecycleCommand(leagueId, adminUserId);
        League league = leagueLifecycleUseCase.deactivate(command);
        return ResponseEntity.ok(toLeagueResponse(league));
    }

    @PostMapping("/{leagueId}/archive")
    @Operation(summary = "Archive a league", description = "Archives a league for historical viewing")
    public ResponseEntity<LeagueResponse> archiveLeague(
            @PathVariable UUID leagueId,
            @RequestHeader("X-Admin-User-Id") UUID adminUserId) {

        LeagueLifecycleUseCase.LifecycleCommand command =
                new LeagueLifecycleUseCase.LifecycleCommand(leagueId, adminUserId);
        League league = leagueLifecycleUseCase.archive(command);
        return ResponseEntity.ok(toLeagueResponse(league));
    }

    // ==================== Player Invitations ====================

    @PostMapping("/{leagueId}/invitations")
    @Operation(summary = "Invite a player", description = "Sends an invitation to a player to join the league")
    public ResponseEntity<InvitationResponse> invitePlayer(
            @PathVariable UUID leagueId,
            @RequestHeader("X-Admin-User-Id") UUID adminUserId,
            @RequestBody InvitePlayerRequest request) {

        InvitePlayerToLeagueUseCase.InvitePlayerCommand command =
                new InvitePlayerToLeagueUseCase.InvitePlayerCommand(
                        leagueId, request.getEmail(), adminUserId);
        PlayerInvitation invitation = invitePlayerUseCase.execute(command);
        return ResponseEntity.status(HttpStatus.CREATED).body(toInvitationResponse(invitation));
    }

    @PostMapping("/invitations/accept")
    @Operation(summary = "Accept an invitation", description = "Accepts a league invitation using the token")
    public ResponseEntity<AcceptInvitationResponse> acceptInvitation(
            @RequestBody AcceptInvitationRequest request) {

        AcceptLeagueInvitationUseCase.AcceptInvitationCommand command =
                new AcceptLeagueInvitationUseCase.AcceptInvitationCommand(
                        request.getInvitationToken(),
                        request.getEmail(),
                        request.getDisplayName(),
                        request.getGoogleId()
                );
        AcceptLeagueInvitationUseCase.AcceptInvitationResult result =
                acceptInvitationUseCase.execute(command);

        return ResponseEntity.ok(new AcceptInvitationResponse(
                result.getUser().getId(),
                result.getLeague().getId(),
                result.getLeague().getName(),
                result.isNewUser()
        ));
    }

    // ==================== Player Management ====================

    @GetMapping("/{leagueId}/players")
    @Operation(summary = "List league players", description = "Returns all players in the league")
    public ResponseEntity<List<LeaguePlayerResponse>> listPlayers(
            @PathVariable UUID leagueId,
            @RequestHeader("X-Admin-User-Id") UUID adminUserId) {

        // Validate admin owns the league
        League league = leagueRepository.findById(leagueId)
                .orElseThrow(() -> new IllegalArgumentException("League not found"));
        if (!league.getOwnerId().equals(adminUserId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        List<LeaguePlayer> players = leaguePlayerRepository.findByLeagueId(leagueId);
        List<LeaguePlayerResponse> response = players.stream()
                .map(this::toLeaguePlayerResponse)
                .collect(Collectors.toList());

        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/{leagueId}/players/{userId}")
    @Operation(summary = "Remove a player", description = "Removes a player from the league")
    public ResponseEntity<LeaguePlayerResponse> removePlayer(
            @PathVariable UUID leagueId,
            @PathVariable UUID userId,
            @RequestHeader("X-Admin-User-Id") UUID adminUserId) {

        RemovePlayerFromLeagueUseCase.RemovePlayerCommand command =
                new RemovePlayerFromLeagueUseCase.RemovePlayerCommand(leagueId, userId, adminUserId);
        LeaguePlayer leaguePlayer = removePlayerUseCase.execute(command);
        return ResponseEntity.ok(toLeaguePlayerResponse(leaguePlayer));
    }

    // ==================== Scoring Configuration ====================

    @PutMapping("/{leagueId}/scoring/ppr")
    @Operation(summary = "Configure PPR scoring", description = "Updates PPR scoring rules for the league")
    public ResponseEntity<LeagueResponse> configurePPRScoring(
            @PathVariable UUID leagueId,
            @RequestHeader("X-Admin-User-Id") UUID adminUserId,
            @RequestBody ConfigurePPRRequest request) {

        ConfigureLeagueScoringUseCase.ConfigurePPRCommand command =
                new ConfigureLeagueScoringUseCase.ConfigurePPRCommand(
                        leagueId, adminUserId,
                        request.getPassingYardsPerPoint(),
                        request.getRushingYardsPerPoint(),
                        request.getReceivingYardsPerPoint(),
                        request.getReceptionPoints(),
                        request.getTouchdownPoints()
                );
        League league = configureScoringUseCase.configurePPRScoring(command);
        return ResponseEntity.ok(toLeagueResponse(league));
    }

    @PutMapping("/{leagueId}/scoring/field-goals")
    @Operation(summary = "Configure field goal scoring", description = "Updates field goal scoring rules")
    public ResponseEntity<LeagueResponse> configureFieldGoalScoring(
            @PathVariable UUID leagueId,
            @RequestHeader("X-Admin-User-Id") UUID adminUserId,
            @RequestBody ConfigureFieldGoalRequest request) {

        ConfigureLeagueScoringUseCase.ConfigureFieldGoalCommand command =
                new ConfigureLeagueScoringUseCase.ConfigureFieldGoalCommand(
                        leagueId, adminUserId,
                        request.getFg0to39Points(),
                        request.getFg40to49Points(),
                        request.getFg50PlusPoints()
                );
        League league = configureScoringUseCase.configureFieldGoalScoring(command);
        return ResponseEntity.ok(toLeagueResponse(league));
    }

    @PutMapping("/{leagueId}/scoring/defensive")
    @Operation(summary = "Configure defensive scoring", description = "Updates defensive scoring rules")
    public ResponseEntity<LeagueResponse> configureDefensiveScoring(
            @PathVariable UUID leagueId,
            @RequestHeader("X-Admin-User-Id") UUID adminUserId,
            @RequestBody ConfigureDefensiveRequest request) {

        ConfigureLeagueScoringUseCase.ConfigureDefensiveCommand command =
                new ConfigureLeagueScoringUseCase.ConfigureDefensiveCommand(
                        leagueId, adminUserId,
                        request.getSackPoints(),
                        request.getInterceptionPoints(),
                        request.getFumbleRecoveryPoints(),
                        request.getSafetyPoints(),
                        request.getDefensiveTDPoints(),
                        request.getPointsAllowedTiers()
                );
        League league = configureScoringUseCase.configureDefensiveScoring(command);
        return ResponseEntity.ok(toLeagueResponse(league));
    }

    // ==================== League Cloning ====================

    @PostMapping("/clone")
    @Operation(summary = "Clone league settings", description = "Creates a new league by cloning settings from an existing one")
    public ResponseEntity<LeagueResponse> cloneLeague(
            @RequestHeader("X-Admin-User-Id") UUID adminUserId,
            @RequestBody CloneLeagueRequest request) {

        CloneLeagueSettingsUseCase.CloneLeagueCommand command =
                new CloneLeagueSettingsUseCase.CloneLeagueCommand(
                        request.getSourceLeagueId(),
                        request.getNewLeagueName(),
                        request.getNewLeagueCode(),
                        adminUserId
                );
        if (request.getDescription() != null) {
            command.setDescription(request.getDescription());
        }
        if (request.getStartingWeek() != null) {
            command.setStartingWeek(request.getStartingWeek());
        }
        if (request.getNumberOfWeeks() != null) {
            command.setNumberOfWeeks(request.getNumberOfWeeks());
        }

        League league = cloneLeagueUseCase.execute(command);
        return ResponseEntity.status(HttpStatus.CREATED).body(toLeagueResponse(league));
    }

    // ==================== Admin's Leagues ====================

    @GetMapping
    @Operation(summary = "List admin's leagues", description = "Returns all leagues owned by the admin")
    public ResponseEntity<List<LeagueResponse>> listMyLeagues(
            @RequestHeader("X-Admin-User-Id") UUID adminUserId) {

        List<League> leagues = leagueRepository.findByAdminId(adminUserId);
        List<LeagueResponse> response = leagues.stream()
                .map(this::toLeagueResponse)
                .collect(Collectors.toList());

        return ResponseEntity.ok(response);
    }

    // ==================== Response Mapping ====================

    private LeagueResponse toLeagueResponse(League league) {
        long playerCount = leaguePlayerRepository.countActivePlayersByLeagueId(league.getId());
        return new LeagueResponse(
                league.getId(),
                league.getName(),
                league.getDescription(),
                league.getCode(),
                league.getStatus().name(),
                league.getStartingWeek(),
                league.getNumberOfWeeks(),
                (int) playerCount,
                league.getConfigurationLocked(),
                league.getCreatedAt()
        );
    }

    private InvitationResponse toInvitationResponse(PlayerInvitation invitation) {
        return new InvitationResponse(
                invitation.getId(),
                invitation.getLeagueId(),
                invitation.getLeagueName(),
                invitation.getEmail(),
                invitation.getStatus().name(),
                invitation.getExpiresAt()
        );
    }

    private LeaguePlayerResponse toLeaguePlayerResponse(LeaguePlayer player) {
        return new LeaguePlayerResponse(
                player.getId(),
                player.getUserId(),
                player.getStatus().name(),
                player.getJoinedAt(),
                player.getLastActiveAt()
        );
    }

    // ==================== Request/Response DTOs ====================

    public record InvitePlayerRequest(String email) {
        public String getEmail() { return email; }
    }

    public record AcceptInvitationRequest(
            String invitationToken, String email, String displayName, String googleId) {
        public String getInvitationToken() { return invitationToken; }
        public String getEmail() { return email; }
        public String getDisplayName() { return displayName; }
        public String getGoogleId() { return googleId; }
    }

    public record ConfigurePPRRequest(
            Double passingYardsPerPoint, Double rushingYardsPerPoint,
            Double receivingYardsPerPoint, Double receptionPoints, Double touchdownPoints) {
        public Double getPassingYardsPerPoint() { return passingYardsPerPoint; }
        public Double getRushingYardsPerPoint() { return rushingYardsPerPoint; }
        public Double getReceivingYardsPerPoint() { return receivingYardsPerPoint; }
        public Double getReceptionPoints() { return receptionPoints; }
        public Double getTouchdownPoints() { return touchdownPoints; }
    }

    public record ConfigureFieldGoalRequest(
            Double fg0to39Points, Double fg40to49Points, Double fg50PlusPoints) {
        public Double getFg0to39Points() { return fg0to39Points; }
        public Double getFg40to49Points() { return fg40to49Points; }
        public Double getFg50PlusPoints() { return fg50PlusPoints; }
    }

    public record ConfigureDefensiveRequest(
            Double sackPoints, Double interceptionPoints, Double fumbleRecoveryPoints,
            Double safetyPoints, Double defensiveTDPoints, Map<Integer, Double> pointsAllowedTiers) {
        public Double getSackPoints() { return sackPoints; }
        public Double getInterceptionPoints() { return interceptionPoints; }
        public Double getFumbleRecoveryPoints() { return fumbleRecoveryPoints; }
        public Double getSafetyPoints() { return safetyPoints; }
        public Double getDefensiveTDPoints() { return defensiveTDPoints; }
        public Map<Integer, Double> getPointsAllowedTiers() { return pointsAllowedTiers; }
    }

    public record CloneLeagueRequest(
            UUID sourceLeagueId, String newLeagueName, String newLeagueCode,
            String description, Integer startingWeek, Integer numberOfWeeks) {
        public UUID getSourceLeagueId() { return sourceLeagueId; }
        public String getNewLeagueName() { return newLeagueName; }
        public String getNewLeagueCode() { return newLeagueCode; }
        public String getDescription() { return description; }
        public Integer getStartingWeek() { return startingWeek; }
        public Integer getNumberOfWeeks() { return numberOfWeeks; }
    }

    public record LeagueResponse(
            UUID id, String name, String description, String code, String status,
            Integer startingWeek, Integer numberOfWeeks, Integer playerCount,
            Boolean configurationLocked, java.time.LocalDateTime createdAt) {}

    public record InvitationResponse(
            UUID id, UUID leagueId, String leagueName, String email,
            String status, java.time.LocalDateTime expiresAt) {}

    public record LeaguePlayerResponse(
            UUID id, UUID userId, String status,
            java.time.LocalDateTime joinedAt, java.time.LocalDateTime lastActiveAt) {}

    public record AcceptInvitationResponse(
            UUID userId, UUID leagueId, String leagueName, boolean newUser) {}
}

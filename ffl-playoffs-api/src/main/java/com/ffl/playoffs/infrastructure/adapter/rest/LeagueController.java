package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.GameHealthDTO;
import com.ffl.playoffs.application.dto.LeagueDTO;
import com.ffl.playoffs.application.usecase.*;
import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.model.RosterConfiguration;
import com.ffl.playoffs.domain.model.ScoringRules;
import com.ffl.playoffs.domain.port.LeagueRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/leagues")
@RequiredArgsConstructor
@Tag(name = "League Management", description = "APIs for managing fantasy football leagues")
public class LeagueController {

    private final CreateLeagueUseCase createLeagueUseCase;
    private final ConfigureLeagueUseCase configureLeagueUseCase;
    private final LeagueRepository leagueRepository;

    // Game management use cases
    private final ActivateLeagueUseCase activateLeagueUseCase;
    private final DeactivateLeagueUseCase deactivateLeagueUseCase;
    private final ReactivateLeagueUseCase reactivateLeagueUseCase;
    private final PauseLeagueUseCase pauseLeagueUseCase;
    private final ResumeLeagueUseCase resumeLeagueUseCase;
    private final CancelLeagueUseCase cancelLeagueUseCase;
    private final CompleteLeagueUseCase completeLeagueUseCase;
    private final ArchiveLeagueUseCase archiveLeagueUseCase;
    private final AdvanceWeekUseCase advanceWeekUseCase;
    private final GetGameHealthUseCase getGameHealthUseCase;
    private final DeleteLeagueUseCase deleteLeagueUseCase;

    @PostMapping
    @Operation(summary = "Create a new league", description = "Creates a new fantasy football league")
    public ResponseEntity<LeagueDTO> createLeague(@Valid @RequestBody LeagueDTO leagueDTO) {
        // Build command from DTO
        CreateLeagueUseCase.CreateLeagueCommand command = new CreateLeagueUseCase.CreateLeagueCommand(
                leagueDTO.getName(),
                leagueDTO.getCode(),
                leagueDTO.getOwnerId(),
                leagueDTO.getStartingWeek(),
                leagueDTO.getNumberOfWeeks()
        );

        // Set optional fields
        if (leagueDTO.getDescription() != null) {
            command.setDescription(leagueDTO.getDescription());
        }
        if (leagueDTO.getRosterConfiguration() != null) {
            command.setRosterConfiguration(mapToRosterConfiguration(leagueDTO.getRosterConfiguration()));
        }
        if (leagueDTO.getScoringRules() != null) {
            command.setScoringRules(mapToScoringRules(leagueDTO.getScoringRules()));
        }
        if (leagueDTO.getFirstGameStartTime() != null) {
            command.setFirstGameStartTime(leagueDTO.getFirstGameStartTime());
        }

        // Execute use case
        League createdLeague = createLeagueUseCase.execute(command);

        // Map to DTO
        LeagueDTO responseDTO = mapToDTO(createdLeague);

        return ResponseEntity.status(HttpStatus.CREATED).body(responseDTO);
    }

    @GetMapping("/{leagueId}")
    @Operation(summary = "Get league details", description = "Retrieves details of a specific league")
    public ResponseEntity<LeagueDTO> getLeague(@PathVariable UUID leagueId) {
        return leagueRepository.findById(leagueId)
                .map(this::mapToDTO)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping
    @Operation(summary = "List all leagues", description = "Retrieves a list of all leagues")
    public ResponseEntity<List<LeagueDTO>> listLeagues() {
        List<League> leagues = leagueRepository.findAll();
        List<LeagueDTO> leagueDTOs = leagues.stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(leagueDTOs);
    }

    @GetMapping("/code/{code}")
    @Operation(summary = "Get league by code", description = "Retrieves a league by its unique code")
    public ResponseEntity<LeagueDTO> getLeagueByCode(@PathVariable String code) {
        return leagueRepository.findByCode(code)
                .map(this::mapToDTO)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{leagueId}/configure")
    @Operation(summary = "Configure league", description = "Updates league configuration (roster and scoring rules)")
    public ResponseEntity<LeagueDTO> configureLeague(
            @PathVariable UUID leagueId,
            @Valid @RequestBody LeagueDTO leagueDTO) {

        // TODO: Get ownerId from authentication context
        UUID ownerId = UUID.randomUUID(); // Placeholder - should come from authentication
        ConfigureLeagueUseCase.ConfigureLeagueCommand command =
                new ConfigureLeagueUseCase.ConfigureLeagueCommand(leagueId, ownerId);

        if (leagueDTO.getRosterConfiguration() != null) {
            command.setRosterConfiguration(mapToRosterConfiguration(leagueDTO.getRosterConfiguration()));
        }
        if (leagueDTO.getScoringRules() != null) {
            command.setScoringRules(mapToScoringRules(leagueDTO.getScoringRules()));
        }

        League updatedLeague = configureLeagueUseCase.execute(command);
        return ResponseEntity.ok(mapToDTO(updatedLeague));
    }

    // ==================== Game Management Endpoints ====================

    @PostMapping("/{leagueId}/activate")
    @Operation(summary = "Activate a league", description = "Activates a league to start the game. Creates week entities and transitions to ACTIVE status.")
    public ResponseEntity<LeagueDTO> activateLeague(@PathVariable UUID leagueId) {
        ActivateLeagueUseCase.ActivateLeagueResult result = activateLeagueUseCase.execute(
                new ActivateLeagueUseCase.ActivateLeagueCommand(leagueId)
        );
        return ResponseEntity.ok(mapToDTO(result.getLeague()));
    }

    @PostMapping("/{leagueId}/deactivate")
    @Operation(summary = "Deactivate a league", description = "Deactivates an active league. Players cannot make new selections.")
    public ResponseEntity<LeagueDTO> deactivateLeague(@PathVariable UUID leagueId) {
        League league = deactivateLeagueUseCase.execute(
                new DeactivateLeagueUseCase.DeactivateLeagueCommand(leagueId)
        );
        return ResponseEntity.ok(mapToDTO(league));
    }

    @PostMapping("/{leagueId}/reactivate")
    @Operation(summary = "Reactivate a league", description = "Reactivates an inactive league. Players can make selections again.")
    public ResponseEntity<LeagueDTO> reactivateLeague(@PathVariable UUID leagueId) {
        League league = reactivateLeagueUseCase.execute(
                new ReactivateLeagueUseCase.ReactivateLeagueCommand(leagueId)
        );
        return ResponseEntity.ok(mapToDTO(league));
    }

    @PostMapping("/{leagueId}/pause")
    @Operation(summary = "Pause a league", description = "Pauses an active league. All deadlines are suspended.")
    public ResponseEntity<LeagueDTO> pauseLeague(@PathVariable UUID leagueId) {
        League league = pauseLeagueUseCase.execute(
                new PauseLeagueUseCase.PauseLeagueCommand(leagueId)
        );
        return ResponseEntity.ok(mapToDTO(league));
    }

    @PostMapping("/{leagueId}/resume")
    @Operation(summary = "Resume a league", description = "Resumes a paused league. Deadlines are recalculated.")
    public ResponseEntity<LeagueDTO> resumeLeague(@PathVariable UUID leagueId) {
        League league = resumeLeagueUseCase.execute(
                new ResumeLeagueUseCase.ResumeLeagueCommand(leagueId)
        );
        return ResponseEntity.ok(mapToDTO(league));
    }

    @PostMapping("/{leagueId}/cancel")
    @Operation(summary = "Cancel a league", description = "Cancels a league with a reason. No further actions allowed.")
    public ResponseEntity<LeagueDTO> cancelLeague(
            @PathVariable UUID leagueId,
            @RequestBody Map<String, String> request) {
        String reason = request.getOrDefault("reason", "Cancelled by admin");
        League league = cancelLeagueUseCase.execute(
                new CancelLeagueUseCase.CancelLeagueCommand(leagueId, reason)
        );
        return ResponseEntity.ok(mapToDTO(league));
    }

    @PostMapping("/{leagueId}/complete")
    @Operation(summary = "Complete a league", description = "Marks a league as completed. Final standings are calculated.")
    public ResponseEntity<LeagueDTO> completeLeague(@PathVariable UUID leagueId) {
        League league = completeLeagueUseCase.execute(
                new CompleteLeagueUseCase.CompleteLeagueCommand(leagueId)
        );
        return ResponseEntity.ok(mapToDTO(league));
    }

    @PostMapping("/{leagueId}/archive")
    @Operation(summary = "Archive a league", description = "Archives a completed league. Data preserved for historical viewing.")
    public ResponseEntity<LeagueDTO> archiveLeague(@PathVariable UUID leagueId) {
        League league = archiveLeagueUseCase.execute(
                new ArchiveLeagueUseCase.ArchiveLeagueCommand(leagueId)
        );
        return ResponseEntity.ok(mapToDTO(league));
    }

    @PostMapping("/{leagueId}/advance-week")
    @Operation(summary = "Advance to next week", description = "Manually advances the league to the next week. Validates all games are complete.")
    public ResponseEntity<Map<String, Object>> advanceWeek(@PathVariable UUID leagueId) {
        AdvanceWeekUseCase.AdvanceWeekResult result = advanceWeekUseCase.execute(
                new AdvanceWeekUseCase.AdvanceWeekCommand(leagueId)
        );

        return ResponseEntity.ok(Map.of(
                "league", mapToDTO(result.getLeague()),
                "previousWeek", result.getPreviousWeek() != null ? result.getPreviousWeek().getGameWeekNumber() : null,
                "currentWeek", result.getCurrentWeek() != null ? result.getCurrentWeek().getGameWeekNumber() : null,
                "leagueCompleted", result.isLeagueCompleted()
        ));
    }

    @GetMapping("/{leagueId}/health")
    @Operation(summary = "Get game health status", description = "Returns health statistics for the league including player selections and data integration status.")
    public ResponseEntity<GameHealthDTO> getGameHealth(@PathVariable UUID leagueId) {
        GetGameHealthUseCase.GameHealthStatus health = getGameHealthUseCase.execute(
                new GetGameHealthUseCase.GetGameHealthCommand(leagueId)
        );
        return ResponseEntity.ok(mapToGameHealthDTO(health));
    }

    @DeleteMapping("/{leagueId}")
    @Operation(summary = "Delete a draft league", description = "Deletes a draft league with no players. Active/completed leagues cannot be deleted.")
    public ResponseEntity<Void> deleteLeague(@PathVariable UUID leagueId) {
        deleteLeagueUseCase.execute(new DeleteLeagueUseCase.DeleteLeagueCommand(leagueId));
        return ResponseEntity.noContent().build();
    }

    // Mapping methods
    private LeagueDTO mapToDTO(League league) {
        LeagueDTO dto = new LeagueDTO();
        dto.setId(league.getId());
        dto.setName(league.getName());
        dto.setDescription(league.getDescription());
        dto.setCode(league.getCode());
        dto.setOwnerId(league.getOwnerId());
        dto.setStatus(league.getStatus() != null ? league.getStatus().name() : null);
        dto.setStartingWeek(league.getStartingWeek());
        dto.setNumberOfWeeks(league.getNumberOfWeeks());
        dto.setCurrentWeek(league.getCurrentWeek());
        dto.setConfigurationLocked(league.getConfigurationLocked());
        dto.setConfigurationLockedAt(league.getConfigurationLockedAt());
        dto.setLockReason(league.getLockReason());
        dto.setFirstGameStartTime(league.getFirstGameStartTime());
        dto.setCreatedAt(league.getCreatedAt());
        dto.setUpdatedAt(league.getUpdatedAt());
        return dto;
    }

    private RosterConfiguration mapToRosterConfiguration(com.ffl.playoffs.application.dto.RosterConfigurationDTO dto) {
        // Map DTO to domain model
        // Note: This is a simplified version - implement proper mapping based on RosterConfiguration structure
        return RosterConfiguration.standardRoster(); // TODO: Implement proper mapping
    }

    private ScoringRules mapToScoringRules(com.ffl.playoffs.application.dto.ScoringRulesDTO dto) {
        // Map DTO to domain model
        // Note: This is a simplified version - implement proper mapping based on ScoringRules structure
        return new ScoringRules(); // TODO: Implement proper mapping
    }

    private GameHealthDTO mapToGameHealthDTO(GetGameHealthUseCase.GameHealthStatus health) {
        GameHealthDTO dto = new GameHealthDTO();
        dto.setLeagueId(health.getLeagueId());
        dto.setLeagueName(health.getLeagueName());
        dto.setStatus(health.getStatus());
        dto.setTotalPlayers(health.getTotalPlayers());
        dto.setActiveSelections(health.getActiveSelectionsDisplay());
        dto.setMissedSelections(health.getMissedSelections());
        dto.setCurrentWeek(health.getCurrentWeek());
        dto.setWeeksRemaining(health.getWeeksRemaining());
        dto.setDataIntegrationStatus(health.getDataIntegrationStatus().name());
        dto.setLastScoreCalculation(health.getLastScoreCalculation());
        return dto;
    }
}

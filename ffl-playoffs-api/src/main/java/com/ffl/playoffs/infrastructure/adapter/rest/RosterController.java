package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.RosterDTO;
import com.ffl.playoffs.application.usecase.BuildRosterUseCase;
import com.ffl.playoffs.application.usecase.GetRosterLockStatusReportUseCase;
import com.ffl.playoffs.application.usecase.LockAllRostersAtDeadlineUseCase;
import com.ffl.playoffs.application.usecase.LockRosterUseCase;
import com.ffl.playoffs.application.usecase.ValidateRosterUseCase;
import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.port.RosterRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/rosters")
@RequiredArgsConstructor
@Tag(name = "Roster Management", description = "APIs for managing player rosters")
public class RosterController {

    private final BuildRosterUseCase buildRosterUseCase;
    private final LockRosterUseCase lockRosterUseCase;
    private final LockAllRostersAtDeadlineUseCase lockAllRostersAtDeadlineUseCase;
    private final GetRosterLockStatusReportUseCase getRosterLockStatusReportUseCase;
    private final ValidateRosterUseCase validateRosterUseCase;
    private final RosterRepository rosterRepository;

    @PostMapping
    @Operation(summary = "Build a new roster", description = "Creates a new roster for a player in a league")
    public ResponseEntity<RosterDTO> buildRoster(@Valid @RequestBody RosterDTO rosterDTO) {
        BuildRosterUseCase.BuildRosterCommand command = new BuildRosterUseCase.BuildRosterCommand(
                rosterDTO.getLeagueId(),
                rosterDTO.getLeaguePlayerId()
        );

        if (rosterDTO.getRosterDeadline() != null) {
            command.setRosterDeadline(rosterDTO.getRosterDeadline());
        }

        Roster createdRoster = buildRosterUseCase.execute(command);
        return ResponseEntity.status(HttpStatus.CREATED).body(mapToDTO(createdRoster));
    }

    @GetMapping("/{rosterId}")
    @Operation(summary = "Get roster details", description = "Retrieves details of a specific roster")
    public ResponseEntity<RosterDTO> getRoster(@PathVariable UUID rosterId) {
        return rosterRepository.findById(rosterId)
                .map(this::mapToDTO)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/league/{leagueId}/player/{leaguePlayerId}")
    @Operation(summary = "Get roster by league player", description = "Retrieves a roster for a specific player in a league")
    public ResponseEntity<RosterDTO> getRosterByLeaguePlayer(
            @PathVariable UUID leagueId,
            @PathVariable UUID leaguePlayerId) {
        return rosterRepository.findByLeaguePlayerId(leaguePlayerId)
                .map(this::mapToDTO)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/league/{leagueId}")
    @Operation(summary = "List rosters for a league", description = "Retrieves all rosters in a league")
    public ResponseEntity<List<RosterDTO>> getRostersByLeague(@PathVariable UUID leagueId) {
        // TODO: RosterRepository doesn't have findByLeagueId - need to add this method
        List<Roster> rosters = new java.util.ArrayList<>();
        List<RosterDTO> rosterDTOs = rosters.stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(rosterDTOs);
    }

    @PostMapping("/{rosterId}/lock")
    @Operation(summary = "Lock a roster", description = "Locks a roster to prevent further changes")
    public ResponseEntity<RosterDTO> lockRoster(@PathVariable UUID rosterId) {
        LockRosterUseCase.LockRosterCommand command = new LockRosterUseCase.LockRosterCommand(rosterId);
        LockRosterUseCase.LockRosterResult result = lockRosterUseCase.execute(command);
        // TODO: LockRosterResult doesn't contain the full Roster, need to fetch it separately
        Roster roster = rosterRepository.findById(result.getRosterId()).orElseThrow();
        return ResponseEntity.ok(mapToDTO(roster));
    }

    @PostMapping("/{rosterId}/validate")
    @Operation(summary = "Validate a roster", description = "Validates that a roster meets all requirements")
    public ResponseEntity<Void> validateRoster(@PathVariable UUID rosterId) {
        ValidateRosterUseCase.ValidateRosterCommand command =
                new ValidateRosterUseCase.ValidateRosterCommand(rosterId);

        ValidateRosterUseCase.ValidationResult result = validateRosterUseCase.execute(command);

        if (result.isComplete()) {
            return ResponseEntity.ok().build();
        } else {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/league/{leagueId}/lock-all")
    @Operation(summary = "Lock all rosters at deadline",
            description = "Locks all unlocked rosters in a league. Used when roster deadline passes.")
    public ResponseEntity<LockAllRostersAtDeadlineUseCase.LockAllRostersResult> lockAllRostersAtDeadline(
            @PathVariable UUID leagueId) {
        LockAllRostersAtDeadlineUseCase.LockAllRostersCommand command =
                new LockAllRostersAtDeadlineUseCase.LockAllRostersCommand(leagueId, LocalDateTime.now());

        LockAllRostersAtDeadlineUseCase.LockAllRostersResult result =
                lockAllRostersAtDeadlineUseCase.execute(command);

        return ResponseEntity.ok(result);
    }

    @GetMapping("/league/{leagueId}/lock-status")
    @Operation(summary = "Get roster lock status report",
            description = "Returns a report of all roster lock statuses in a league for admin view")
    public ResponseEntity<GetRosterLockStatusReportUseCase.RosterLockStatusReport> getRosterLockStatusReport(
            @PathVariable UUID leagueId) {
        GetRosterLockStatusReportUseCase.GetReportCommand command =
                new GetRosterLockStatusReportUseCase.GetReportCommand(leagueId);

        GetRosterLockStatusReportUseCase.RosterLockStatusReport report =
                getRosterLockStatusReportUseCase.execute(command);

        return ResponseEntity.ok(report);
    }

    // Mapping method
    private RosterDTO mapToDTO(Roster roster) {
        RosterDTO dto = new RosterDTO();
        dto.setId(roster.getId());
        dto.setLeaguePlayerId(roster.getLeaguePlayerId());
        dto.setLeagueId(roster.getGameId()); // Domain uses gameId for league reference
        dto.setIsLocked(roster.isLocked());
        dto.setLockStatus(roster.getLockStatus() != null ? roster.getLockStatus().name() : null);
        dto.setLockStatusMessage(roster.getLockStatus() != null
                ? roster.getLockStatus().getDisplayMessage() : null);
        dto.setLockedAt(roster.getLockedAt());
        dto.setRosterDeadline(roster.getRosterDeadline());
        dto.setFilledSlotCount(roster.getFilledSlotCount());
        dto.setTotalSlotCount(roster.getTotalSlotCount());
        dto.setCreatedAt(roster.getCreatedAt());
        dto.setUpdatedAt(roster.getUpdatedAt());
        // TODO: Map roster slots
        return dto;
    }
}

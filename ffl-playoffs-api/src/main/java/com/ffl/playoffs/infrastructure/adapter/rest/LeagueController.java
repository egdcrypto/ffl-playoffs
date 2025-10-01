package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.LeagueDTO;
import com.ffl.playoffs.application.usecase.ConfigureLeagueUseCase;
import com.ffl.playoffs.application.usecase.CreateLeagueUseCase;
import com.ffl.playoffs.domain.model.League;
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

        ConfigureLeagueUseCase.ConfigureLeagueCommand command =
                new ConfigureLeagueUseCase.ConfigureLeagueCommand(leagueId);

        if (leagueDTO.getRosterConfiguration() != null) {
            command.setRosterConfiguration(mapToRosterConfiguration(leagueDTO.getRosterConfiguration()));
        }
        if (leagueDTO.getScoringRules() != null) {
            command.setScoringRules(mapToScoringRules(leagueDTO.getScoringRules()));
        }

        League updatedLeague = configureLeagueUseCase.execute(command);
        return ResponseEntity.ok(mapToDTO(updatedLeague));
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
}

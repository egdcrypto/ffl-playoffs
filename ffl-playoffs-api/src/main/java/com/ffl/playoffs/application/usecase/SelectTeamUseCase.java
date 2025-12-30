package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.TeamSelectionDTO;
import com.ffl.playoffs.domain.model.TeamSelection;
import com.ffl.playoffs.domain.aggregate.Week;
import com.ffl.playoffs.domain.port.TeamSelectionRepository;
import com.ffl.playoffs.domain.port.WeekRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class SelectTeamUseCase {
    private final WeekRepository weekRepository;
    private final TeamSelectionRepository teamSelectionRepository;

    /**
     * Execute team selection for a player
     * @param playerId the player's UUID
     * @param weekId the week's UUID
     * @param nflTeam the NFL team name to select
     * @return the created team selection as DTO
     * @throws IllegalStateException if week is not open for selections
     * @throws IllegalArgumentException if week not found or team already used
     */
    public TeamSelectionDTO execute(UUID playerId, UUID weekId, String nflTeam) {
        // Validate week exists and is open for selections
        Week week = findWeek(weekId);

        if (!week.canAcceptSelections()) {
            throw new IllegalStateException("Week is not open for selections");
        }

        // Validate team hasn't been used by this player before
        validateTeamNotUsed(playerId, nflTeam);

        TeamSelection selection = TeamSelection.builder()
                .playerId(playerId.hashCode() * 1L) // Convert UUID to Long for domain model
                .weekId(weekId.hashCode() * 1L)     // Convert UUID to Long for domain model
                .nflTeam(nflTeam)
                .selectedAt(LocalDateTime.now())
                .status(TeamSelection.SelectionStatus.PENDING)
                .build();

        // Save selection through repository
        TeamSelection savedSelection = teamSelectionRepository.save(selection);

        return TeamSelectionDTO.fromDomain(savedSelection);
    }

    private Week findWeek(UUID weekId) {
        return weekRepository.findById(weekId)
                .orElseThrow(() -> new IllegalArgumentException("Week not found: " + weekId));
    }

    private void validateTeamNotUsed(UUID playerId, String nflTeam) {
        if (teamSelectionRepository.hasPlayerSelectedTeam(playerId, nflTeam)) {
            throw new IllegalArgumentException("Team " + nflTeam + " has already been used by this player");
        }
    }
}

package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.TeamSelectionDTO;
import com.ffl.playoffs.domain.model.TeamSelection;
import com.ffl.playoffs.domain.aggregate.Week;
import com.ffl.playoffs.domain.port.GameRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class SelectTeamUseCase {
    private final GameRepository gameRepository;
    
    public TeamSelectionDTO execute(Long playerId, Long weekId, String nflTeam) {
        // Validate week is open for selections
        Week week = findWeek(weekId);
        
        if (!week.canAcceptSelections()) {
            throw new IllegalStateException("Week is not open for selections");
        }
        
        // Validate team hasn't been used by this player before
        validateTeamNotUsed(playerId, nflTeam);
        
        TeamSelection selection = TeamSelection.builder()
                .playerId(playerId)
                .weekId(weekId)
                .nflTeam(nflTeam)
                .selectedAt(LocalDateTime.now())
                .status(TeamSelection.SelectionStatus.PENDING)
                .build();
        
        // TODO: Save selection through repository
        
        return TeamSelectionDTO.fromDomain(selection);
    }
    
    private Week findWeek(Long weekId) {
        // TODO: Implement week lookup
        return null;
    }
    
    private void validateTeamNotUsed(Long playerId, String nflTeam) {
        // TODO: Implement validation
    }
}

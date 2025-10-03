package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.model.TeamSelection;
import com.ffl.playoffs.domain.model.Week;
import com.ffl.playoffs.domain.port.GameRepository;
import com.ffl.playoffs.domain.port.NflDataProvider;
import com.ffl.playoffs.domain.port.PlayerRepository;

import java.util.UUID;

/**
 * Use case for a player selecting a team for a week.
 */
public class SelectTeamUseCase {
    
    private final PlayerRepository playerRepository;
    private final GameRepository gameRepository;
    private final NflDataProvider nflDataProvider;

    public SelectTeamUseCase(PlayerRepository playerRepository, 
                            GameRepository gameRepository,
                            NflDataProvider nflDataProvider) {
        this.playerRepository = playerRepository;
        this.gameRepository = gameRepository;
        this.nflDataProvider = nflDataProvider;
    }

    public TeamSelection execute(UUID playerId, UUID weekId, String teamCode) {
        // Validate player exists and is not eliminated
        Player player = playerRepository.findById(playerId)
                .orElseThrow(() -> new IllegalArgumentException("Player not found"));
        
        if (player.isEliminated()) {
            throw new IllegalStateException("Eliminated players cannot make selections");
        }
        
        // Validate team code
        if (!nflDataProvider.isValidTeamCode(teamCode)) {
            throw new IllegalArgumentException("Invalid team code: " + teamCode);
        }
        
        // Check if player already selected this team in previous weeks
        boolean alreadySelected = player.getTeamSelections().stream()
                .anyMatch(ts -> ts.getTeamCode().equals(teamCode));
        
        if (alreadySelected) {
            throw new IllegalStateException("Team already selected in a previous week");
        }
        
        // Create team selection
        TeamSelection selection = new TeamSelection(playerId, weekId, teamCode);
        player.addTeamSelection(selection);
        
        // Save player with new selection
        playerRepository.save(player);
        
        return selection;
    }
}

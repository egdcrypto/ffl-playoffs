package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.model.TeamSelection;
import com.ffl.playoffs.domain.port.NflDataProvider;
import com.ffl.playoffs.domain.port.PlayerRepository;

import java.util.UUID;

/**
 * Use case for a player selecting a team
 * Application layer orchestrates domain logic
 */
public class SelectTeamUseCase {

    private final PlayerRepository playerRepository;
    private final NflDataProvider nflDataProvider;

    public SelectTeamUseCase(PlayerRepository playerRepository, NflDataProvider nflDataProvider) {
        this.playerRepository = playerRepository;
        this.nflDataProvider = nflDataProvider;
    }

    public TeamSelection execute(SelectTeamCommand command) {
        // Find player
        Player player = playerRepository.findById(command.getPlayerId())
                .orElseThrow(() -> new IllegalArgumentException("Player not found"));

        // Validate team is available
        String teamName = nflDataProvider.getTeamName(command.getNflTeamCode());
        if (teamName == null) {
            throw new IllegalArgumentException("Invalid NFL team code");
        }

        // Check if player already selected for this week
        if (player.hasSelectedTeamForWeek(command.getWeek())) {
            throw new IllegalStateException("Player has already selected a team for this week");
        }

        // Create selection
        TeamSelection selection = new TeamSelection(
                player.getId(),
                command.getWeek(),
                command.getNflTeamCode(),
                teamName
        );

        // Add to player
        player.makeTeamSelection(selection);

        // Save
        playerRepository.save(player);

        return selection;
    }

    public static class SelectTeamCommand {
        private final UUID playerId;
        private final Integer week;
        private final String nflTeamCode;

        public SelectTeamCommand(UUID playerId, Integer week, String nflTeamCode) {
            this.playerId = playerId;
            this.week = week;
            this.nflTeamCode = nflTeamCode;
        }

        public UUID getPlayerId() {
            return playerId;
        }

        public Integer getWeek() {
            return week;
        }

        public String getNflTeamCode() {
            return nflTeamCode;
        }
    }
}

package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.model.TeamSelection;
import com.ffl.playoffs.domain.port.PlayerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Use case for a player selecting a team for a week.
 */
@Service
@RequiredArgsConstructor
public class SelectTeamUseCase {

    private final PlayerRepository playerRepository;

    @Transactional
    public TeamSelection execute(UUID playerId, Integer weekNumber, String nflTeam) {
        Player player = playerRepository.findById(playerId)
                .orElseThrow(() -> new IllegalArgumentException("Player not found: " + playerId));

        if (player.isEliminated()) {
            throw new IllegalStateException("Player is eliminated and cannot select teams");
        }

        // Check if player already selected for this week
        boolean alreadySelected = player.getTeamSelections().stream()
                .anyMatch(ts -> ts.getWeekNumber().equals(weekNumber));

        if (alreadySelected) {
            throw new IllegalStateException("Player has already selected a team for week " + weekNumber);
        }

        TeamSelection teamSelection = TeamSelection.builder()
                .id(UUID.randomUUID())
                .playerId(playerId)
                .weekNumber(weekNumber)
                .nflTeam(nflTeam)
                .selectedAt(LocalDateTime.now())
                .isScored(false)
                .build();

        player.addTeamSelection(teamSelection);
        playerRepository.save(player);

        return teamSelection;
    }
}

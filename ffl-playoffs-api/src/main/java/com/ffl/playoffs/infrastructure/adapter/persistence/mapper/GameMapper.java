package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.*;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.*;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Mapper to convert between Game domain model and GameDocument
 * Infrastructure layer
 */
@Component
public class GameMapper {

    public GameDocument toDocument(Game game) {
        if (game == null) {
            return null;
        }

        return GameDocument.builder()
                .id(game.getId() != null ? UUID.fromString(game.getId().toString()) : null)
                .name(game.getName())
                .code(game.getInviteCode())
                .creatorId(null) // Not in current Game model
                .status(game.getStatus() != null ? game.getStatus().name() : null)
                .startingWeek(null) // Not in current Game model
                .currentWeek(game.getCurrentWeek())
                .numberOfWeeks(null) // Not in current Game model
                .eliminationMode(null) // Not in current Game model
                .createdAt(game.getCreatedAt())
                .updatedAt(null) // Not in current Game model
                .configurationLockedAt(null) // Not in current Game model
                .lockReason(null) // Not in current Game model
                .firstGameStartTime(null) // Not in current Game model
                .players(toPlayerDocuments(game.getPlayers()))
                .scoringRules(null) // Not in current Game model
                .build();
    }

    public Game toDomain(GameDocument document) {
        if (document == null) {
            return null;
        }

        Game game = new Game();
        game.setId(document.getId() != null ? Long.parseLong(document.getId().toString().hashCode() + "") : null);
        game.setName(document.getName());
        game.setInviteCode(document.getCode());
        game.setStatus(document.getStatus() != null ? Game.GameStatus.valueOf(document.getStatus()) : null);
        game.setCurrentWeek(document.getCurrentWeek());
        game.setCreatedAt(document.getCreatedAt());
        // Convert List<PlayerDocument> to Set<Player>
        if (document.getPlayers() != null) {
            game.setPlayers(new java.util.HashSet<>(toPlayerDomains(document.getPlayers())));
        }
        // weeks are not set from document - would need separate mapping

        return game;
    }

    private List<PlayerDocument> toPlayerDocuments(java.util.Set<Player> players) {
        if (players == null) {
            return Collections.emptyList();
        }
        return players.stream()
                .map(this::toPlayerDocument)
                .collect(Collectors.toList());
    }

    private PlayerDocument toPlayerDocument(Player player) {
        if (player == null) {
            return null;
        }
        return PlayerDocument.builder()
                .id(player.getId() != null ? UUID.fromString(player.getId().toString()) : null)
                .gameId(null) // Not in current Player model
                .name(player.getDisplayName()) // Using displayName instead of name
                .email(player.getEmail())
                .status(player.getStatus() != null ? player.getStatus().name() : null)
                .joinedAt(player.getJoinedAt())
                .isEliminated(player.getStatus() == Player.PlayerStatus.ELIMINATED)
                .teamSelections(Collections.emptyList()) // Not in current Player model
                .build();
    }

    private List<Player> toPlayerDomains(List<PlayerDocument> documents) {
        if (documents == null) {
            return Collections.emptyList();
        }
        return documents.stream()
                .map(this::toPlayerDomain)
                .collect(Collectors.toList());
    }

    private Player toPlayerDomain(PlayerDocument document) {
        if (document == null) {
            return null;
        }
        Player player = new Player();
        player.setId(document.getId() != null ? Long.parseLong(document.getId().toString().hashCode() + "") : null);
        player.setDisplayName(document.getName());
        player.setEmail(document.getEmail());
        player.setStatus(document.getStatus() != null ? Player.PlayerStatus.valueOf(document.getStatus()) : null);
        player.setJoinedAt(document.getJoinedAt());
        // googleId is not in PlayerDocument
        return player;
    }

    private List<TeamSelectionDocument> toTeamSelectionDocuments(List<TeamSelection> selections) {
        if (selections == null) {
            return Collections.emptyList();
        }
        return selections.stream()
                .map(this::toTeamSelectionDocument)
                .collect(Collectors.toList());
    }

    private TeamSelectionDocument toTeamSelectionDocument(TeamSelection selection) {
        if (selection == null) {
            return null;
        }
        return TeamSelectionDocument.builder()
                .id(selection.getId() != null ? UUID.fromString(selection.getId().toString()) : null)
                .playerId(selection.getPlayerId() != null ? UUID.fromString(selection.getPlayerId().toString()) : null)
                .teamName(selection.getNflTeam())
                .weekNumber(null) // weekId vs weekNumber mismatch
                .selectedAt(selection.getSelectedAt())
                .isEliminated(selection.getStatus() == TeamSelection.SelectionStatus.SCORED && selection.getScore() != null && selection.getScore() == 0.0)
                .build();
    }

    private List<TeamSelection> toTeamSelectionDomains(List<TeamSelectionDocument> documents) {
        if (documents == null) {
            return Collections.emptyList();
        }
        return documents.stream()
                .map(this::toTeamSelectionDomain)
                .collect(Collectors.toList());
    }

    private TeamSelection toTeamSelectionDomain(TeamSelectionDocument document) {
        if (document == null) {
            return null;
        }
        TeamSelection selection = new TeamSelection();
        selection.setId(document.getId() != null ? Long.parseLong(document.getId().toString().hashCode() + "") : null);
        selection.setPlayerId(document.getPlayerId() != null ? Long.parseLong(document.getPlayerId().toString().hashCode() + "") : null);
        selection.setNflTeam(document.getTeamName());
        selection.setWeekId(null); // weekNumber is Integer in document, weekId is Long in domain
        selection.setSelectedAt(document.getSelectedAt());
        selection.setStatus(document.getIsEliminated() ? TeamSelection.SelectionStatus.SCORED : TeamSelection.SelectionStatus.PENDING);
        return selection;
    }

    // ScoringRules methods removed - ScoringRules class doesn't exist in current domain model
    // These would need to be re-implemented when ScoringRules is added to the domain
}

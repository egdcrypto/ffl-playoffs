package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.*;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.*;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.List;
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
                .id(game.getId())
                .name(game.getName())
                .code(game.getCode())
                .creatorId(game.getCreatorId())
                .status(game.getStatus() != null ? game.getStatus().name() : null)
                .startingWeek(game.getStartingWeek())
                .currentWeek(game.getCurrentWeek())
                .numberOfWeeks(game.getNumberOfWeeks())
                .eliminationMode(game.getEliminationMode())
                .createdAt(game.getCreatedAt())
                .updatedAt(game.getUpdatedAt())
                .configurationLockedAt(game.getConfigurationLockedAt())
                .lockReason(game.getLockReason())
                .firstGameStartTime(game.getFirstGameStartTime())
                .players(toPlayerDocuments(game.getPlayers()))
                .scoringRules(toScoringRulesDocument(game.getScoringRules()))
                .build();
    }

    public Game toDomain(GameDocument document) {
        if (document == null) {
            return null;
        }

        Game game = new Game();
        game.setId(document.getId());
        game.setName(document.getName());
        game.setCode(document.getCode());
        game.setCreatorId(document.getCreatorId());
        game.setStatus(document.getStatus() != null ? GameStatus.valueOf(document.getStatus()) : null);
        game.setStartingWeek(document.getStartingWeek());
        game.setCurrentWeek(document.getCurrentWeek());
        game.setNumberOfWeeks(document.getNumberOfWeeks());
        game.setEliminationMode(document.getEliminationMode());
        game.setCreatedAt(document.getCreatedAt());
        game.setUpdatedAt(document.getUpdatedAt());
        game.setConfigurationLockedAt(document.getConfigurationLockedAt());
        game.setLockReason(document.getLockReason());
        game.setFirstGameStartTime(document.getFirstGameStartTime());
        game.setPlayers(toPlayerDomains(document.getPlayers()));
        game.setScoringRules(toScoringRulesDomain(document.getScoringRules()));

        return game;
    }

    private List<PlayerDocument> toPlayerDocuments(List<Player> players) {
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
                .id(player.getId())
                .gameId(player.getGameId())
                .name(player.getName())
                .email(player.getEmail())
                .status(player.getStatus() != null ? player.getStatus().name() : null)
                .joinedAt(player.getJoinedAt())
                .isEliminated(player.getIsEliminated())
                .teamSelections(toTeamSelectionDocuments(player.getTeamSelections()))
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
        player.setId(document.getId());
        player.setGameId(document.getGameId());
        player.setName(document.getName());
        player.setEmail(document.getEmail());
        player.setStatus(document.getStatus() != null ? PlayerStatus.valueOf(document.getStatus()) : null);
        player.setJoinedAt(document.getJoinedAt());
        player.setIsEliminated(document.getIsEliminated());
        player.setTeamSelections(toTeamSelectionDomains(document.getTeamSelections()));
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
                .id(selection.getId())
                .playerId(selection.getPlayerId())
                .teamName(selection.getTeamName())
                .weekNumber(selection.getWeekNumber())
                .selectedAt(selection.getSelectedAt())
                .isEliminated(selection.getIsEliminated())
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
        selection.setId(document.getId());
        selection.setPlayerId(document.getPlayerId());
        selection.setTeamName(document.getTeamName());
        selection.setWeekNumber(document.getWeekNumber());
        selection.setSelectedAt(document.getSelectedAt());
        selection.setIsEliminated(document.getIsEliminated());
        return selection;
    }

    private ScoringRulesDocument toScoringRulesDocument(ScoringRules rules) {
        if (rules == null) {
            return null;
        }
        return ScoringRulesDocument.builder()
                .pointsPerReception(rules.getPointsPerReception())
                .pointsPerPassingYard(rules.getPointsPerPassingYard())
                .pointsPerRushingYard(rules.getPointsPerRushingYard())
                .pointsPerReceivingYard(rules.getPointsPerReceivingYard())
                .pointsPerPassingTouchdown(rules.getPointsPerPassingTouchdown())
                .pointsPerRushingTouchdown(rules.getPointsPerRushingTouchdown())
                .pointsPerReceivingTouchdown(rules.getPointsPerReceivingTouchdown())
                .pointsPerInterception(rules.getPointsPerInterception())
                .pointsPerFumbleLost(rules.getPointsPerFumbleLost())
                .pointsPerFieldGoalMade(rules.getPointsPerFieldGoalMade())
                .pointsPerExtraPointMade(rules.getPointsPerExtraPointMade())
                .pointsPerSack(rules.getPointsPerSack())
                .pointsPerInterceptionDef(rules.getPointsPerInterceptionDef())
                .pointsPerFumbleRecovery(rules.getPointsPerFumbleRecovery())
                .pointsPerDefensiveTouchdown(rules.getPointsPerDefensiveTouchdown())
                .build();
    }

    private ScoringRules toScoringRulesDomain(ScoringRulesDocument document) {
        if (document == null) {
            return null;
        }
        ScoringRules rules = new ScoringRules();
        rules.setPointsPerReception(document.getPointsPerReception());
        rules.setPointsPerPassingYard(document.getPointsPerPassingYard());
        rules.setPointsPerRushingYard(document.getPointsPerRushingYard());
        rules.setPointsPerReceivingYard(document.getPointsPerReceivingYard());
        rules.setPointsPerPassingTouchdown(document.getPointsPerPassingTouchdown());
        rules.setPointsPerRushingTouchdown(document.getPointsPerRushingTouchdown());
        rules.setPointsPerReceivingTouchdown(document.getPointsPerReceivingTouchdown());
        rules.setPointsPerInterception(document.getPointsPerInterception());
        rules.setPointsPerFumbleLost(document.getPointsPerFumbleLost());
        rules.setPointsPerFieldGoalMade(document.getPointsPerFieldGoalMade());
        rules.setPointsPerExtraPointMade(document.getPointsPerExtraPointMade());
        rules.setPointsPerSack(document.getPointsPerSack());
        rules.setPointsPerInterceptionDef(document.getPointsPerInterceptionDef());
        rules.setPointsPerFumbleRecovery(document.getPointsPerFumbleRecovery());
        rules.setPointsPerDefensiveTouchdown(document.getPointsPerDefensiveTouchdown());
        return rules;
    }
}

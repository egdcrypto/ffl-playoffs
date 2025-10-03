package com.ffl.playoffs.application.service;

import com.ffl.playoffs.application.dto.GameDTO;
import com.ffl.playoffs.application.dto.PlayerDTO;
import com.ffl.playoffs.application.dto.TeamSelectionDTO;
import com.ffl.playoffs.application.usecase.*;
import com.ffl.playoffs.domain.model.Game;
import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.model.TeamSelection;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

/**
 * Application service that orchestrates use cases and handles DTO conversion.
 */
public class ApplicationService {
    
    private final CreateGameUseCase createGameUseCase;
    private final InvitePlayerUseCase invitePlayerUseCase;
    private final SelectTeamUseCase selectTeamUseCase;
    private final CalculateScoresUseCase calculateScoresUseCase;

    public ApplicationService(CreateGameUseCase createGameUseCase,
                            InvitePlayerUseCase invitePlayerUseCase,
                            SelectTeamUseCase selectTeamUseCase,
                            CalculateScoresUseCase calculateScoresUseCase) {
        this.createGameUseCase = createGameUseCase;
        this.invitePlayerUseCase = invitePlayerUseCase;
        this.selectTeamUseCase = selectTeamUseCase;
        this.calculateScoresUseCase = calculateScoresUseCase;
    }

    public GameDTO createGame(String name, LocalDateTime startDate, LocalDateTime endDate, UUID creatorId) {
        Game game = createGameUseCase.execute(name, startDate, endDate, creatorId);
        return convertToGameDTO(game);
    }

    public PlayerDTO invitePlayer(UUID gameId, String playerName, String playerEmail) {
        Player player = invitePlayerUseCase.execute(gameId, playerName, playerEmail);
        return convertToPlayerDTO(player);
    }

    public TeamSelectionDTO selectTeam(UUID playerId, UUID weekId, String teamCode) {
        TeamSelection selection = selectTeamUseCase.execute(playerId, weekId, teamCode);
        return convertToTeamSelectionDTO(selection);
    }

    public Map<UUID, Score> calculateScores(UUID gameId, Integer weekNumber, Integer nflWeek, Integer season) {
        return calculateScoresUseCase.execute(gameId, weekNumber, nflWeek, season);
    }

    // DTO Conversion methods
    private GameDTO convertToGameDTO(Game game) {
        GameDTO dto = new GameDTO();
        dto.setId(game.getId());
        dto.setName(game.getName());
        dto.setCreatedAt(game.getCreatedAt());
        dto.setStartDate(game.getStartDate());
        dto.setEndDate(game.getEndDate());
        dto.setStatus(game.getStatus());
        dto.setCreatorId(game.getCreatorId());
        return dto;
    }

    private PlayerDTO convertToPlayerDTO(Player player) {
        PlayerDTO dto = new PlayerDTO();
        dto.setId(player.getId());
        dto.setName(player.getName());
        dto.setEmail(player.getEmail());
        dto.setGameId(player.getGameId());
        dto.setJoinedAt(player.getJoinedAt());
        dto.setStatus(player.getStatus());
        return dto;
    }

    private TeamSelectionDTO convertToTeamSelectionDTO(TeamSelection selection) {
        TeamSelectionDTO dto = new TeamSelectionDTO();
        dto.setId(selection.getId());
        dto.setPlayerId(selection.getPlayerId());
        dto.setWeekId(selection.getWeekId());
        dto.setTeamCode(selection.getTeamCode());
        dto.setSelectedAt(selection.getSelectedAt());
        dto.setScore(selection.getScore());
        return dto;
    }
}

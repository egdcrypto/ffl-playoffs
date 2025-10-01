package com.ffl.playoffs.application.service;

import com.ffl.playoffs.application.dto.GameDTO;
import com.ffl.playoffs.application.dto.PlayerDTO;
import com.ffl.playoffs.application.dto.TeamSelectionDTO;
import com.ffl.playoffs.application.usecase.*;
import com.ffl.playoffs.domain.model.Game;
import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.model.TeamSelection;
import com.ffl.playoffs.domain.port.GameRepository;
import com.ffl.playoffs.domain.port.PlayerRepository;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Application service that coordinates use cases and handles DTO conversion
 * This is the facade for the application layer
 */
public class ApplicationService {

    private final CreateGameUseCase createGameUseCase;
    private final InvitePlayerUseCase invitePlayerUseCase;
    private final SelectTeamUseCase selectTeamUseCase;
    private final CalculateScoresUseCase calculateScoresUseCase;
    private final GameRepository gameRepository;
    private final PlayerRepository playerRepository;

    public ApplicationService(
            CreateGameUseCase createGameUseCase,
            InvitePlayerUseCase invitePlayerUseCase,
            SelectTeamUseCase selectTeamUseCase,
            CalculateScoresUseCase calculateScoresUseCase,
            GameRepository gameRepository,
            PlayerRepository playerRepository) {
        this.createGameUseCase = createGameUseCase;
        this.invitePlayerUseCase = invitePlayerUseCase;
        this.selectTeamUseCase = selectTeamUseCase;
        this.calculateScoresUseCase = calculateScoresUseCase;
        this.gameRepository = gameRepository;
        this.playerRepository = playerRepository;
    }

    // Game operations
    public GameDTO createGame(String name, UUID creatorId, Integer startingWeek) {
        CreateGameUseCase.CreateGameCommand command =
                new CreateGameUseCase.CreateGameCommand(name, creatorId, startingWeek);
        Game game = createGameUseCase.execute(command);
        return toGameDTO(game);
    }

    public GameDTO getGame(UUID gameId) {
        Game game = gameRepository.findById(gameId)
                .orElseThrow(() -> new IllegalArgumentException("Game not found"));
        return toGameDTO(game);
    }

    public GameDTO getGameByCode(String code) {
        Game game = gameRepository.findByCode(code)
                .orElseThrow(() -> new IllegalArgumentException("Game not found"));
        return toGameDTO(game);
    }

    public List<GameDTO> getGamesByCreator(UUID creatorId) {
        return gameRepository.findByCreatorId(creatorId).stream()
                .map(this::toGameDTO)
                .collect(Collectors.toList());
    }

    // Player operations
    public PlayerDTO invitePlayer(UUID gameId, String name, String email) {
        InvitePlayerUseCase.InvitePlayerCommand command =
                new InvitePlayerUseCase.InvitePlayerCommand(gameId, name, email);
        Player player = invitePlayerUseCase.execute(command);
        return toPlayerDTO(player);
    }

    public List<PlayerDTO> getGamePlayers(UUID gameId) {
        return playerRepository.findByGameId(gameId).stream()
                .map(this::toPlayerDTO)
                .collect(Collectors.toList());
    }

    // Team selection operations
    public TeamSelectionDTO selectTeam(UUID playerId, Integer week, String nflTeamCode) {
        SelectTeamUseCase.SelectTeamCommand command =
                new SelectTeamUseCase.SelectTeamCommand(playerId, week, nflTeamCode);
        TeamSelection selection = selectTeamUseCase.execute(command);
        return toTeamSelectionDTO(selection);
    }

    // Score calculation
    public void calculateScores(UUID gameId, Integer week) {
        CalculateScoresUseCase.CalculateScoresCommand command =
                new CalculateScoresUseCase.CalculateScoresCommand(gameId, week);
        calculateScoresUseCase.execute(command);
    }

    // DTO Conversion methods
    private GameDTO toGameDTO(Game game) {
        GameDTO dto = new GameDTO();
        dto.setId(game.getId());
        dto.setName(game.getName());
        dto.setCode(game.getCode());
        dto.setCreatorId(game.getCreatorId());
        dto.setStatus(game.getStatus().toString());
        dto.setStartingWeek(game.getStartingWeek());
        dto.setCurrentWeek(game.getCurrentWeek());
        dto.setCreatedAt(game.getCreatedAt());

        if (game.getPlayers() != null) {
            dto.setPlayers(game.getPlayers().stream()
                    .map(this::toPlayerDTO)
                    .collect(Collectors.toList()));
        }

        return dto;
    }

    private PlayerDTO toPlayerDTO(Player player) {
        PlayerDTO dto = new PlayerDTO();
        dto.setId(player.getId());
        dto.setGameId(player.getGameId());
        dto.setName(player.getName());
        dto.setEmail(player.getEmail());
        dto.setStatus(player.getStatus().toString());
        dto.setJoinedAt(player.getJoinedAt());
        dto.setEliminated(player.isEliminated());

        if (player.getTeamSelections() != null) {
            dto.setTeamSelections(player.getTeamSelections().stream()
                    .map(this::toTeamSelectionDTO)
                    .collect(Collectors.toList()));
        }

        return dto;
    }

    private TeamSelectionDTO toTeamSelectionDTO(TeamSelection selection) {
        TeamSelectionDTO dto = new TeamSelectionDTO();
        dto.setId(selection.getId());
        dto.setPlayerId(selection.getPlayerId());
        dto.setWeek(selection.getWeek());
        dto.setNflTeamCode(selection.getNflTeamCode());
        dto.setNflTeamName(selection.getNflTeamName());
        dto.setStatus(selection.getStatus().toString());
        dto.setSelectedAt(selection.getSelectedAt());

        if (selection.getScore() != null) {
            dto.setTotalPoints(selection.getScore().getTotalPoints());
            dto.setWin(selection.getScore().isWin());
        }

        return dto;
    }
}

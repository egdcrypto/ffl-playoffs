package com.ffl.playoffs.application.service;

import com.ffl.playoffs.application.dto.GameDTO;
import com.ffl.playoffs.application.dto.PlayerDTO;
import com.ffl.playoffs.application.dto.TeamSelectionDTO;
import com.ffl.playoffs.application.usecase.*;
import com.ffl.playoffs.domain.model.Score;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ApplicationService {
    private final CreateGameUseCase createGameUseCase;
    private final InvitePlayerUseCase invitePlayerUseCase;
    private final SelectTeamUseCase selectTeamUseCase;
    private final CalculateScoresUseCase calculateScoresUseCase;
    
    public GameDTO createGame(String gameName, String creatorEmail) {
        return createGameUseCase.execute(gameName, creatorEmail);
    }
    
    public PlayerDTO invitePlayer(String inviteCode, String email, String displayName, String googleId) {
        return invitePlayerUseCase.execute(inviteCode, email, displayName, googleId);
    }
    
    public TeamSelectionDTO selectTeam(UUID playerId, UUID weekId, String nflTeam) {
        return selectTeamUseCase.execute(playerId, weekId, nflTeam);
    }
    
    public List<Score> calculateScores(Long weekId, int season) {
        return calculateScoresUseCase.execute(weekId, season);
    }
}

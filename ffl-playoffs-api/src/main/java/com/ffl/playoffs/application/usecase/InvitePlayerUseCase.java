package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.PlayerDTO;
import com.ffl.playoffs.domain.model.Game;
import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.port.GameRepository;
import com.ffl.playoffs.domain.port.PlayerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class InvitePlayerUseCase {
    private final GameRepository gameRepository;
    private final PlayerRepository playerRepository;
    
    public PlayerDTO execute(String inviteCode, String email, String displayName, String googleId) {
        Game game = gameRepository.findByInviteCode(inviteCode)
                .orElseThrow(() -> new IllegalArgumentException("Invalid invite code"));
        
        if (game.getStatus() != Game.GameStatus.PENDING) {
            throw new IllegalStateException("Game has already started");
        }
        
        Player player = Player.builder()
                .email(email)
                .displayName(displayName)
                .googleId(googleId)
                .joinedAt(LocalDateTime.now())
                .status(Player.PlayerStatus.ACTIVE)
                .build();
        
        Player savedPlayer = playerRepository.save(player);
        game.addPlayer(savedPlayer);
        gameRepository.save(game);
        
        return PlayerDTO.fromDomain(savedPlayer);
    }
}

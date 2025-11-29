package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.GameDTO;
import com.ffl.playoffs.domain.event.GameCreatedEvent;
import com.ffl.playoffs.domain.aggregate.Game;
import com.ffl.playoffs.domain.port.GameRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CreateGameUseCase {
    private final GameRepository gameRepository;
    
    public GameDTO execute(String gameName, String creatorEmail) {
        String inviteCode = generateInviteCode();
        
        Game game = Game.builder()
                .name(gameName)
                .inviteCode(inviteCode)
                .createdAt(LocalDateTime.now())
                .currentWeek(0)
                .status(Game.GameStatus.PENDING)
                .build();
        
        Game savedGame = gameRepository.save(game);
        
        // Publish event (implement event publisher later)
        publishGameCreatedEvent(savedGame, creatorEmail);
        
        return GameDTO.fromDomain(savedGame);
    }
    
    private String generateInviteCode() {
        return UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
    
    private void publishGameCreatedEvent(Game game, String creatorEmail) {
        GameCreatedEvent event = GameCreatedEvent.builder()
                .gameId(game.getId())
                .gameName(game.getName())
                .inviteCode(game.getInviteCode())
                .creatorEmail(creatorEmail)
                .createdAt(game.getCreatedAt())
                .build();
        // TODO: Publish event to event bus
    }
}

package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Game;
import com.ffl.playoffs.domain.model.ScoringRules;
import com.ffl.playoffs.domain.port.GameRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.UUID;

/**
 * Use case for creating a new game.
 */
@Service
@RequiredArgsConstructor
public class CreateGameUseCase {

    private final GameRepository gameRepository;

    @Transactional
    public Game execute(String gameName, UUID creatorId) {
        Game game = Game.builder()
                .id(UUID.randomUUID())
                .name(gameName)
                .creatorId(creatorId)
                .createdAt(LocalDateTime.now())
                .status(Game.GameStatus.SETUP)
                .players(new ArrayList<>())
                .weeks(new ArrayList<>())
                .scoringRules(ScoringRules.defaultRules())
                .build();

        return gameRepository.save(game);
    }
}

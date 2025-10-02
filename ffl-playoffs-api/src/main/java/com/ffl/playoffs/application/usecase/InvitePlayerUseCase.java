package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Game;
import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.port.GameRepository;
import com.ffl.playoffs.domain.port.PlayerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.UUID;

/**
 * Use case for inviting a player to a game.
 */
@Service
@RequiredArgsConstructor
public class InvitePlayerUseCase {

    private final GameRepository gameRepository;
    private final PlayerRepository playerRepository;

    @Transactional
    public Player execute(UUID gameId, String playerName, String email) {
        Game game = gameRepository.findById(gameId)
                .orElseThrow(() -> new IllegalArgumentException("Game not found: " + gameId));

        if (!game.isSetup()) {
            throw new IllegalStateException("Cannot invite players to a game that has already started");
        }

        Player player = Player.builder()
                .id(UUID.randomUUID())
                .gameId(gameId)
                .name(playerName)
                .email(email)
                .status(Player.PlayerStatus.INVITED)
                .joinedAt(LocalDateTime.now())
                .teamSelections(new ArrayList<>())
                .totalScore(0)
                .isEliminated(false)
                .build();

        return playerRepository.save(player);
    }
}

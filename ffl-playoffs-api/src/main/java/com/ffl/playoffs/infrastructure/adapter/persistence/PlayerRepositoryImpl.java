package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.Game;
import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.port.PlayerRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.GameDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.GameMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.GameMongoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of PlayerRepository
 * Infrastructure layer - implements domain port
 *
 * Note: Players are embedded within Game documents in MongoDB,
 * so we query games to find players
 */
@Repository
@RequiredArgsConstructor
public class PlayerRepositoryImpl implements PlayerRepository {

    private final GameMongoRepository gameMongoRepository;
    private final GameMapper gameMapper;

    @Override
    public Player save(Player player) {
        // Find the game containing this player
        UUID gameId = player.getGameId();
        Optional<GameDocument> gameDoc = gameMongoRepository.findById(gameId);

        if (gameDoc.isEmpty()) {
            throw new IllegalStateException("Game not found for player: " + player.getId());
        }

        Game game = gameMapper.toDomain(gameDoc.get());

        // Update or add the player in the game's player list
        List<Player> players = game.getPlayers();
        players.removeIf(p -> p.getId().equals(player.getId()));
        players.add(player);

        // Save the game with updated player
        GameDocument updatedDoc = gameMapper.toDocument(game);
        gameMongoRepository.save(updatedDoc);

        return player;
    }

    @Override
    public Optional<Player> findById(String id) {
        UUID playerId = UUID.fromString(id);

        // Search all games for this player
        return gameMongoRepository.findAll().stream()
                .map(gameMapper::toDomain)
                .flatMap(game -> game.getPlayers().stream())
                .filter(player -> player.getId().equals(playerId))
                .findFirst();
    }

    @Override
    public List<Player> findByGameId(String gameId) {
        UUID uuid = UUID.fromString(gameId);
        return gameMongoRepository.findById(uuid)
                .map(gameMapper::toDomain)
                .map(Game::getPlayers)
                .orElse(Collections.emptyList());
    }

    @Override
    public void delete(String id) {
        UUID playerId = UUID.fromString(id);

        // Find the game containing this player and remove them
        gameMongoRepository.findAll().stream()
                .map(gameMapper::toDomain)
                .filter(game -> game.getPlayers().stream()
                        .anyMatch(p -> p.getId().equals(playerId)))
                .findFirst()
                .ifPresent(game -> {
                    game.getPlayers().removeIf(p -> p.getId().equals(playerId));
                    GameDocument doc = gameMapper.toDocument(game);
                    gameMongoRepository.save(doc);
                });
    }

    @Override
    public Optional<Player> findByEmail(String email) {
        return gameMongoRepository.findAll().stream()
                .map(gameMapper::toDomain)
                .flatMap(game -> game.getPlayers().stream())
                .filter(player -> email.equals(player.getEmail()))
                .findFirst();
    }
}

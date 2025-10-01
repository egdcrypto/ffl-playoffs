package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.port.PlayerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class PlayerRepositoryImpl implements PlayerRepository {

    // TODO: Inject JPA repository or use direct EntityManager
    // private final PlayerJpaRepository jpaRepository;

    @Override
    public Player save(Player player) {
        // TODO: Map domain Player to JPA entity, save, and map back
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public Optional<Player> findById(String id) {
        // TODO: Find by ID and map to domain model
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public List<Player> findByGameId(String gameId) {
        // TODO: Find all players for a game and map to domain models
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public void delete(String id) {
        // TODO: Delete by ID
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public Optional<Player> findByEmail(String email) {
        // TODO: Find player by email
        throw new UnsupportedOperationException("Not yet implemented");
    }
}

package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.Game;
import com.ffl.playoffs.domain.port.GameRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class GameRepositoryImpl implements GameRepository {

    // TODO: Inject JPA repository or use direct EntityManager
    // private final GameJpaRepository jpaRepository;

    @Override
    public Game save(Game game) {
        // TODO: Map domain Game to JPA entity, save, and map back
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public Optional<Game> findById(String id) {
        // TODO: Find by ID and map to domain model
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public List<Game> findAll() {
        // TODO: Find all and map to domain models
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public void delete(String id) {
        // TODO: Delete by ID
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public Optional<Game> findByInviteCode(String inviteCode) {
        // TODO: Find by invite code
        throw new UnsupportedOperationException("Not yet implemented");
    }
}

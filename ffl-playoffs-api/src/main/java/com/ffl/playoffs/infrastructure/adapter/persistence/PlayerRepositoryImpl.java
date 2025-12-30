package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.port.PlayerRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.StandalonePlayerDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.PlayerMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.PlayerMongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of PlayerRepository port
 * Infrastructure layer adapter
 */
@Repository
public class PlayerRepositoryImpl implements PlayerRepository {

    private final PlayerMongoRepository mongoRepository;
    private final PlayerMapper mapper;

    public PlayerRepositoryImpl(PlayerMongoRepository mongoRepository, PlayerMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public Player save(Player player) {
        StandalonePlayerDocument document = mapper.toDocument(player);
        StandalonePlayerDocument saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<Player> findById(Long id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<Player> findByEmail(String email) {
        return mongoRepository.findByEmail(email)
                .map(mapper::toDomain);
    }

    @Override
    public Optional<Player> findByGoogleId(String googleId) {
        return mongoRepository.findByGoogleId(googleId)
                .map(mapper::toDomain);
    }

    @Override
    public List<Player> findAll() {
        return mongoRepository.findAll().stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Player> findByGameId(Long gameId) {
        // Note: The standalone Player model doesn't have gameId.
        // For game-specific player queries, use LeaguePlayerRepository instead.
        // This method returns empty list as standalone players aren't game-scoped.
        return List.of();
    }

    @Override
    public void delete(Long id) {
        mongoRepository.deleteById(id.toString());
    }
}

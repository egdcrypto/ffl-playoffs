package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.Game;
import com.ffl.playoffs.domain.port.GameRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.GameDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.GameMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.GameMongoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of GameRepository
 * Infrastructure layer - implements domain port
 */
@Repository
@RequiredArgsConstructor
public class GameRepositoryImpl implements GameRepository {

    private final GameMongoRepository mongoRepository;
    private final GameMapper gameMapper;

    @Override
    public Game save(Game game) {
        game.setUpdatedAt(LocalDateTime.now());
        GameDocument document = gameMapper.toDocument(game);
        GameDocument saved = mongoRepository.save(document);
        return gameMapper.toDomain(saved);
    }

    @Override
    public Optional<Game> findById(String id) {
        UUID uuid = UUID.fromString(id);
        return mongoRepository.findById(uuid)
                .map(gameMapper::toDomain);
    }

    @Override
    public List<Game> findAll() {
        return mongoRepository.findAll().stream()
                .map(gameMapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public void delete(String id) {
        UUID uuid = UUID.fromString(id);
        mongoRepository.deleteById(uuid);
    }

    @Override
    public Optional<Game> findByInviteCode(String inviteCode) {
        return mongoRepository.findByCode(inviteCode)
                .map(gameMapper::toDomain);
    }
}

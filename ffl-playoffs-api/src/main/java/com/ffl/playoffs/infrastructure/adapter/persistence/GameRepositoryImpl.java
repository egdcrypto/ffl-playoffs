package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.Game;
import com.ffl.playoffs.domain.port.GameRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.GameDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.GameMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.GameMongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of GameRepository port
 * Infrastructure layer adapter
 */
@Repository
public class GameRepositoryImpl implements GameRepository {

    private final GameMongoRepository mongoRepository;
    private final GameMapper mapper;

    public GameRepositoryImpl(GameMongoRepository mongoRepository, GameMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public Game save(Game game) {
        GameDocument document = mapper.toDocument(game);
        // Generate UUID if not present
        if (document.getId() == null) {
            document.setId(UUID.randomUUID());
        }
        GameDocument saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<Game> findById(Long id) {
        // Convert Long to UUID using a deterministic approach
        // Note: This is a workaround for the Long/UUID mismatch in the codebase
        return mongoRepository.findAll().stream()
                .filter(doc -> doc.getId() != null &&
                        Long.parseLong(doc.getId().toString().hashCode() + "") == id)
                .findFirst()
                .map(mapper::toDomain);
    }

    @Override
    public Optional<Game> findByInviteCode(String inviteCode) {
        return mongoRepository.findByCode(inviteCode)
                .map(mapper::toDomain);
    }

    @Override
    public List<Game> findAll() {
        return mongoRepository.findAll().stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Game> findByPlayerId(Long playerId) {
        // Convert Long to UUID - searching for games where player is a participant
        // Due to the Long/UUID mismatch, we need to filter all games
        return mongoRepository.findAll().stream()
                .filter(doc -> doc.getPlayers() != null &&
                        doc.getPlayers().stream()
                                .anyMatch(p -> p.getId() != null &&
                                        Long.parseLong(p.getId().toString().hashCode() + "") == playerId))
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public void delete(Long id) {
        // Find the document first to get its UUID
        mongoRepository.findAll().stream()
                .filter(doc -> doc.getId() != null &&
                        Long.parseLong(doc.getId().toString().hashCode() + "") == id)
                .findFirst()
                .ifPresent(doc -> mongoRepository.deleteById(doc.getId()));
    }

    @Override
    public boolean existsByInviteCode(String inviteCode) {
        return mongoRepository.existsByCode(inviteCode);
    }
}

package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.WorldAccessControl;
import com.ffl.playoffs.domain.port.WorldAccessControlRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldAccessControlDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.WorldAccessControlMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.WorldAccessControlMongoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Repository
@RequiredArgsConstructor
public class WorldAccessControlRepositoryImpl implements WorldAccessControlRepository {

    private final WorldAccessControlMongoRepository mongoRepository;
    private final WorldAccessControlMapper mapper;

    @Override
    public WorldAccessControl save(WorldAccessControl accessControl) {
        WorldAccessControlDocument document = mapper.toDocument(accessControl);
        WorldAccessControlDocument saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<WorldAccessControl> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<WorldAccessControl> findByWorldId(UUID worldId) {
        return mongoRepository.findByWorldId(worldId.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<WorldAccessControl> findByMemberId(UUID userId) {
        return mongoRepository.findByMemberId(userId.toString()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<WorldAccessControl> findByActiveMemberId(UUID userId) {
        return mongoRepository.findByActiveMemberId(userId.toString()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<WorldAccessControl> findByOwnerId(UUID ownerId) {
        return mongoRepository.findByOwnerId(ownerId.toString()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<WorldAccessControl> findPublicWorlds() {
        return mongoRepository.findPublicWorlds().stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<WorldAccessControl> findWithPendingInvitationForUser(UUID userId) {
        return mongoRepository.findWithPendingInvitationForUser(userId.toString()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public void deleteByWorldId(UUID worldId) {
        mongoRepository.deleteByWorldId(worldId.toString());
    }

    @Override
    public boolean existsByWorldId(UUID worldId) {
        return mongoRepository.existsByWorldId(worldId.toString());
    }
}

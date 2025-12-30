package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.worldowner.OwnershipRole;
import com.ffl.playoffs.domain.model.worldowner.OwnershipStatus;
import com.ffl.playoffs.domain.model.worldowner.WorldOwnerPermission;
import com.ffl.playoffs.domain.model.worldowner.WorldOwnerPlayer;
import com.ffl.playoffs.domain.port.WorldOwnerPlayerRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldOwnerPlayerDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.WorldOwnerPlayerMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.WorldOwnerPlayerMongoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
@RequiredArgsConstructor
public class WorldOwnerPlayerRepositoryImpl implements WorldOwnerPlayerRepository {

    private final WorldOwnerPlayerMongoRepository mongoRepository;
    private final WorldOwnerPlayerMapper mapper;

    @Override
    public WorldOwnerPlayer save(WorldOwnerPlayer ownerPlayer) {
        WorldOwnerPlayerDocument document = mapper.toDocument(ownerPlayer);
        WorldOwnerPlayerDocument saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<WorldOwnerPlayer> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<WorldOwnerPlayer> findByUserIdAndWorldId(UUID userId, UUID worldId) {
        return mongoRepository.findByUserIdAndWorldId(userId.toString(), worldId.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<WorldOwnerPlayer> findByWorldId(UUID worldId) {
        return mapper.toDomainList(mongoRepository.findByWorldId(worldId.toString()));
    }

    @Override
    public List<WorldOwnerPlayer> findActiveByWorldId(UUID worldId) {
        return mapper.toDomainList(mongoRepository.findActiveByWorldId(worldId.toString()));
    }

    @Override
    public List<WorldOwnerPlayer> findByWorldIdAndRole(UUID worldId, OwnershipRole role) {
        return mapper.toDomainList(
                mongoRepository.findByWorldIdAndRole(worldId.toString(), role.getCode())
        );
    }

    @Override
    public List<WorldOwnerPlayer> findByWorldIdAndStatus(UUID worldId, OwnershipStatus status) {
        return mapper.toDomainList(
                mongoRepository.findByWorldIdAndStatus(worldId.toString(), status.getCode())
        );
    }

    @Override
    public List<WorldOwnerPlayer> findByUserId(UUID userId) {
        return mapper.toDomainList(mongoRepository.findByUserId(userId.toString()));
    }

    @Override
    public List<WorldOwnerPlayer> findActiveByUserId(UUID userId) {
        return mapper.toDomainList(mongoRepository.findActiveByUserId(userId.toString()));
    }

    @Override
    public Optional<WorldOwnerPlayer> findByInvitationToken(String token) {
        return mongoRepository.findByInvitationToken(token)
                .map(mapper::toDomain);
    }

    @Override
    public boolean existsByUserIdAndWorldId(UUID userId, UUID worldId) {
        return mongoRepository.existsByUserIdAndWorldId(userId.toString(), worldId.toString());
    }

    @Override
    public boolean isActiveOwner(UUID userId, UUID worldId) {
        return mongoRepository.isActiveOwner(userId.toString(), worldId.toString());
    }

    @Override
    public boolean hasPermission(UUID userId, UUID worldId, WorldOwnerPermission permission) {
        return findByUserIdAndWorldId(userId, worldId)
                .map(owner -> owner.hasPermission(permission))
                .orElse(false);
    }

    @Override
    public long countActiveByWorldId(UUID worldId) {
        return mongoRepository.countActiveByWorldId(worldId.toString());
    }

    @Override
    public long countPrimaryOwnersByWorldId(UUID worldId) {
        return mongoRepository.countPrimaryOwnersByWorldId(worldId.toString());
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public void deleteByWorldId(UUID worldId) {
        mongoRepository.deleteByWorldId(worldId.toString());
    }
}

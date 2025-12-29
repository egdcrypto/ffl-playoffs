package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.entity.AdminAuditLog;
import com.ffl.playoffs.domain.model.AdminAction;
import com.ffl.playoffs.domain.port.AdminAuditLogRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.AdminAuditLogMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.AdminAuditLogMongoRepository;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of AdminAuditLogRepository port
 */
@Repository
public class AdminAuditLogRepositoryImpl implements AdminAuditLogRepository {

    private final AdminAuditLogMongoRepository mongoRepository;
    private final AdminAuditLogMapper mapper;

    public AdminAuditLogRepositoryImpl(AdminAuditLogMongoRepository mongoRepository,
                                        AdminAuditLogMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public AdminAuditLog save(AdminAuditLog log) {
        var document = mapper.toDocument(log);
        var saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<AdminAuditLog> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<AdminAuditLog> findByAdminId(UUID adminId) {
        return mongoRepository.findByAdminId(adminId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<AdminAuditLog> findByAction(AdminAction action) {
        return mongoRepository.findByAction(action.name())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<AdminAuditLog> findByTimestampBetween(LocalDateTime start, LocalDateTime end) {
        return mongoRepository.findByTimestampBetween(start, end)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<AdminAuditLog> findAll(int offset, int limit) {
        PageRequest pageRequest = PageRequest.of(offset / limit, limit);
        return mongoRepository.findAllByOrderByTimestampDesc(pageRequest)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public long count() {
        return mongoRepository.count();
    }
}

package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.PerformanceAlert;
import com.ffl.playoffs.domain.model.performance.AlertSeverity;
import com.ffl.playoffs.domain.model.performance.AlertStatus;
import com.ffl.playoffs.domain.model.performance.MetricType;
import com.ffl.playoffs.domain.port.PerformanceAlertRepository;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.PerformanceAlertDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.mapper.PerformanceAlertMapper;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoPerformanceAlertRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of PerformanceAlertRepository.
 */
@Repository
@RequiredArgsConstructor
public class PerformanceAlertRepositoryImpl implements PerformanceAlertRepository {

    private final MongoPerformanceAlertRepository mongoRepository;
    private final PerformanceAlertMapper mapper;

    @Override
    public PerformanceAlert save(PerformanceAlert alert) {
        PerformanceAlertDocument doc = mapper.toDocument(alert);
        PerformanceAlertDocument saved = mongoRepository.save(doc);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<PerformanceAlert> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<PerformanceAlert> findAll() {
        return mongoRepository.findAll().stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<PerformanceAlert> findByStatus(AlertStatus status) {
        return mongoRepository.findByStatus(status.getCode()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<PerformanceAlert> findBySeverity(AlertSeverity severity) {
        return mongoRepository.findByThreshold_Severity(severity.getCode()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<PerformanceAlert> findByMetricType(MetricType metricType) {
        return mongoRepository.findByThreshold_MetricType(metricType.getCode()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<PerformanceAlert> findAllEnabled() {
        return mongoRepository.findByEnabledTrue().stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<PerformanceAlert> findActiveAlerts() {
        List<String> activeStatuses = List.of(
                AlertStatus.ACTIVE.getCode(),
                AlertStatus.ACKNOWLEDGED.getCode()
        );
        return mongoRepository.findByStatusIn(activeStatuses).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<PerformanceAlert> findByCreatedBy(UUID userId) {
        return mongoRepository.findByCreatedBy(userId.toString()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public long countActiveAlerts() {
        List<String> activeStatuses = List.of(
                AlertStatus.ACTIVE.getCode(),
                AlertStatus.ACKNOWLEDGED.getCode()
        );
        return mongoRepository.countByStatusIn(activeStatuses);
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }
}

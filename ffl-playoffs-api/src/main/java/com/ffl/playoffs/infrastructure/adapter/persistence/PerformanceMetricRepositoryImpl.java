package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.PerformanceMetricSnapshot;
import com.ffl.playoffs.domain.model.performance.MetricType;
import com.ffl.playoffs.domain.port.PerformanceMetricRepository;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.PerformanceMetricSnapshotDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.mapper.PerformanceMetricSnapshotMapper;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoPerformanceMetricSnapshotRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.aggregation.*;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of PerformanceMetricRepository.
 */
@Repository
@RequiredArgsConstructor
public class PerformanceMetricRepositoryImpl implements PerformanceMetricRepository {

    private final MongoPerformanceMetricSnapshotRepository mongoRepository;
    private final PerformanceMetricSnapshotMapper mapper;
    private final MongoTemplate mongoTemplate;

    @Override
    public PerformanceMetricSnapshot save(PerformanceMetricSnapshot snapshot) {
        PerformanceMetricSnapshotDocument doc = mapper.toDocument(snapshot);
        PerformanceMetricSnapshotDocument saved = mongoRepository.save(doc);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<PerformanceMetricSnapshot> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<PerformanceMetricSnapshot> findLatest() {
        return mongoRepository.findTopByOrderByTimestampDesc()
                .map(mapper::toDomain);
    }

    @Override
    public Optional<PerformanceMetricSnapshot> findLatestByService(String service) {
        return mongoRepository.findTopByServiceOrderByTimestampDesc(service)
                .map(mapper::toDomain);
    }

    @Override
    public List<PerformanceMetricSnapshot> findByTimeRange(Instant start, Instant end) {
        return mongoRepository.findByTimestampBetween(start, end, Sort.by(Sort.Direction.ASC, "timestamp"))
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<PerformanceMetricSnapshot> findByServiceAndTimeRange(String service, Instant start, Instant end) {
        return mongoRepository.findByServiceAndTimestampBetween(service, start, end).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<PerformanceMetricSnapshot> findByEndpointAndTimeRange(String endpoint, Instant start, Instant end) {
        return mongoRepository.findByEndpointAndTimestampBetween(endpoint, start, end).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<AggregatedMetric> getAggregatedMetrics(MetricType type, Instant start, Instant end,
                                                       AggregationInterval interval) {
        String metricField = "metrics." + type.getCode();
        long intervalMillis = getIntervalMillis(interval);

        MatchOperation matchStage = Aggregation.match(
                Criteria.where("timestamp").gte(start).lte(end)
                        .and(metricField).exists(true)
        );

        ProjectionOperation projectStage = Aggregation.project()
                .and("timestamp").as("timestamp")
                .and(metricField).as("value")
                .and(ArithmeticOperators.Subtract.valueOf("timestamp").subtract(start.toEpochMilli()))
                .divide(intervalMillis)
                .floor()
                .as("bucket");

        GroupOperation groupStage = Aggregation.group("bucket")
                .avg("value").as("avg")
                .min("value").as("min")
                .max("value").as("max")
                .sum("value").as("sum")
                .count().as("count")
                .first("timestamp").as("timestamp");

        SortOperation sortStage = Aggregation.sort(Sort.Direction.ASC, "_id");

        Aggregation aggregation = Aggregation.newAggregation(
                matchStage,
                projectStage,
                groupStage,
                sortStage
        );

        AggregationResults<Map> results = mongoTemplate.aggregate(
                aggregation,
                "performance_metrics",
                Map.class
        );

        List<AggregatedMetric> aggregatedMetrics = new ArrayList<>();
        for (Map result : results.getMappedResults()) {
            Integer bucket = (Integer) result.get("_id");
            Instant bucketTime = start.plus(bucket * intervalMillis, ChronoUnit.MILLIS);

            aggregatedMetrics.add(new AggregatedMetric(
                    bucketTime,
                    ((Number) result.get("avg")).doubleValue(),
                    ((Number) result.get("min")).doubleValue(),
                    ((Number) result.get("max")).doubleValue(),
                    ((Number) result.get("sum")).doubleValue(),
                    ((Number) result.get("count")).longValue()
            ));
        }

        return aggregatedMetrics;
    }

    @Override
    public long deleteOlderThan(Instant timestamp) {
        return mongoRepository.deleteByTimestampBefore(timestamp);
    }

    @Override
    public long countByTimeRange(Instant start, Instant end) {
        return mongoRepository.countByTimestampBetween(start, end);
    }

    private long getIntervalMillis(AggregationInterval interval) {
        return switch (interval) {
            case MINUTE -> 60_000L;
            case FIVE_MINUTES -> 300_000L;
            case HOUR -> 3_600_000L;
            case DAY -> 86_400_000L;
        };
    }
}

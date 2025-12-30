package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.aggregate.*;
import com.ffl.playoffs.domain.model.loadtest.*;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.*;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.LoadTestScenarioDocument.*;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.LoadTestRunDocument.*;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Mapper for load testing domain objects to/from MongoDB documents.
 */
@Component
public class LoadTestMapper {

    // ==================== LoadTestScenario Mapping ====================

    public LoadTestScenarioDocument toDocument(LoadTestScenario domain) {
        if (domain == null) return null;

        return LoadTestScenarioDocument.builder()
                .id(domain.getId() != null ? domain.getId().toString() : null)
                .worldId(domain.getWorldId() != null ? domain.getWorldId().toString() : null)
                .name(domain.getName())
                .description(domain.getDescription())
                .testType(domain.getTestType() != null ? domain.getTestType().name() : null)
                .configuration(toConfigurationEmbedded(domain.getConfiguration()))
                .tags(domain.getTags())
                .enabled(domain.isEnabled())
                .priority(domain.getPriority())
                .createdAt(domain.getCreatedAt())
                .updatedAt(domain.getUpdatedAt())
                .createdBy(domain.getCreatedBy())
                .build();
    }

    public LoadTestScenario toDomain(LoadTestScenarioDocument document) {
        if (document == null) return null;

        return LoadTestScenario.builder()
                .id(document.getId() != null ? UUID.fromString(document.getId()) : null)
                .worldId(document.getWorldId() != null ? UUID.fromString(document.getWorldId()) : null)
                .name(document.getName())
                .description(document.getDescription())
                .testType(document.getTestType() != null ? LoadTestType.valueOf(document.getTestType()) : null)
                .configuration(toConfigurationDomain(document.getConfiguration()))
                .tags(document.getTags() != null ? new ArrayList<>(document.getTags()) : new ArrayList<>())
                .enabled(document.isEnabled())
                .priority(document.getPriority())
                .createdAt(document.getCreatedAt())
                .updatedAt(document.getUpdatedAt())
                .createdBy(document.getCreatedBy())
                .build();
    }

    // ==================== LoadTestRun Mapping ====================

    public LoadTestRunDocument toDocument(LoadTestRun domain) {
        if (domain == null) return null;

        return LoadTestRunDocument.builder()
                .id(domain.getId() != null ? domain.getId().toString() : null)
                .scenarioId(domain.getScenarioId() != null ? domain.getScenarioId().toString() : null)
                .worldId(domain.getWorldId() != null ? domain.getWorldId().toString() : null)
                .status(domain.getStatus() != null ? domain.getStatus().name() : null)
                .configuration(toConfigurationEmbedded(domain.getConfiguration()))
                .startTime(domain.getStartTime())
                .endTime(domain.getEndTime())
                .metrics(toMetricEmbeddedList(domain.getMetrics()))
                .thresholdResults(toThresholdResultsMap(domain.getThresholdResults()))
                .totalRequests(domain.getTotalRequests())
                .successfulRequests(domain.getSuccessfulRequests())
                .failedRequests(domain.getFailedRequests())
                .errorMessage(domain.getErrorMessage())
                .triggeredBy(domain.getTriggeredBy())
                .createdAt(domain.getCreatedAt())
                .updatedAt(domain.getUpdatedAt())
                .build();
    }

    public LoadTestRun toDomain(LoadTestRunDocument document) {
        if (document == null) return null;

        return LoadTestRun.builder()
                .id(document.getId() != null ? UUID.fromString(document.getId()) : null)
                .scenarioId(document.getScenarioId() != null ? UUID.fromString(document.getScenarioId()) : null)
                .worldId(document.getWorldId() != null ? UUID.fromString(document.getWorldId()) : null)
                .status(document.getStatus() != null ? LoadTestStatus.valueOf(document.getStatus()) : null)
                .configuration(toConfigurationDomain(document.getConfiguration()))
                .startTime(document.getStartTime())
                .endTime(document.getEndTime())
                .metrics(toMetricDomainList(document.getMetrics()))
                .thresholdResults(toThresholdResultsDomain(document.getThresholdResults()))
                .totalRequests(document.getTotalRequests())
                .successfulRequests(document.getSuccessfulRequests())
                .failedRequests(document.getFailedRequests())
                .errorMessage(document.getErrorMessage())
                .triggeredBy(document.getTriggeredBy())
                .createdAt(document.getCreatedAt())
                .updatedAt(document.getUpdatedAt())
                .build();
    }

    // ==================== WorldLoadTest Mapping ====================

    public WorldLoadTestDocument toDocument(WorldLoadTest domain) {
        if (domain == null) return null;

        return WorldLoadTestDocument.builder()
                .id(domain.getId() != null ? domain.getId().toString() : null)
                .worldId(domain.getWorldId() != null ? domain.getWorldId().toString() : null)
                .worldName(domain.getWorldName())
                .overallStatus(domain.getOverallStatus() != null ? domain.getOverallStatus().name() : null)
                .currentRunId(domain.getCurrentRun() != null && domain.getCurrentRun().getId() != null ?
                        domain.getCurrentRun().getId().toString() : null)
                .lastRunAt(domain.getLastRunAt())
                .totalRunsCompleted(domain.getTotalRunsCompleted())
                .totalRunsFailed(domain.getTotalRunsFailed())
                .averageRunDurationMillis(domain.getAverageRunDuration() != null ?
                        domain.getAverageRunDuration().toMillis() : null)
                .metadata(domain.getMetadata())
                .createdAt(domain.getCreatedAt())
                .updatedAt(domain.getUpdatedAt())
                .build();
    }

    public WorldLoadTest toDomain(WorldLoadTestDocument document) {
        if (document == null) return null;

        return WorldLoadTest.builder()
                .id(document.getId() != null ? UUID.fromString(document.getId()) : null)
                .worldId(document.getWorldId() != null ? UUID.fromString(document.getWorldId()) : null)
                .worldName(document.getWorldName())
                .overallStatus(document.getOverallStatus() != null ?
                        WorldLoadTest.WorldLoadTestStatus.valueOf(document.getOverallStatus()) : null)
                .lastRunAt(document.getLastRunAt())
                .totalRunsCompleted(document.getTotalRunsCompleted())
                .totalRunsFailed(document.getTotalRunsFailed())
                .averageRunDuration(document.getAverageRunDurationMillis() != null ?
                        Duration.ofMillis(document.getAverageRunDurationMillis()) : null)
                .metadata(document.getMetadata() != null ? new HashMap<>(document.getMetadata()) : new HashMap<>())
                .createdAt(document.getCreatedAt())
                .updatedAt(document.getUpdatedAt())
                .scenarios(new ArrayList<>())
                .recentRuns(new ArrayList<>())
                .build();
    }

    // ==================== Configuration Mapping ====================

    private LoadTestConfigurationEmbedded toConfigurationEmbedded(LoadTestConfiguration config) {
        if (config == null) return null;

        Map<String, LoadTestThresholdEmbedded> thresholds = new HashMap<>();
        if (config.getThresholds() != null) {
            for (Map.Entry<MetricType, LoadTestThreshold> entry : config.getThresholds().entrySet()) {
                thresholds.put(entry.getKey().name(), toThresholdEmbedded(entry.getValue()));
            }
        }

        return LoadTestConfigurationEmbedded.builder()
                .name(config.getName())
                .testType(config.getTestType() != null ? config.getTestType().name() : null)
                .concurrencySettings(toConcurrencyEmbedded(config.getConcurrencySettings()))
                .targetEndpoints(config.getTargetEndpoints())
                .thresholds(thresholds)
                .timeoutSeconds(config.getTimeout() != null ? config.getTimeout().getSeconds() : null)
                .maxRetries(config.getMaxRetries())
                .collectDetailedMetrics(config.isCollectDetailedMetrics())
                .customParameters(config.getCustomParameters())
                .build();
    }

    private LoadTestConfiguration toConfigurationDomain(LoadTestConfigurationEmbedded doc) {
        if (doc == null) return null;

        LoadTestConfiguration.Builder builder = LoadTestConfiguration.builder(doc.getName())
                .testType(doc.getTestType() != null ? LoadTestType.valueOf(doc.getTestType()) : LoadTestType.STRESS)
                .concurrencySettings(toConcurrencyDomain(doc.getConcurrencySettings()))
                .timeout(doc.getTimeoutSeconds() != null ? Duration.ofSeconds(doc.getTimeoutSeconds()) : null)
                .maxRetries(doc.getMaxRetries() != null ? doc.getMaxRetries() : 3)
                .collectDetailedMetrics(doc.isCollectDetailedMetrics());

        if (doc.getTargetEndpoints() != null) {
            doc.getTargetEndpoints().forEach(builder::addEndpoint);
        }

        if (doc.getThresholds() != null) {
            for (Map.Entry<String, LoadTestThresholdEmbedded> entry : doc.getThresholds().entrySet()) {
                builder.addThreshold(toThresholdDomain(entry.getKey(), entry.getValue()));
            }
        }

        if (doc.getCustomParameters() != null) {
            doc.getCustomParameters().forEach(builder::customParameter);
        }

        return builder.build();
    }

    private ConcurrencySettingsEmbedded toConcurrencyEmbedded(ConcurrencySettings settings) {
        if (settings == null) return null;

        return ConcurrencySettingsEmbedded.builder()
                .initialUsers(settings.getInitialUsers())
                .maxUsers(settings.getMaxUsers())
                .rampUpUsers(settings.getRampUpUsers())
                .rampUpDurationSeconds(settings.getRampUpDuration() != null ?
                        settings.getRampUpDuration().getSeconds() : null)
                .holdDurationSeconds(settings.getHoldDuration() != null ?
                        settings.getHoldDuration().getSeconds() : null)
                .rampDownDurationSeconds(settings.getRampDownDuration() != null ?
                        settings.getRampDownDuration().getSeconds() : null)
                .targetRequestsPerSecond(settings.getTargetRequestsPerSecond())
                .build();
    }

    private ConcurrencySettings toConcurrencyDomain(ConcurrencySettingsEmbedded doc) {
        if (doc == null) return ConcurrencySettings.defaultSettings();

        return ConcurrencySettings.create(
                doc.getInitialUsers(),
                doc.getMaxUsers(),
                doc.getRampUpUsers(),
                doc.getRampUpDurationSeconds() != null ? Duration.ofSeconds(doc.getRampUpDurationSeconds()) : null,
                doc.getHoldDurationSeconds() != null ? Duration.ofSeconds(doc.getHoldDurationSeconds()) : null,
                doc.getRampDownDurationSeconds() != null ? Duration.ofSeconds(doc.getRampDownDurationSeconds()) : null,
                doc.getTargetRequestsPerSecond()
        );
    }

    private LoadTestThresholdEmbedded toThresholdEmbedded(LoadTestThreshold threshold) {
        if (threshold == null) return null;

        return LoadTestThresholdEmbedded.builder()
                .metricType(threshold.getMetricType().name())
                .warningThreshold(threshold.getWarningThreshold())
                .failureThreshold(threshold.getFailureThreshold())
                .direction(threshold.getDirection().name())
                .required(threshold.isRequired())
                .build();
    }

    private LoadTestThreshold toThresholdDomain(String metricTypeStr, LoadTestThresholdEmbedded doc) {
        if (doc == null) return null;

        MetricType metricType = MetricType.valueOf(metricTypeStr);
        LoadTestThreshold.ThresholdDirection direction = doc.getDirection() != null ?
                LoadTestThreshold.ThresholdDirection.valueOf(doc.getDirection()) :
                LoadTestThreshold.ThresholdDirection.MAX;

        if (doc.isRequired()) {
            return direction == LoadTestThreshold.ThresholdDirection.MAX ?
                    LoadTestThreshold.maxThreshold(metricType, doc.getWarningThreshold(), doc.getFailureThreshold()) :
                    LoadTestThreshold.minThreshold(metricType, doc.getWarningThreshold(), doc.getFailureThreshold());
        } else {
            return LoadTestThreshold.optional(metricType, doc.getWarningThreshold(),
                    doc.getFailureThreshold(), direction);
        }
    }

    // ==================== Metric Mapping ====================

    private List<LoadTestMetricEmbedded> toMetricEmbeddedList(List<LoadTestMetric> metrics) {
        if (metrics == null) return null;

        return metrics.stream()
                .map(m -> LoadTestMetricEmbedded.builder()
                        .type(m.getType().name())
                        .value(m.getValue())
                        .minValue(m.getMinValue())
                        .maxValue(m.getMaxValue())
                        .timestamp(m.getTimestamp())
                        .label(m.getLabel())
                        .build())
                .collect(Collectors.toList());
    }

    private List<LoadTestMetric> toMetricDomainList(List<LoadTestMetricEmbedded> docs) {
        if (docs == null) return new ArrayList<>();

        return docs.stream()
                .map(doc -> LoadTestMetric.create(
                        MetricType.valueOf(doc.getType()),
                        doc.getValue(),
                        doc.getMinValue(),
                        doc.getMaxValue(),
                        doc.getTimestamp(),
                        doc.getLabel()))
                .collect(Collectors.toList());
    }

    private Map<String, String> toThresholdResultsMap(Map<MetricType, LoadTestThreshold.ThresholdResult> results) {
        if (results == null) return null;

        Map<String, String> map = new HashMap<>();
        for (Map.Entry<MetricType, LoadTestThreshold.ThresholdResult> entry : results.entrySet()) {
            map.put(entry.getKey().name(), entry.getValue().name());
        }
        return map;
    }

    private Map<MetricType, LoadTestThreshold.ThresholdResult> toThresholdResultsDomain(Map<String, String> map) {
        if (map == null) return new HashMap<>();

        Map<MetricType, LoadTestThreshold.ThresholdResult> results = new HashMap<>();
        for (Map.Entry<String, String> entry : map.entrySet()) {
            results.put(MetricType.valueOf(entry.getKey()),
                    LoadTestThreshold.ThresholdResult.valueOf(entry.getValue()));
        }
        return results;
    }
}

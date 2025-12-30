package com.ffl.playoffs.infrastructure.persistence.mongodb.repository;

import com.ffl.playoffs.infrastructure.persistence.mongodb.document.PerformanceAlertDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Spring Data MongoDB repository for PerformanceAlertDocument.
 */
@Repository
public interface MongoPerformanceAlertRepository extends MongoRepository<PerformanceAlertDocument, String> {

    List<PerformanceAlertDocument> findByStatus(String status);

    List<PerformanceAlertDocument> findByEnabledTrue();

    List<PerformanceAlertDocument> findByCreatedBy(String createdBy);

    List<PerformanceAlertDocument> findByStatusIn(List<String> statuses);

    long countByStatusIn(List<String> statuses);

    List<PerformanceAlertDocument> findByThreshold_Severity(String severity);

    List<PerformanceAlertDocument> findByThreshold_MetricType(String metricType);
}

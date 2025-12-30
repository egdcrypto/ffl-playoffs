package com.ffl.playoffs.domain.model.performance;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Types of performance metrics that can be monitored.
 */
@Getter
@RequiredArgsConstructor
public enum MetricType {
    // System health metrics
    OVERALL_HEALTH_SCORE("overall_health_score", "Overall Health Score", MetricCategory.HEALTH),
    ACTIVE_USERS("active_users", "Active Users", MetricCategory.HEALTH),
    REQUESTS_PER_SECOND("requests_per_second", "Requests Per Second", MetricCategory.THROUGHPUT),

    // Response time metrics
    AVERAGE_RESPONSE_TIME("average_response_time", "Average Response Time", MetricCategory.LATENCY),
    P50_RESPONSE_TIME("p50_response_time", "P50 Response Time", MetricCategory.LATENCY),
    P90_RESPONSE_TIME("p90_response_time", "P90 Response Time", MetricCategory.LATENCY),
    P95_RESPONSE_TIME("p95_response_time", "P95 Response Time", MetricCategory.LATENCY),
    P99_RESPONSE_TIME("p99_response_time", "P99 Response Time", MetricCategory.LATENCY),

    // Error metrics
    ERROR_RATE("error_rate", "Error Rate", MetricCategory.ERROR),
    ERROR_4XX_RATE("error_4xx_rate", "4XX Error Rate", MetricCategory.ERROR),
    ERROR_5XX_RATE("error_5xx_rate", "5XX Error Rate", MetricCategory.ERROR),

    // Infrastructure metrics
    CPU_UTILIZATION("cpu_utilization", "CPU Utilization", MetricCategory.INFRASTRUCTURE),
    MEMORY_UTILIZATION("memory_utilization", "Memory Utilization", MetricCategory.INFRASTRUCTURE),
    DISK_IO("disk_io", "Disk I/O", MetricCategory.INFRASTRUCTURE),
    DISK_SPACE("disk_space", "Disk Space", MetricCategory.INFRASTRUCTURE),
    NETWORK_IO("network_io", "Network I/O", MetricCategory.INFRASTRUCTURE),

    // Database metrics
    QUERY_THROUGHPUT("query_throughput", "Query Throughput", MetricCategory.DATABASE),
    QUERY_LATENCY("query_latency", "Query Latency", MetricCategory.DATABASE),
    CONNECTION_POOL_USAGE("connection_pool_usage", "Connection Pool Usage", MetricCategory.DATABASE),
    CACHE_HIT_RATIO("cache_hit_ratio", "Cache Hit Ratio", MetricCategory.DATABASE),

    // Frontend metrics (Core Web Vitals)
    LCP("lcp", "Largest Contentful Paint", MetricCategory.FRONTEND),
    FID("fid", "First Input Delay", MetricCategory.FRONTEND),
    CLS("cls", "Cumulative Layout Shift", MetricCategory.FRONTEND),
    TTFB("ttfb", "Time to First Byte", MetricCategory.FRONTEND),
    FCP("fcp", "First Contentful Paint", MetricCategory.FRONTEND),

    // Availability metrics
    UPTIME("uptime", "Uptime Percentage", MetricCategory.AVAILABILITY),
    AVAILABILITY("availability", "Service Availability", MetricCategory.AVAILABILITY);

    private final String code;
    private final String displayName;
    private final MetricCategory category;

    public enum MetricCategory {
        HEALTH,
        THROUGHPUT,
        LATENCY,
        ERROR,
        INFRASTRUCTURE,
        DATABASE,
        FRONTEND,
        AVAILABILITY
    }

    public static MetricType fromCode(String code) {
        for (MetricType type : values()) {
            if (type.code.equals(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown metric type code: " + code);
    }
}

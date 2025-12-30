package com.ffl.playoffs.domain.model.loadtest;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Types of metrics collected during load testing.
 */
@Getter
@RequiredArgsConstructor
public enum MetricType {
    RESPONSE_TIME_AVG("response_time_avg", "Average Response Time", "ms"),
    RESPONSE_TIME_P50("response_time_p50", "Median Response Time", "ms"),
    RESPONSE_TIME_P90("response_time_p90", "90th Percentile Response Time", "ms"),
    RESPONSE_TIME_P95("response_time_p95", "95th Percentile Response Time", "ms"),
    RESPONSE_TIME_P99("response_time_p99", "99th Percentile Response Time", "ms"),
    THROUGHPUT("throughput", "Throughput", "req/s"),
    ERROR_RATE("error_rate", "Error Rate", "%"),
    CONCURRENT_USERS("concurrent_users", "Concurrent Users", "users"),
    CPU_USAGE("cpu_usage", "CPU Usage", "%"),
    MEMORY_USAGE("memory_usage", "Memory Usage", "%"),
    NETWORK_IO("network_io", "Network I/O", "MB/s"),
    DB_CONNECTIONS("db_connections", "Database Connections", "connections"),
    CACHE_HIT_RATE("cache_hit_rate", "Cache Hit Rate", "%"),
    QUEUE_DEPTH("queue_depth", "Queue Depth", "items");

    private final String code;
    private final String displayName;
    private final String unit;
}

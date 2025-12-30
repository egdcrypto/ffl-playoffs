package com.ffl.playoffs.domain.model;

/**
 * Metric type enumeration
 * Defines the type of metric for time-series data collection
 */
public enum MetricType {
    /**
     * Counter - monotonically increasing value (e.g., total requests)
     */
    COUNTER,

    /**
     * Gauge - value that can go up or down (e.g., current temperature)
     */
    GAUGE,

    /**
     * Histogram - samples observations into configurable buckets (e.g., request duration)
     */
    HISTOGRAM,

    /**
     * Summary - similar to histogram but calculates quantiles on client side
     */
    SUMMARY
}

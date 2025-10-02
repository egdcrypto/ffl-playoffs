package com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration for SportsData.io Fantasy Sports API
 * Maps properties from application.yml
 */
@Configuration
@ConfigurationProperties(prefix = "nfl-data.sportsdata")
@Getter
@Setter
public class SportsDataIoConfig {

    /**
     * SportsData.io API key (from environment variable)
     */
    private String apiKey;

    /**
     * Base URL for Fantasy Sports API
     */
    private String baseUrl = "https://api.sportsdata.io/v3/nfl/fantasy";

    /**
     * Connection timeout in milliseconds
     */
    private int connectionTimeout = 5000;

    /**
     * Read timeout in milliseconds
     */
    private int readTimeout = 10000;

    /**
     * Enable/disable live polling during games
     */
    private boolean livePollingEnabled = true;

    /**
     * Live stats polling interval (seconds) - default 30 seconds
     */
    private int livePollingIntervalSeconds = 30;

    /**
     * Maximum retries for failed requests
     */
    private int maxRetries = 3;
}

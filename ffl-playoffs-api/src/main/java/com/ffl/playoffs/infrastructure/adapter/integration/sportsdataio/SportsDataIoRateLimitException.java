package com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio;

/**
 * Exception thrown when SportsData.io API rate limit is exceeded (HTTP 429)
 */
public class SportsDataIoRateLimitException extends RuntimeException {

    public SportsDataIoRateLimitException(String message) {
        super(message);
    }

    public SportsDataIoRateLimitException(String message, Throwable cause) {
        super(message, cause);
    }
}

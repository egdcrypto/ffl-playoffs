package com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio;

/**
 * Exception thrown when SportsData.io API calls fail
 */
public class SportsDataIoApiException extends RuntimeException {

    public SportsDataIoApiException(String message) {
        super(message);
    }

    public SportsDataIoApiException(String message, Throwable cause) {
        super(message, cause);
    }
}

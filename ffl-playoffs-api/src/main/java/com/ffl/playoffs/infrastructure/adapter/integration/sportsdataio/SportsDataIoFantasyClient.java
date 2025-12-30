package com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio;

import com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.dto.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * HTTP Client for SportsData.io Fantasy Sports API
 * Base URL: https://api.sportsdata.io/v3/nfl/fantasy
 *
 * Provides methods to fetch:
 * - Player profiles with pre-calculated fantasy points
 * - Real-time fantasy stats (30-second updates during games)
 * - Player news and injury updates
 * - Game schedules and scores
 *
 * Infrastructure layer component - no business logic
 */
@Component
@Slf4j
public class SportsDataIoFantasyClient {

    private final RestTemplate restTemplate;
    private final SportsDataIoConfig config;

    public SportsDataIoFantasyClient(RestTemplate restTemplate, SportsDataIoConfig config) {
        this.restTemplate = restTemplate;
        this.config = config;
    }

    /**
     * Get player profile with season fantasy points
     * Endpoint: GET /v3/nfl/fantasy/json/Player/{playerID}
     *
     * @param playerId SportsData.io player ID
     * @return Player profile with fantasy points (PPR, Standard, Half-PPR)
     */
    public SportsDataIoPlayerResponse getPlayer(Long playerId) {
        String url = buildUrl(String.format("/json/Player/%d", playerId));

        try {
            log.debug("Fetching player profile for ID: {}", playerId);
            return restTemplate.getForObject(url, SportsDataIoPlayerResponse.class);
        } catch (HttpClientErrorException e) {
            if (e.getStatusCode() == HttpStatus.NOT_FOUND) {
                log.warn("Player not found: {}", playerId);
                return null;
            }
            if (e.getStatusCode() == HttpStatus.TOO_MANY_REQUESTS) {
                log.error("Rate limit exceeded for player request: {}", playerId);
                throw new SportsDataIoRateLimitException("Rate limit exceeded", e);
            }
            log.error("Client error fetching player {}: {}", playerId, e.getMessage());
            throw new SportsDataIoApiException("Failed to fetch player: " + playerId, e);
        } catch (HttpServerErrorException e) {
            log.error("Server error fetching player {}: {}", playerId, e.getMessage());
            throw new SportsDataIoApiException("SportsData.io server error", e);
        } catch (Exception e) {
            log.error("Unexpected error fetching player {}: {}", playerId, e.getMessage());
            throw new SportsDataIoApiException("Unexpected error fetching player", e);
        }
    }

    /**
     * Get real-time fantasy stats for a specific week
     * Endpoint: GET /v3/nfl/fantasy/json/FantasyPlayerGameStatsByWeek/{season}/{week}
     * Updates every 30 seconds during active games
     *
     * @param season NFL season year (e.g., 2025)
     * @param week NFL week number (1-22, includes playoffs)
     * @return List of all player stats for the week with live fantasy points
     */
    public List<SportsDataIoFantasyStatsResponse> getLiveFantasyStats(Integer season, Integer week) {
        String url = buildUrl(String.format("/json/FantasyPlayerGameStatsByWeek/%d/%d", season, week));

        try {
            log.debug("Fetching live fantasy stats for season {} week {}", season, week);
            SportsDataIoFantasyStatsResponse[] response = restTemplate.getForObject(url, SportsDataIoFantasyStatsResponse[].class);
            return response != null ? Arrays.asList(response) : Collections.emptyList();
        } catch (HttpClientErrorException e) {
            if (e.getStatusCode() == HttpStatus.TOO_MANY_REQUESTS) {
                log.error("Rate limit exceeded for fantasy stats request: season {} week {}", season, week);
                throw new SportsDataIoRateLimitException("Rate limit exceeded", e);
            }
            log.error("Client error fetching fantasy stats season {} week {}: {}", season, week, e.getMessage());
            throw new SportsDataIoApiException("Failed to fetch fantasy stats", e);
        } catch (HttpServerErrorException e) {
            log.error("Server error fetching fantasy stats season {} week {}: {}", season, week, e.getMessage());
            throw new SportsDataIoApiException("SportsData.io server error", e);
        } catch (Exception e) {
            log.error("Unexpected error fetching fantasy stats season {} week {}: {}", season, week, e.getMessage());
            throw new SportsDataIoApiException("Unexpected error fetching fantasy stats", e);
        }
    }

    /**
     * Get real-time player news and injury updates
     * Endpoint: GET /v3/nfl/fantasy/json/PlayerNews
     * Includes injury status changes, depth chart updates, etc.
     *
     * @return List of recent player news items with injury information
     */
    public List<SportsDataIoPlayerNewsResponse> getPlayerNews() {
        String url = buildUrl("/json/PlayerNews");

        try {
            log.debug("Fetching player news and injuries");
            SportsDataIoPlayerNewsResponse[] response = restTemplate.getForObject(url, SportsDataIoPlayerNewsResponse[].class);
            return response != null ? Arrays.asList(response) : Collections.emptyList();
        } catch (HttpClientErrorException e) {
            if (e.getStatusCode() == HttpStatus.TOO_MANY_REQUESTS) {
                log.error("Rate limit exceeded for player news request");
                throw new SportsDataIoRateLimitException("Rate limit exceeded", e);
            }
            log.error("Client error fetching player news: {}", e.getMessage());
            throw new SportsDataIoApiException("Failed to fetch player news", e);
        } catch (HttpServerErrorException e) {
            log.error("Server error fetching player news: {}", e.getMessage());
            throw new SportsDataIoApiException("SportsData.io server error", e);
        } catch (Exception e) {
            log.error("Unexpected error fetching player news: {}", e.getMessage());
            throw new SportsDataIoApiException("Unexpected error fetching player news", e);
        }
    }

    /**
     * Get all players for a specific team
     * Endpoint: GET /v3/nfl/stats/json/Players/{team}
     *
     * @param teamAbbreviation NFL team abbreviation (e.g., "KC", "SF")
     * @return List of players on the team
     */
    public List<SportsDataIoPlayerResponse> getPlayersByTeam(String teamAbbreviation) {
        String url = buildStatsUrl(String.format("/json/Players/%s", teamAbbreviation));

        try {
            log.debug("Fetching players for team: {}", teamAbbreviation);
            SportsDataIoPlayerResponse[] response = restTemplate.getForObject(url, SportsDataIoPlayerResponse[].class);
            return response != null ? Arrays.asList(response) : Collections.emptyList();
        } catch (HttpClientErrorException e) {
            if (e.getStatusCode() == HttpStatus.NOT_FOUND) {
                log.warn("Team not found: {}", teamAbbreviation);
                return Collections.emptyList();
            }
            if (e.getStatusCode() == HttpStatus.TOO_MANY_REQUESTS) {
                log.error("Rate limit exceeded for team players request: {}", teamAbbreviation);
                throw new SportsDataIoRateLimitException("Rate limit exceeded", e);
            }
            log.error("Client error fetching team players {}: {}", teamAbbreviation, e.getMessage());
            throw new SportsDataIoApiException("Failed to fetch team players: " + teamAbbreviation, e);
        } catch (HttpServerErrorException e) {
            log.error("Server error fetching team players {}: {}", teamAbbreviation, e.getMessage());
            throw new SportsDataIoApiException("SportsData.io server error", e);
        } catch (Exception e) {
            log.error("Unexpected error fetching team players {}: {}", teamAbbreviation, e.getMessage());
            throw new SportsDataIoApiException("Unexpected error fetching team players", e);
        }
    }

    /**
     * Get all available (active) players
     * Endpoint: GET /v3/nfl/stats/json/Players
     *
     * @return List of all available players
     */
    public List<SportsDataIoPlayerResponse> getAllPlayers() {
        String url = buildStatsUrl("/json/Players");

        try {
            log.debug("Fetching all available players");
            SportsDataIoPlayerResponse[] response = restTemplate.getForObject(url, SportsDataIoPlayerResponse[].class);
            return response != null ? Arrays.asList(response) : Collections.emptyList();
        } catch (HttpClientErrorException e) {
            if (e.getStatusCode() == HttpStatus.TOO_MANY_REQUESTS) {
                log.error("Rate limit exceeded for all players request");
                throw new SportsDataIoRateLimitException("Rate limit exceeded", e);
            }
            log.error("Client error fetching all players: {}", e.getMessage());
            throw new SportsDataIoApiException("Failed to fetch all players", e);
        } catch (HttpServerErrorException e) {
            log.error("Server error fetching all players: {}", e.getMessage());
            throw new SportsDataIoApiException("SportsData.io server error", e);
        } catch (Exception e) {
            log.error("Unexpected error fetching all players: {}", e.getMessage());
            throw new SportsDataIoApiException("Unexpected error fetching all players", e);
        }
    }

    /**
     * Get free agent players
     * Endpoint: GET /v3/nfl/stats/json/FreeAgents
     *
     * @return List of free agent players
     */
    public List<SportsDataIoPlayerResponse> getFreeAgents() {
        String url = buildStatsUrl("/json/FreeAgents");

        try {
            log.debug("Fetching free agent players");
            SportsDataIoPlayerResponse[] response = restTemplate.getForObject(url, SportsDataIoPlayerResponse[].class);
            return response != null ? Arrays.asList(response) : Collections.emptyList();
        } catch (HttpClientErrorException e) {
            if (e.getStatusCode() == HttpStatus.TOO_MANY_REQUESTS) {
                log.error("Rate limit exceeded for free agents request");
                throw new SportsDataIoRateLimitException("Rate limit exceeded", e);
            }
            log.error("Client error fetching free agents: {}", e.getMessage());
            throw new SportsDataIoApiException("Failed to fetch free agents", e);
        } catch (HttpServerErrorException e) {
            log.error("Server error fetching free agents: {}", e.getMessage());
            throw new SportsDataIoApiException("SportsData.io server error", e);
        } catch (Exception e) {
            log.error("Unexpected error fetching free agents: {}", e.getMessage());
            throw new SportsDataIoApiException("Unexpected error fetching free agents", e);
        }
    }

    /**
     * Build full API URL for Stats API with base URL and API key
     * Uses /v3/nfl/stats instead of /v3/nfl/fantasy
     *
     * @param endpoint API endpoint path
     * @return Full URL with API key parameter
     */
    private String buildStatsUrl(String endpoint) {
        String statsBaseUrl = config.getBaseUrl().replace("/fantasy", "/stats");
        return String.format("%s%s?key=%s", statsBaseUrl, endpoint, config.getApiKey());
    }

    /**
     * Get specific player's stats for a week
     * Filters getLiveFantasyStats by playerID
     *
     * @param playerId SportsData.io player ID
     * @param season NFL season year
     * @param week NFL week number
     * @return Player's stats for the specific week, or null if not found
     */
    public SportsDataIoFantasyStatsResponse getPlayerWeeklyStats(Long playerId, Integer season, Integer week) {
        try {
            List<SportsDataIoFantasyStatsResponse> allStats = getLiveFantasyStats(season, week);
            return allStats.stream()
                    .filter(stats -> stats.getPlayerID().equals(playerId))
                    .findFirst()
                    .orElse(null);
        } catch (Exception e) {
            log.error("Error fetching player weekly stats for player {} season {} week {}: {}",
                    playerId, season, week, e.getMessage());
            throw new SportsDataIoApiException("Failed to fetch player weekly stats", e);
        }
    }

    /**
     * Get player news for specific player
     * Filters getPlayerNews by playerID
     *
     * @param playerId SportsData.io player ID
     * @return List of news items for the player
     */
    public List<SportsDataIoPlayerNewsResponse> getPlayerNewsById(Long playerId) {
        try {
            List<SportsDataIoPlayerNewsResponse> allNews = getPlayerNews();
            return allNews.stream()
                    .filter(news -> news.getPlayerID().equals(playerId))
                    .toList();
        } catch (Exception e) {
            log.error("Error fetching player news for player {}: {}", playerId, e.getMessage());
            throw new SportsDataIoApiException("Failed to fetch player news", e);
        }
    }

    /**
     * Build full API URL with base URL and API key
     *
     * @param endpoint API endpoint path (e.g., "/json/Player/12345")
     * @return Full URL with API key parameter
     */
    private String buildUrl(String endpoint) {
        return String.format("%s%s?key=%s", config.getBaseUrl(), endpoint, config.getApiKey());
    }

    /**
     * Check if API is accessible (health check)
     *
     * @return true if API responds successfully
     */
    public boolean isApiAccessible() {
        try {
            // Simple health check - try to fetch player news
            getPlayerNews();
            return true;
        } catch (Exception e) {
            log.error("API health check failed: {}", e.getMessage());
            return false;
        }
    }
}

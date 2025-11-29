package com.ffl.playoffs.application.service;

import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.nfl.NFLGameDTO;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.NFLGameDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoNFLGameRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Service for NFL Game operations
 * Provides business logic for accessing NFL game data from MongoDB
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class NFLGameService {

    private final MongoNFLGameRepository gameRepository;

    /**
     * Get all NFL games with pagination
     * @param page the page number (0-indexed)
     * @param size the page size
     * @return paginated list of games
     */
    public Page<NFLGameDTO> getAllGames(int page, int size) {
        log.debug("Getting all games, page: {}, size: {}", page, size);
        Pageable pageable = PageRequest.of(page, size, Sort.by("season").descending().and(Sort.by("week").descending()).and(Sort.by("gameTime").ascending()));
        org.springframework.data.domain.Page<NFLGameDocument> result = gameRepository.findAll(pageable);

        List<NFLGameDTO> games = result.getContent().stream()
                .map(NFLGameDTO::fromDocument)
                .collect(Collectors.toList());

        return new Page<>(
                games,
                result.getNumber(),
                result.getSize(),
                result.getTotalElements()
        );
    }

    /**
     * Get games with optional season and week filters
     * @param season the season year (optional)
     * @param week the week number (optional)
     * @param page the page number
     * @param size the page size
     * @return paginated list of games
     */
    public Page<NFLGameDTO> getGames(Integer season, Integer week, int page, int size) {
        log.debug("Getting games - season: {}, week: {}, page: {}, size: {}", season, week, page, size);

        if (season != null && week != null) {
            // Return games for specific week
            List<NFLGameDocument> games = gameRepository.findBySeasonAndWeek(season, week);
            List<NFLGameDTO> gameDTOs = games.stream()
                    .map(NFLGameDTO::fromDocument)
                    .collect(Collectors.toList());

            // Apply pagination manually
            int fromIndex = page * size;
            int toIndex = Math.min(fromIndex + size, gameDTOs.size());
            List<NFLGameDTO> pagedGames = fromIndex < gameDTOs.size()
                    ? gameDTOs.subList(fromIndex, toIndex)
                    : List.of();

            return new Page<>(
                    pagedGames,
                    page,
                    size,
                    (long) gameDTOs.size()
            );
        } else if (season != null) {
            // Return games for specific season
            Pageable pageable = PageRequest.of(page, size, Sort.by("week").ascending().and(Sort.by("gameTime").ascending()));
            org.springframework.data.domain.Page<NFLGameDocument> result = gameRepository.findBySeason(season, pageable);

            List<NFLGameDTO> games = result.getContent().stream()
                    .map(NFLGameDTO::fromDocument)
                    .collect(Collectors.toList());

            return new Page<>(
                    games,
                    result.getNumber(),
                    result.getSize(),
                    result.getTotalElements()
            );
        }

        return getAllGames(page, size);
    }

    /**
     * Get a specific game by ID
     * @param gameId the game ID
     * @return Optional containing the game if found
     */
    public Optional<NFLGameDTO> getGameById(String gameId) {
        log.debug("Getting game by ID: {}", gameId);
        return gameRepository.findByGameId(gameId)
                .map(NFLGameDTO::fromDocument);
    }

    /**
     * Get games for a specific week
     * @param season the season year
     * @param week the week number
     * @return list of games for that week
     */
    public List<NFLGameDTO> getGamesByWeek(int season, int week) {
        log.debug("Getting games for season {} week {}", season, week);
        return gameRepository.findBySeasonAndWeek(season, week).stream()
                .map(NFLGameDTO::fromDocument)
                .collect(Collectors.toList());
    }

    /**
     * Get currently active games
     * @return list of active games
     */
    public List<NFLGameDTO> getActiveGames() {
        log.debug("Getting active games");
        return gameRepository.findActiveGames().stream()
                .map(NFLGameDTO::fromDocument)
                .collect(Collectors.toList());
    }

    /**
     * Get games by status
     * @param status the game status
     * @return list of games with that status
     */
    public List<NFLGameDTO> getGamesByStatus(String status) {
        log.debug("Getting games by status: {}", status);
        return gameRepository.findByStatus(status.toUpperCase()).stream()
                .map(NFLGameDTO::fromDocument)
                .collect(Collectors.toList());
    }

    /**
     * Get games involving a specific team
     * @param team the team abbreviation
     * @param season the season year
     * @return list of games involving that team
     */
    public List<NFLGameDTO> getGamesByTeam(String team, int season) {
        log.debug("Getting games for team {} in season {}", team, season);
        return gameRepository.findByTeamAndSeason(team.toUpperCase(), season).stream()
                .map(NFLGameDTO::fromDocument)
                .collect(Collectors.toList());
    }

    /**
     * Get total count of games
     * @return total number of games
     */
    public long getTotalGameCount() {
        return gameRepository.count();
    }

    /**
     * Get count of games in a season
     * @param season the season year
     * @return number of games in that season
     */
    public long getGameCountBySeason(int season) {
        return gameRepository.countBySeason(season);
    }

    /**
     * Get count of games in a specific week
     * @param season the season year
     * @param week the week number
     * @return number of games for that week
     */
    public long getGameCountByWeek(int season, int week) {
        return gameRepository.countBySeasonAndWeek(season, week);
    }

    /**
     * Check if a game exists
     * @param gameId the game ID
     * @return true if the game exists
     */
    public boolean gameExists(String gameId) {
        return gameRepository.existsByGameId(gameId);
    }
}

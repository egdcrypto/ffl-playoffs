package com.ffl.playoffs.application.service;

import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.nfl.PlayerStatsDTO;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.PlayerStatsDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoPlayerStatsRepository;
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
 * Service for Player Statistics operations
 * Provides business logic for accessing player stats from MongoDB
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class PlayerStatsService {

    private final MongoPlayerStatsRepository statsRepository;

    /**
     * Get all stats for a specific week
     * @param season the season year
     * @param week the week number
     * @param page the page number
     * @param size the page size
     * @return paginated list of player stats
     */
    public Page<PlayerStatsDTO> getStatsByWeek(int season, int week, int page, int size) {
        log.debug("Getting stats for season {} week {}, page: {}, size: {}", season, week, page, size);
        Pageable pageable = PageRequest.of(page, size, Sort.by("playerName").ascending());
        org.springframework.data.domain.Page<PlayerStatsDocument> result = statsRepository.findBySeasonAndWeek(season, week, pageable);

        List<PlayerStatsDTO> stats = result.getContent().stream()
                .map(PlayerStatsDTO::fromDocument)
                .collect(Collectors.toList());

        return new Page<>(
                stats,
                result.getNumber(),
                result.getSize(),
                result.getTotalElements()
        );
    }

    /**
     * Get all stats for a specific week (non-paginated)
     * @param season the season year
     * @param week the week number
     * @return list of all player stats for that week
     */
    public List<PlayerStatsDTO> getAllStatsByWeek(int season, int week) {
        log.debug("Getting all stats for season {} week {}", season, week);
        return statsRepository.findBySeasonAndWeek(season, week).stream()
                .map(PlayerStatsDTO::fromDocument)
                .collect(Collectors.toList());
    }

    /**
     * Get stats for a specific player
     * @param playerId the player ID
     * @param page the page number
     * @param size the page size
     * @return paginated list of stats for the player
     */
    public Page<PlayerStatsDTO> getStatsByPlayer(String playerId, int page, int size) {
        log.debug("Getting stats for player {}, page: {}, size: {}", playerId, page, size);
        Pageable pageable = PageRequest.of(page, size, Sort.by("season").descending().and(Sort.by("week").descending()));
        org.springframework.data.domain.Page<PlayerStatsDocument> result = statsRepository.findByPlayerId(playerId, pageable);

        List<PlayerStatsDTO> stats = result.getContent().stream()
                .map(PlayerStatsDTO::fromDocument)
                .collect(Collectors.toList());

        return new Page<>(
                stats,
                result.getNumber(),
                result.getSize(),
                result.getTotalElements()
        );
    }

    /**
     * Get all stats for a specific player
     * @param playerId the player ID
     * @return list of all stats for the player
     */
    public List<PlayerStatsDTO> getAllStatsByPlayer(String playerId) {
        log.debug("Getting all stats for player {}", playerId);
        return statsRepository.findByPlayerId(playerId).stream()
                .map(PlayerStatsDTO::fromDocument)
                .collect(Collectors.toList());
    }

    /**
     * Get stats for a player in a specific season
     * @param playerId the player ID
     * @param season the season year
     * @return list of weekly stats for the player in that season
     */
    public List<PlayerStatsDTO> getStatsByPlayerAndSeason(String playerId, int season) {
        log.debug("Getting stats for player {} in season {}", playerId, season);
        return statsRepository.findByPlayerIdAndSeason(playerId, season).stream()
                .map(PlayerStatsDTO::fromDocument)
                .collect(Collectors.toList());
    }

    /**
     * Get stats for a player in a specific week
     * @param playerId the player ID
     * @param season the season year
     * @param week the week number
     * @return Optional containing the stats if found
     */
    public Optional<PlayerStatsDTO> getStatsByPlayerAndWeek(String playerId, int season, int week) {
        log.debug("Getting stats for player {} in season {} week {}", playerId, season, week);
        return statsRepository.findByPlayerIdAndSeasonAndWeek(playerId, season, week)
                .map(PlayerStatsDTO::fromDocument);
    }

    /**
     * Get stats for players at a specific position in a week
     * @param position the position
     * @param season the season year
     * @param week the week number
     * @return list of stats for players at that position
     */
    public List<PlayerStatsDTO> getStatsByPosition(String position, int season, int week) {
        log.debug("Getting stats for position {} in season {} week {}", position, season, week);
        return statsRepository.findByPositionAndSeasonAndWeek(position.toUpperCase(), season, week).stream()
                .map(PlayerStatsDTO::fromDocument)
                .collect(Collectors.toList());
    }

    /**
     * Get stats for a team in a specific week
     * @param team the team abbreviation
     * @param season the season year
     * @param week the week number
     * @return list of stats for players on that team
     */
    public List<PlayerStatsDTO> getStatsByTeam(String team, int season, int week) {
        log.debug("Getting stats for team {} in season {} week {}", team, season, week);
        return statsRepository.findByTeamAndSeasonAndWeek(team.toUpperCase(), season, week).stream()
                .map(PlayerStatsDTO::fromDocument)
                .collect(Collectors.toList());
    }

    /**
     * Get top scorers for a week
     * @param season the season year
     * @param week the week number
     * @param limit the number of top scorers to return
     * @return list of top scorers
     */
    public List<PlayerStatsDTO> getTopScorersByWeek(int season, int week, int limit) {
        log.debug("Getting top {} scorers for season {} week {}", limit, season, week);
        Pageable pageable = PageRequest.of(0, limit);
        return statsRepository.findTopScorersByWeek(season, week, pageable).getContent().stream()
                .map(PlayerStatsDTO::fromDocument)
                .collect(Collectors.toList());
    }

    /**
     * Get count of stats for a season
     * @param season the season year
     * @return number of stat records for that season
     */
    public long getStatsCountBySeason(int season) {
        return statsRepository.countBySeason(season);
    }

    /**
     * Get count of stats for a specific week
     * @param season the season year
     * @param week the week number
     * @return number of stat records for that week
     */
    public long getStatsCountByWeek(int season, int week) {
        return statsRepository.countBySeasonAndWeek(season, week);
    }

    /**
     * Check if stats exist for a player in a week
     * @param playerId the player ID
     * @param season the season year
     * @param week the week number
     * @return true if stats exist
     */
    public boolean statsExist(String playerId, int season, int week) {
        return statsRepository.existsByPlayerIdAndSeasonAndWeek(playerId, season, week);
    }
}

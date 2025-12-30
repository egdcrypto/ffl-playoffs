package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.nfl.NFLPlayerDTO;
import com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.SportsDataIoFantasyClient;
import com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.SportsDataIoMapper;
import com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.dto.SportsDataIoPlayerResponse;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.NFLPlayerDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoNFLPlayerRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Use case for retrieving NFL players by team.
 * First checks MongoDB cache, can optionally sync from SportsData.io API.
 * Groups players by position for roster building UI.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class GetNFLPlayersByTeamUseCase {

    private static final int DEFAULT_PAGE_SIZE = 100;

    private final MongoNFLPlayerRepository playerRepository;
    private final SportsDataIoFantasyClient sportsDataClient;
    private final SportsDataIoMapper mapper;

    /**
     * Get all players for a specific team from MongoDB
     *
     * @param teamAbbreviation NFL team abbreviation (e.g., "KC", "SF")
     * @param page page number (0-indexed)
     * @param size page size
     * @return paginated list of players on the team
     * @throws IllegalArgumentException if team abbreviation is invalid
     */
    public Page<NFLPlayerDTO> execute(String teamAbbreviation, int page, int size) {
        validateTeamAbbreviation(teamAbbreviation);

        log.debug("Getting players for team: {}", teamAbbreviation);

        Pageable pageable = PageRequest.of(page, size,
                Sort.by("position").ascending().and(Sort.by("name").ascending()));

        org.springframework.data.domain.Page<NFLPlayerDocument> result =
                playerRepository.findByTeam(teamAbbreviation.toUpperCase(), pageable);

        List<NFLPlayerDTO> players = result.getContent().stream()
                .map(NFLPlayerDTO::fromDocument)
                .collect(Collectors.toList());

        log.debug("Found {} players for team {}", players.size(), teamAbbreviation);

        return new Page<>(
                players,
                result.getNumber(),
                result.getSize(),
                result.getTotalElements()
        );
    }

    /**
     * Get all players for a team, grouped by position
     *
     * @param teamAbbreviation NFL team abbreviation
     * @return map of position to list of players
     */
    public Map<String, List<NFLPlayerDTO>> executeGroupedByPosition(String teamAbbreviation) {
        validateTeamAbbreviation(teamAbbreviation);

        log.debug("Getting players grouped by position for team: {}", teamAbbreviation);

        List<NFLPlayerDocument> allPlayers = playerRepository.findByTeam(teamAbbreviation.toUpperCase());

        Map<String, List<NFLPlayerDTO>> grouped = allPlayers.stream()
                .map(NFLPlayerDTO::fromDocument)
                .collect(Collectors.groupingBy(
                        player -> player.getPosition() != null ? player.getPosition() : "UNKNOWN"
                ));

        log.debug("Found {} positions with players for team {}", grouped.size(), teamAbbreviation);

        return grouped;
    }

    /**
     * Sync players for a team from SportsData.io API and store in MongoDB
     *
     * @param teamAbbreviation NFL team abbreviation
     * @return SyncResult with details of the sync operation
     */
    public SyncResult syncTeamPlayers(String teamAbbreviation) {
        validateTeamAbbreviation(teamAbbreviation);

        log.info("Syncing players for team: {}", teamAbbreviation);

        try {
            List<SportsDataIoPlayerResponse> apiPlayers = sportsDataClient.getPlayersByTeam(teamAbbreviation);

            if (apiPlayers.isEmpty()) {
                log.warn("No players found for team: {}", teamAbbreviation);
                return new SyncResult(teamAbbreviation, 0, 0, false, "Team not found or has no players");
            }

            int saved = 0;
            int errors = 0;

            for (SportsDataIoPlayerResponse apiPlayer : apiPlayers) {
                try {
                    NFLPlayerDocument document = mapper.toDocument(apiPlayer);
                    String playerId = String.valueOf(apiPlayer.getPlayerID());

                    // Check if exists and update, or create new
                    playerRepository.findByPlayerId(playerId).ifPresent(existing -> {
                        document.setId(existing.getId());
                        document.setCreatedAt(existing.getCreatedAt());
                    });

                    playerRepository.save(document);
                    saved++;
                } catch (Exception e) {
                    log.error("Error saving player {}: {}", apiPlayer.getPlayerID(), e.getMessage());
                    errors++;
                }
            }

            log.info("Synced {} players for team {} ({} errors)", saved, teamAbbreviation, errors);
            return new SyncResult(teamAbbreviation, apiPlayers.size(), saved, errors == 0, null);

        } catch (Exception e) {
            log.error("Error syncing team {}: {}", teamAbbreviation, e.getMessage());
            return new SyncResult(teamAbbreviation, 0, 0, false, e.getMessage());
        }
    }

    /**
     * Get player count by team
     *
     * @param teamAbbreviation NFL team abbreviation
     * @return number of players on the team in the database
     */
    public long getPlayerCount(String teamAbbreviation) {
        validateTeamAbbreviation(teamAbbreviation);
        return playerRepository.countByTeam(teamAbbreviation.toUpperCase());
    }

    private void validateTeamAbbreviation(String teamAbbreviation) {
        if (teamAbbreviation == null || teamAbbreviation.isBlank()) {
            throw new IllegalArgumentException("Team abbreviation cannot be null or empty");
        }
        if (teamAbbreviation.length() < 2 || teamAbbreviation.length() > 3) {
            throw new IllegalArgumentException("Invalid team abbreviation: " + teamAbbreviation);
        }
    }

    /**
     * Result of a sync operation
     */
    public static class SyncResult {
        private final String team;
        private final int totalPlayers;
        private final int savedPlayers;
        private final boolean success;
        private final String errorMessage;

        public SyncResult(String team, int totalPlayers, int savedPlayers, boolean success, String errorMessage) {
            this.team = team;
            this.totalPlayers = totalPlayers;
            this.savedPlayers = savedPlayers;
            this.success = success;
            this.errorMessage = errorMessage;
        }

        public String getTeam() {
            return team;
        }

        public int getTotalPlayers() {
            return totalPlayers;
        }

        public int getSavedPlayers() {
            return savedPlayers;
        }

        public boolean isSuccess() {
            return success;
        }

        public String getErrorMessage() {
            return errorMessage;
        }
    }
}

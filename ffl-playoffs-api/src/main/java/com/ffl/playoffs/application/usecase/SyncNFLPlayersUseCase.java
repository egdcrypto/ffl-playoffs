package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.SportsDataIoFantasyClient;
import com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.SportsDataIoMapper;
import com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.dto.SportsDataIoPlayerResponse;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.NFLPlayerDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoNFLPlayerRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Use case for synchronizing NFL player data from SportsData.io API to MongoDB.
 * Fetches all players and stores them for local querying and caching.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SyncNFLPlayersUseCase {

    private final MongoNFLPlayerRepository playerRepository;
    private final SportsDataIoFantasyClient sportsDataClient;
    private final SportsDataIoMapper mapper;

    /**
     * Sync all NFL players from SportsData.io API
     *
     * @return SyncResult with details of the sync operation
     */
    public SyncResult execute() {
        log.info("Starting full NFL player sync");
        LocalDateTime startTime = LocalDateTime.now();

        try {
            List<SportsDataIoPlayerResponse> apiPlayers = sportsDataClient.getAllPlayers();

            if (apiPlayers.isEmpty()) {
                log.warn("No players returned from API");
                return new SyncResult(0, 0, 0, startTime, LocalDateTime.now(), false, "No players returned from API");
            }

            log.info("Retrieved {} players from API", apiPlayers.size());

            int saved = 0;
            int updated = 0;
            int errors = 0;

            for (SportsDataIoPlayerResponse apiPlayer : apiPlayers) {
                try {
                    NFLPlayerDocument document = mapper.toDocument(apiPlayer);
                    String playerId = String.valueOf(apiPlayer.getPlayerID());

                    // Check if player exists
                    var existingDoc = playerRepository.findByPlayerId(playerId);
                    if (existingDoc.isPresent()) {
                        document.setId(existingDoc.get().getId());
                        document.setCreatedAt(existingDoc.get().getCreatedAt());
                        updated++;
                    } else {
                        saved++;
                    }

                    playerRepository.save(document);
                } catch (Exception e) {
                    log.error("Error saving player {}: {}", apiPlayer.getPlayerID(), e.getMessage());
                    errors++;
                }
            }

            LocalDateTime endTime = LocalDateTime.now();
            log.info("Player sync completed: {} new, {} updated, {} errors", saved, updated, errors);

            return new SyncResult(
                    apiPlayers.size(),
                    saved,
                    updated,
                    startTime,
                    endTime,
                    errors == 0,
                    errors > 0 ? errors + " players failed to save" : null
            );

        } catch (Exception e) {
            log.error("Error during player sync: {}", e.getMessage());
            return new SyncResult(0, 0, 0, startTime, LocalDateTime.now(), false, e.getMessage());
        }
    }

    /**
     * Sync free agent players from SportsData.io API
     *
     * @return SyncResult with details of the sync operation
     */
    public SyncResult syncFreeAgents() {
        log.info("Starting free agent sync");
        LocalDateTime startTime = LocalDateTime.now();

        try {
            List<SportsDataIoPlayerResponse> freeAgents = sportsDataClient.getFreeAgents();

            if (freeAgents.isEmpty()) {
                log.info("No free agents returned from API");
                return new SyncResult(0, 0, 0, startTime, LocalDateTime.now(), true, null);
            }

            log.info("Retrieved {} free agents from API", freeAgents.size());

            int saved = 0;
            int updated = 0;
            int errors = 0;

            for (SportsDataIoPlayerResponse apiPlayer : freeAgents) {
                try {
                    NFLPlayerDocument document = mapper.toDocument(apiPlayer);
                    String playerId = String.valueOf(apiPlayer.getPlayerID());

                    var existingDoc = playerRepository.findByPlayerId(playerId);
                    if (existingDoc.isPresent()) {
                        document.setId(existingDoc.get().getId());
                        document.setCreatedAt(existingDoc.get().getCreatedAt());
                        updated++;
                    } else {
                        saved++;
                    }

                    playerRepository.save(document);
                } catch (Exception e) {
                    log.error("Error saving free agent {}: {}", apiPlayer.getPlayerID(), e.getMessage());
                    errors++;
                }
            }

            LocalDateTime endTime = LocalDateTime.now();
            log.info("Free agent sync completed: {} new, {} updated, {} errors", saved, updated, errors);

            return new SyncResult(
                    freeAgents.size(),
                    saved,
                    updated,
                    startTime,
                    endTime,
                    errors == 0,
                    errors > 0 ? errors + " players failed to save" : null
            );

        } catch (Exception e) {
            log.error("Error during free agent sync: {}", e.getMessage());
            return new SyncResult(0, 0, 0, startTime, LocalDateTime.now(), false, e.getMessage());
        }
    }

    /**
     * Get current player count in database
     *
     * @return total number of players stored
     */
    public long getPlayerCount() {
        return playerRepository.count();
    }

    /**
     * Result of a sync operation
     */
    public static class SyncResult {
        private final int totalFromApi;
        private final int newPlayers;
        private final int updatedPlayers;
        private final LocalDateTime startTime;
        private final LocalDateTime endTime;
        private final boolean success;
        private final String errorMessage;

        public SyncResult(int totalFromApi, int newPlayers, int updatedPlayers,
                          LocalDateTime startTime, LocalDateTime endTime,
                          boolean success, String errorMessage) {
            this.totalFromApi = totalFromApi;
            this.newPlayers = newPlayers;
            this.updatedPlayers = updatedPlayers;
            this.startTime = startTime;
            this.endTime = endTime;
            this.success = success;
            this.errorMessage = errorMessage;
        }

        public int getTotalFromApi() {
            return totalFromApi;
        }

        public int getNewPlayers() {
            return newPlayers;
        }

        public int getUpdatedPlayers() {
            return updatedPlayers;
        }

        public LocalDateTime getStartTime() {
            return startTime;
        }

        public LocalDateTime getEndTime() {
            return endTime;
        }

        public boolean isSuccess() {
            return success;
        }

        public String getErrorMessage() {
            return errorMessage;
        }

        public long getDurationMillis() {
            if (startTime != null && endTime != null) {
                return java.time.Duration.between(startTime, endTime).toMillis();
            }
            return 0;
        }
    }
}

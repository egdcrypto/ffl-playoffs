package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.nfl.NFLPlayerDTO;
import com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.SportsDataIoFantasyClient;
import com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.SportsDataIoMapper;
import com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.dto.SportsDataIoPlayerResponse;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.NFLPlayerDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoNFLPlayerRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Optional;

/**
 * Use case for retrieving a single NFL player by ID.
 * First checks MongoDB cache, then fetches from SportsData.io API if not found.
 * Stores fetched player data in MongoDB for future queries.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class GetNFLPlayerByIdUseCase {

    private final MongoNFLPlayerRepository playerRepository;
    private final SportsDataIoFantasyClient sportsDataClient;
    private final SportsDataIoMapper mapper;

    /**
     * Get an NFL player by their player ID
     *
     * @param playerId the SportsData.io player ID
     * @return Optional containing the player if found
     * @throws IllegalArgumentException if playerId is null or invalid
     */
    public Optional<NFLPlayerDTO> execute(String playerId) {
        if (playerId == null || playerId.isBlank()) {
            log.warn("Invalid player ID provided: {}", playerId);
            throw new IllegalArgumentException("INVALID_PLAYER_ID: Player ID cannot be null or empty");
        }

        log.debug("Fetching player by ID: {}", playerId);

        // First, check MongoDB cache
        Optional<NFLPlayerDocument> cachedPlayer = playerRepository.findByPlayerId(playerId);
        if (cachedPlayer.isPresent()) {
            log.debug("Player {} found in cache", playerId);
            return Optional.of(NFLPlayerDTO.fromDocument(cachedPlayer.get()));
        }

        // If not in cache, fetch from SportsData.io API
        log.debug("Player {} not in cache, fetching from API", playerId);
        try {
            Long playerIdLong = Long.parseLong(playerId);
            SportsDataIoPlayerResponse apiResponse = sportsDataClient.getPlayer(playerIdLong);

            if (apiResponse == null) {
                log.info("Player not found: {}", playerId);
                return Optional.empty();
            }

            // Map to document and store in MongoDB
            NFLPlayerDocument document = mapper.toDocument(apiResponse);
            NFLPlayerDocument savedDocument = playerRepository.save(document);
            log.info("Player {} fetched from API and stored in database", playerId);

            return Optional.of(NFLPlayerDTO.fromDocument(savedDocument));
        } catch (NumberFormatException e) {
            log.warn("Invalid player ID format: {}", playerId);
            throw new IllegalArgumentException("INVALID_PLAYER_ID: Player ID must be a valid number");
        } catch (Exception e) {
            log.error("Error fetching player {}: {}", playerId, e.getMessage());
            throw new RuntimeException("Failed to fetch player: " + playerId, e);
        }
    }

    /**
     * Get an NFL player by ID, forcing a refresh from the API
     *
     * @param playerId the SportsData.io player ID
     * @return Optional containing the player if found
     */
    public Optional<NFLPlayerDTO> executeWithRefresh(String playerId) {
        if (playerId == null || playerId.isBlank()) {
            throw new IllegalArgumentException("INVALID_PLAYER_ID: Player ID cannot be null or empty");
        }

        log.debug("Fetching player {} with forced refresh", playerId);

        try {
            Long playerIdLong = Long.parseLong(playerId);
            SportsDataIoPlayerResponse apiResponse = sportsDataClient.getPlayer(playerIdLong);

            if (apiResponse == null) {
                log.info("Player not found: {}", playerId);
                return Optional.empty();
            }

            // Map to document
            NFLPlayerDocument document = mapper.toDocument(apiResponse);

            // Check if exists and update, or create new
            Optional<NFLPlayerDocument> existingDoc = playerRepository.findByPlayerId(playerId);
            if (existingDoc.isPresent()) {
                document.setId(existingDoc.get().getId());
                document.setCreatedAt(existingDoc.get().getCreatedAt());
            }

            NFLPlayerDocument savedDocument = playerRepository.save(document);
            log.info("Player {} refreshed from API", playerId);

            return Optional.of(NFLPlayerDTO.fromDocument(savedDocument));
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("INVALID_PLAYER_ID: Player ID must be a valid number");
        } catch (Exception e) {
            log.error("Error refreshing player {}: {}", playerId, e.getMessage());
            throw new RuntimeException("Failed to refresh player: " + playerId, e);
        }
    }
}

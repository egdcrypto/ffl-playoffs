package com.ffl.playoffs.application.service;

import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.nfl.NFLPlayerDTO;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.NFLPlayerDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoNFLPlayerRepository;
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
 * Service for NFL Player operations
 * Provides business logic for accessing NFL player data from MongoDB
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class NFLPlayerService {

    private final MongoNFLPlayerRepository playerRepository;

    /**
     * Get all NFL players with pagination
     * @param page the page number (0-indexed)
     * @param size the page size
     * @return paginated list of players
     */
    public Page<NFLPlayerDTO> getAllPlayers(int page, int size) {
        log.debug("Getting all players, page: {}, size: {}", page, size);
        Pageable pageable = PageRequest.of(page, size, Sort.by("name").ascending());
        org.springframework.data.domain.Page<NFLPlayerDocument> result = playerRepository.findAll(pageable);

        List<NFLPlayerDTO> players = result.getContent().stream()
                .map(NFLPlayerDTO::fromDocument)
                .collect(Collectors.toList());

        return new Page<>(
                players,
                result.getNumber(),
                result.getSize(),
                result.getTotalElements()
        );
    }

    /**
     * Get a specific player by ID
     * @param playerId the player ID
     * @return Optional containing the player if found
     */
    public Optional<NFLPlayerDTO> getPlayerById(String playerId) {
        log.debug("Getting player by ID: {}", playerId);
        return playerRepository.findByPlayerId(playerId)
                .map(NFLPlayerDTO::fromDocument);
    }

    /**
     * Get players by team
     * @param team the team abbreviation
     * @param page the page number
     * @param size the page size
     * @return paginated list of players on the team
     */
    public Page<NFLPlayerDTO> getPlayersByTeam(String team, int page, int size) {
        log.debug("Getting players by team: {}, page: {}, size: {}", team, page, size);
        Pageable pageable = PageRequest.of(page, size, Sort.by("position").ascending().and(Sort.by("name").ascending()));
        org.springframework.data.domain.Page<NFLPlayerDocument> result = playerRepository.findByTeam(team.toUpperCase(), pageable);

        List<NFLPlayerDTO> players = result.getContent().stream()
                .map(NFLPlayerDTO::fromDocument)
                .collect(Collectors.toList());

        return new Page<>(
                players,
                result.getNumber(),
                result.getSize(),
                result.getTotalElements()
        );
    }

    /**
     * Get players by position
     * @param position the position
     * @param page the page number
     * @param size the page size
     * @return paginated list of players at that position
     */
    public Page<NFLPlayerDTO> getPlayersByPosition(String position, int page, int size) {
        log.debug("Getting players by position: {}, page: {}, size: {}", position, page, size);
        Pageable pageable = PageRequest.of(page, size, Sort.by("name").ascending());
        org.springframework.data.domain.Page<NFLPlayerDocument> result = playerRepository.findByPosition(position.toUpperCase(), pageable);

        List<NFLPlayerDTO> players = result.getContent().stream()
                .map(NFLPlayerDTO::fromDocument)
                .collect(Collectors.toList());

        return new Page<>(
                players,
                result.getNumber(),
                result.getSize(),
                result.getTotalElements()
        );
    }

    /**
     * Search players by name
     * @param name the search string
     * @param page the page number
     * @param size the page size
     * @return paginated list of matching players
     */
    public Page<NFLPlayerDTO> searchPlayersByName(String name, int page, int size) {
        log.debug("Searching players by name: {}, page: {}, size: {}", name, page, size);
        Pageable pageable = PageRequest.of(page, size);
        org.springframework.data.domain.Page<NFLPlayerDocument> result = playerRepository.findByNameContainingIgnoreCase(name, pageable);

        List<NFLPlayerDTO> players = result.getContent().stream()
                .map(NFLPlayerDTO::fromDocument)
                .collect(Collectors.toList());

        return new Page<>(
                players,
                result.getNumber(),
                result.getSize(),
                result.getTotalElements()
        );
    }

    /**
     * Get total count of players
     * @return total number of players
     */
    public long getTotalPlayerCount() {
        return playerRepository.count();
    }

    /**
     * Get count of players on a team
     * @param team the team abbreviation
     * @return number of players on the team
     */
    public long getPlayerCountByTeam(String team) {
        return playerRepository.countByTeam(team.toUpperCase());
    }

    /**
     * Check if a player exists
     * @param playerId the player ID
     * @return true if the player exists
     */
    public boolean playerExists(String playerId) {
        return playerRepository.existsByPlayerId(playerId);
    }
}

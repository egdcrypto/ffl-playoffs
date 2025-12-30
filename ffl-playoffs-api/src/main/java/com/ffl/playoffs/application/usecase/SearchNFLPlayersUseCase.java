package com.ffl.playoffs.application.usecase;

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
import java.util.stream.Collectors;

/**
 * Use case for searching NFL players with various filters.
 * Searches MongoDB database for players matching criteria.
 * Supports filtering by name, position, team, and status.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class SearchNFLPlayersUseCase {

    private static final int DEFAULT_PAGE_SIZE = 50;
    private static final int MAX_PAGE_SIZE = 100;

    private final MongoNFLPlayerRepository playerRepository;

    /**
     * Search players by name with pagination
     *
     * @param command search command with criteria and pagination
     * @return paginated list of matching players
     */
    public Page<NFLPlayerDTO> execute(SearchCommand command) {
        log.debug("Searching players with command: {}", command);

        int page = command.getPage() != null ? command.getPage() : 0;
        int size = validatePageSize(command.getSize());

        Pageable pageable = PageRequest.of(page, size, Sort.by("name").ascending());

        org.springframework.data.domain.Page<NFLPlayerDocument> result;

        if (command.getName() != null && !command.getName().isBlank()) {
            // Search by name (case-insensitive, contains)
            result = playerRepository.findByNameContainingIgnoreCase(command.getName(), pageable);
        } else if (command.getTeam() != null && !command.getTeam().isBlank()) {
            // Search by team
            pageable = PageRequest.of(page, size, Sort.by("position").ascending().and(Sort.by("name").ascending()));
            result = playerRepository.findByTeam(command.getTeam().toUpperCase(), pageable);
        } else if (command.getPosition() != null && !command.getPosition().isBlank()) {
            // Search by position
            result = playerRepository.findByPosition(command.getPosition().toUpperCase(), pageable);
        } else {
            // Return all players
            result = playerRepository.findAll(pageable);
        }

        List<NFLPlayerDTO> players = result.getContent().stream()
                .map(NFLPlayerDTO::fromDocument)
                .collect(Collectors.toList());

        log.debug("Found {} players (page {} of {})", players.size(), page, result.getTotalPages());

        return new Page<>(
                players,
                result.getNumber(),
                result.getSize(),
                result.getTotalElements()
        );
    }

    /**
     * Search players with combined filters
     *
     * @param command search command with multiple filter criteria
     * @return paginated list of matching players
     */
    public Page<NFLPlayerDTO> executeWithFilters(SearchCommand command) {
        log.debug("Searching players with filters: name={}, position={}, team={}",
                command.getName(), command.getPosition(), command.getTeam());

        int page = command.getPage() != null ? command.getPage() : 0;
        int size = validatePageSize(command.getSize());

        // For combined filters, we need to fetch and filter in memory
        // In production, this would be optimized with compound MongoDB queries
        Pageable pageable = PageRequest.of(0, Integer.MAX_VALUE);
        org.springframework.data.domain.Page<NFLPlayerDocument> allPlayers;

        // Start with the most restrictive filter
        if (command.getTeam() != null && !command.getTeam().isBlank()) {
            allPlayers = playerRepository.findByTeam(command.getTeam().toUpperCase(), pageable);
        } else if (command.getPosition() != null && !command.getPosition().isBlank()) {
            allPlayers = playerRepository.findByPosition(command.getPosition().toUpperCase(), pageable);
        } else {
            allPlayers = playerRepository.findAll(pageable);
        }

        // Apply additional filters in memory
        List<NFLPlayerDocument> filtered = allPlayers.getContent().stream()
                .filter(player -> matchesName(player, command.getName()))
                .filter(player -> matchesPosition(player, command.getPosition()))
                .filter(player -> matchesTeam(player, command.getTeam()))
                .filter(player -> matchesStatus(player, command.getStatus()))
                .sorted((a, b) -> {
                    // Sort by name
                    String nameA = a.getName() != null ? a.getName() : "";
                    String nameB = b.getName() != null ? b.getName() : "";
                    return nameA.compareToIgnoreCase(nameB);
                })
                .collect(Collectors.toList());

        // Apply pagination
        int totalElements = filtered.size();
        int startIndex = page * size;
        int endIndex = Math.min(startIndex + size, totalElements);

        List<NFLPlayerDTO> pagedResults = filtered.subList(
                Math.min(startIndex, totalElements),
                endIndex
        ).stream()
                .map(NFLPlayerDTO::fromDocument)
                .collect(Collectors.toList());

        log.debug("Found {} total players, returning {} (page {})", totalElements, pagedResults.size(), page);

        return new Page<>(
                pagedResults,
                page,
                size,
                totalElements
        );
    }

    private boolean matchesName(NFLPlayerDocument player, String name) {
        if (name == null || name.isBlank()) {
            return true;
        }
        String playerName = player.getName();
        return playerName != null && playerName.toLowerCase().contains(name.toLowerCase());
    }

    private boolean matchesPosition(NFLPlayerDocument player, String position) {
        if (position == null || position.isBlank()) {
            return true;
        }
        String playerPosition = player.getPosition();
        return playerPosition != null && playerPosition.equalsIgnoreCase(position);
    }

    private boolean matchesTeam(NFLPlayerDocument player, String team) {
        if (team == null || team.isBlank()) {
            return true;
        }
        String playerTeam = player.getTeam();
        return playerTeam != null && playerTeam.equalsIgnoreCase(team);
    }

    private boolean matchesStatus(NFLPlayerDocument player, String status) {
        if (status == null || status.isBlank()) {
            return true;
        }
        String playerStatus = player.getStatus();
        return playerStatus != null && playerStatus.equalsIgnoreCase(status);
    }

    private int validatePageSize(Integer size) {
        if (size == null || size <= 0) {
            return DEFAULT_PAGE_SIZE;
        }
        return Math.min(size, MAX_PAGE_SIZE);
    }

    /**
     * Search command with filter criteria
     */
    public static class SearchCommand {
        private String name;
        private String position;
        private String team;
        private String status;
        private Integer page;
        private Integer size;

        public SearchCommand() {
        }

        public SearchCommand(String name, Integer page, Integer size) {
            this.name = name;
            this.page = page;
            this.size = size;
        }

        public static Builder builder() {
            return new Builder();
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getPosition() {
            return position;
        }

        public void setPosition(String position) {
            this.position = position;
        }

        public String getTeam() {
            return team;
        }

        public void setTeam(String team) {
            this.team = team;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public Integer getPage() {
            return page;
        }

        public void setPage(Integer page) {
            this.page = page;
        }

        public Integer getSize() {
            return size;
        }

        public void setSize(Integer size) {
            this.size = size;
        }

        @Override
        public String toString() {
            return "SearchCommand{" +
                    "name='" + name + '\'' +
                    ", position='" + position + '\'' +
                    ", team='" + team + '\'' +
                    ", status='" + status + '\'' +
                    ", page=" + page +
                    ", size=" + size +
                    '}';
        }

        public static class Builder {
            private String name;
            private String position;
            private String team;
            private String status;
            private Integer page;
            private Integer size;

            public Builder name(String name) {
                this.name = name;
                return this;
            }

            public Builder position(String position) {
                this.position = position;
                return this;
            }

            public Builder team(String team) {
                this.team = team;
                return this;
            }

            public Builder status(String status) {
                this.status = status;
                return this;
            }

            public Builder page(Integer page) {
                this.page = page;
                return this;
            }

            public Builder size(Integer size) {
                this.size = size;
                return this;
            }

            public SearchCommand build() {
                SearchCommand command = new SearchCommand();
                command.name = this.name;
                command.position = this.position;
                command.team = this.team;
                command.status = this.status;
                command.page = this.page;
                command.size = this.size;
                return command;
            }
        }
    }
}

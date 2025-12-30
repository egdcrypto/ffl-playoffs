package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.port.LeagueRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Use case for listing all leagues in the system
 * Only accessible by SUPER_ADMIN for system-wide visibility
 */
public class ListAllLeaguesUseCase {

    private final LeagueRepository leagueRepository;

    public ListAllLeaguesUseCase(LeagueRepository leagueRepository) {
        this.leagueRepository = leagueRepository;
    }

    /**
     * Lists all leagues with pagination
     *
     * @param command The list leagues command
     * @return Paginated list of all leagues
     */
    public ListAllLeaguesResult execute(ListAllLeaguesCommand command) {
        // Get all leagues
        List<League> allLeagues = leagueRepository.findAll();

        // Calculate pagination
        int totalElements = allLeagues.size();
        int startIndex = command.getPage() * command.getSize();
        int endIndex = Math.min(startIndex + command.getSize(), totalElements);

        // Get paginated subset
        List<League> pagedLeagues = startIndex < totalElements
                ? allLeagues.subList(startIndex, endIndex)
                : List.of();

        // Convert to DTOs
        List<LeagueSummary> leagueSummaries = pagedLeagues.stream()
                .map(league -> new LeagueSummary(
                        league.getId(),
                        league.getName(),
                        league.getCode(),
                        league.getOwnerId(),
                        league.getPlayers() != null ? league.getPlayers().size() : 0,
                        league.getStatus() != null ? league.getStatus().name() : null,
                        league.getCreatedAt(),
                        league.getCurrentWeek(),
                        league.getNumberOfWeeks()
                ))
                .collect(Collectors.toList());

        return new ListAllLeaguesResult(
                leagueSummaries,
                command.getPage(),
                command.getSize(),
                totalElements
        );
    }

    /**
     * Command object for listing leagues
     */
    public static class ListAllLeaguesCommand {
        private final int page;
        private final int size;

        public ListAllLeaguesCommand(int page, int size) {
            this.page = Math.max(0, page);
            this.size = Math.max(1, Math.min(100, size)); // Cap at 100
        }

        public int getPage() {
            return page;
        }

        public int getSize() {
            return size;
        }
    }

    /**
     * Result object containing paginated league list
     */
    public static class ListAllLeaguesResult {
        private final List<LeagueSummary> leagues;
        private final int page;
        private final int size;
        private final long totalElements;
        private final int totalPages;
        private final boolean hasNext;
        private final boolean hasPrevious;

        public ListAllLeaguesResult(List<LeagueSummary> leagues, int page, int size, long totalElements) {
            this.leagues = leagues;
            this.page = page;
            this.size = size;
            this.totalElements = totalElements;
            this.totalPages = (int) Math.ceil((double) totalElements / size);
            this.hasNext = page < totalPages - 1;
            this.hasPrevious = page > 0;
        }

        public List<LeagueSummary> getLeagues() {
            return leagues;
        }

        public int getPage() {
            return page;
        }

        public int getSize() {
            return size;
        }

        public long getTotalElements() {
            return totalElements;
        }

        public int getTotalPages() {
            return totalPages;
        }

        public boolean isHasNext() {
            return hasNext;
        }

        public boolean isHasPrevious() {
            return hasPrevious;
        }
    }

    /**
     * Summary DTO for league
     */
    public static class LeagueSummary {
        private final UUID id;
        private final String name;
        private final String code;
        private final UUID ownerId;
        private final int playerCount;
        private final String status;
        private final LocalDateTime createdAt;
        private final Integer currentWeek;
        private final Integer numberOfWeeks;

        public LeagueSummary(UUID id, String name, String code, UUID ownerId,
                            int playerCount, String status, LocalDateTime createdAt,
                            Integer currentWeek, Integer numberOfWeeks) {
            this.id = id;
            this.name = name;
            this.code = code;
            this.ownerId = ownerId;
            this.playerCount = playerCount;
            this.status = status;
            this.createdAt = createdAt;
            this.currentWeek = currentWeek;
            this.numberOfWeeks = numberOfWeeks;
        }

        public UUID getId() {
            return id;
        }

        public String getName() {
            return name;
        }

        public String getCode() {
            return code;
        }

        public UUID getOwnerId() {
            return ownerId;
        }

        public int getPlayerCount() {
            return playerCount;
        }

        public String getStatus() {
            return status;
        }

        public LocalDateTime getCreatedAt() {
            return createdAt;
        }

        public Integer getCurrentWeek() {
            return currentWeek;
        }

        public Integer getNumberOfWeeks() {
            return numberOfWeeks;
        }
    }
}

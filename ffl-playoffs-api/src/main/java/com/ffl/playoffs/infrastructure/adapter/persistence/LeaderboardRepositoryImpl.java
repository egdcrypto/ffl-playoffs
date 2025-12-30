package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.application.dto.LeaderboardEntryDTO;
import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.PageRequest;
import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.port.LeaderboardRepository;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Implementation of LeaderboardRepository port.
 * Retrieves leaderboard data from LeaguePlayer repository and calculates rankings.
 *
 * Infrastructure layer adapter.
 */
@Repository
@RequiredArgsConstructor
@Slf4j
public class LeaderboardRepositoryImpl implements LeaderboardRepository {

    private final LeaguePlayerRepository leaguePlayerRepository;

    @Override
    public Page<LeaderboardEntryDTO> findByGameId(UUID gameId, PageRequest pageRequest) {
        log.debug("Finding leaderboard for gameId={}", gameId);

        List<LeaguePlayer> allPlayers = leaguePlayerRepository.findByLeagueId(gameId);

        // Sort by total score descending
        List<LeaguePlayer> sortedPlayers = allPlayers.stream()
                .sorted(Comparator.comparing(
                        (LeaguePlayer p) -> p.getTotalScore() != null ? p.getTotalScore() : 0.0,
                        Comparator.reverseOrder()))
                .collect(Collectors.toList());

        // Assign ranks
        assignRanks(sortedPlayers);

        // Convert to DTOs with pagination
        return paginateAndConvert(sortedPlayers, pageRequest);
    }

    @Override
    public Page<LeaderboardEntryDTO> findByGameIdAndWeek(UUID gameId, int week, PageRequest pageRequest) {
        log.debug("Finding leaderboard for gameId={}, week={}", gameId, week);

        // For now, use the same logic as overall standings
        // In a full implementation, this would query week-specific scores
        return findByGameId(gameId, pageRequest);
    }

    @Override
    public Page<LeaderboardEntryDTO> findActivePlayersByGameId(UUID gameId, PageRequest pageRequest) {
        log.debug("Finding active players leaderboard for gameId={}", gameId);

        List<LeaguePlayer> activePlayers = leaguePlayerRepository.findActivePlayersByLeagueId(gameId);

        // Sort by total score descending
        List<LeaguePlayer> sortedPlayers = activePlayers.stream()
                .sorted(Comparator.comparing(
                        (LeaguePlayer p) -> p.getTotalScore() != null ? p.getTotalScore() : 0.0,
                        Comparator.reverseOrder()))
                .collect(Collectors.toList());

        // Assign ranks
        assignRanks(sortedPlayers);

        // Convert to DTOs with pagination
        return paginateAndConvert(sortedPlayers, pageRequest);
    }

    @Override
    public Page<LeaderboardEntryDTO> findEliminatedPlayersByGameId(UUID gameId, PageRequest pageRequest) {
        log.debug("Finding eliminated players leaderboard for gameId={}", gameId);

        List<LeaguePlayer> allPlayers = leaguePlayerRepository.findByLeagueId(gameId);

        // Filter to only eliminated players
        List<LeaguePlayer> eliminatedPlayers = allPlayers.stream()
                .filter(p -> Boolean.TRUE.equals(p.getIsEliminated()))
                .sorted(Comparator.comparing(
                        (LeaguePlayer p) -> p.getTotalScore() != null ? p.getTotalScore() : 0.0,
                        Comparator.reverseOrder()))
                .collect(Collectors.toList());

        // Assign ranks
        assignRanks(eliminatedPlayers);

        // Convert to DTOs with pagination
        return paginateAndConvert(eliminatedPlayers, pageRequest);
    }

    /**
     * Assign ranks to sorted players, handling ties
     */
    private void assignRanks(List<LeaguePlayer> sortedPlayers) {
        int rank = 1;
        Double previousScore = null;
        int playersAtRank = 0;

        for (LeaguePlayer player : sortedPlayers) {
            Double currentScore = player.getTotalScore() != null ? player.getTotalScore() : 0.0;

            if (previousScore != null && !currentScore.equals(previousScore)) {
                rank += playersAtRank;
                playersAtRank = 0;
            }

            player.setRank(rank);
            playersAtRank++;
            previousScore = currentScore;
        }
    }

    /**
     * Paginate players and convert to DTOs
     */
    private Page<LeaderboardEntryDTO> paginateAndConvert(List<LeaguePlayer> players, PageRequest pageRequest) {
        int totalElements = players.size();
        int offset = pageRequest.getOffset();
        int limit = pageRequest.getSize();

        // Get the page of players
        List<LeaguePlayer> pageContent = players.stream()
                .skip(offset)
                .limit(limit)
                .collect(Collectors.toList());

        // Convert to DTOs
        List<LeaderboardEntryDTO> dtos = pageContent.stream()
                .map(this::toDto)
                .collect(Collectors.toList());

        return Page.of(dtos, pageRequest, totalElements);
    }

    /**
     * Convert LeaguePlayer to LeaderboardEntryDTO
     */
    private LeaderboardEntryDTO toDto(LeaguePlayer player) {
        LeaderboardEntryDTO dto = new LeaderboardEntryDTO();
        dto.setRank(player.getRank() != null ? player.getRank() : 0);
        dto.setPlayerId(player.getUserId());
        dto.setPlayerName(player.getDisplayName() != null ? player.getDisplayName() : "Unknown");
        dto.setEmail(player.getEmail());
        dto.setTotalScore(player.getTotalScore() != null ? player.getTotalScore() : 0.0);
        dto.setEliminated(Boolean.TRUE.equals(player.getIsEliminated()));
        dto.setTeamsUsed(new ArrayList<>()); // To be populated from team selections
        dto.setWeeklyScores(new ArrayList<>()); // To be populated from weekly scores

        return dto;
    }
}

package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.LeaderboardEntryDTO;
import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.PageRequest;
import com.ffl.playoffs.domain.port.LeaderboardRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.UUID;

/**
 * Use case for retrieving league standings.
 * Provides overall standings for a league, sorted by total points.
 *
 * Hexagonal Architecture: Application layer use case
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class GetLeagueStandingsUseCase {

    private final LeaderboardRepository leaderboardRepository;

    /**
     * Execute the use case to get league standings
     *
     * @param leagueId the league ID
     * @param pageRequest pagination parameters
     * @param includeEliminated whether to include eliminated players
     * @return paginated leaderboard entries
     */
    public Page<LeaderboardEntryDTO> execute(UUID leagueId, PageRequest pageRequest, boolean includeEliminated) {
        log.info("Getting league standings for leagueId={}, page={}, size={}, includeEliminated={}",
                leagueId, pageRequest.getPage(), pageRequest.getSize(), includeEliminated);

        Page<LeaderboardEntryDTO> standings;

        if (includeEliminated) {
            standings = leaderboardRepository.findByGameId(leagueId, pageRequest);
        } else {
            standings = leaderboardRepository.findActivePlayersByGameId(leagueId, pageRequest);
        }

        log.info("Retrieved {} standings entries for league {}", standings.getContent().size(), leagueId);
        return standings;
    }
}

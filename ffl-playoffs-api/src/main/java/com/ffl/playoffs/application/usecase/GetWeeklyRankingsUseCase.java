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
 * Use case for retrieving weekly rankings.
 * Provides rankings for a specific week, sorted by week points.
 *
 * Hexagonal Architecture: Application layer use case
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class GetWeeklyRankingsUseCase {

    private final LeaderboardRepository leaderboardRepository;

    /**
     * Execute the use case to get weekly rankings
     *
     * @param leagueId the league ID
     * @param week the week number
     * @param pageRequest pagination parameters
     * @return paginated leaderboard entries for the specified week
     */
    public Page<LeaderboardEntryDTO> execute(UUID leagueId, int week, PageRequest pageRequest) {
        log.info("Getting weekly rankings for leagueId={}, week={}, page={}, size={}",
                leagueId, week, pageRequest.getPage(), pageRequest.getSize());

        if (week < 1 || week > 4) {
            throw new IllegalArgumentException("Week must be between 1 and 4 for NFL playoffs");
        }

        Page<LeaderboardEntryDTO> rankings = leaderboardRepository.findByGameIdAndWeek(leagueId, week, pageRequest);

        log.info("Retrieved {} rankings for week {} in league {}", rankings.getContent().size(), week, leagueId);
        return rankings;
    }
}

package com.ffl.playoffs.infrastructure.adapter.persistence.stub;

import com.ffl.playoffs.application.dto.LeaderboardEntryDTO;
import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.PageRequest;
import com.ffl.playoffs.domain.port.LeaderboardRepository;
import org.springframework.stereotype.Repository;

import java.util.Collections;
import java.util.UUID;

/**
 * Stub implementation of LeaderboardRepository for testing and development
 */
@Repository
public class LeaderboardRepositoryStub implements LeaderboardRepository {

    @Override
    public Page<LeaderboardEntryDTO> findByGameId(UUID gameId, PageRequest pageRequest) {
        return new Page<>(Collections.emptyList(), pageRequest.getPage(), pageRequest.getSize(), 0);
    }

    @Override
    public Page<LeaderboardEntryDTO> findByGameIdAndWeek(UUID gameId, int week, PageRequest pageRequest) {
        return new Page<>(Collections.emptyList(), pageRequest.getPage(), pageRequest.getSize(), 0);
    }

    @Override
    public Page<LeaderboardEntryDTO> findActivePlayersByGameId(UUID gameId, PageRequest pageRequest) {
        return new Page<>(Collections.emptyList(), pageRequest.getPage(), pageRequest.getSize(), 0);
    }

    @Override
    public Page<LeaderboardEntryDTO> findEliminatedPlayersByGameId(UUID gameId, PageRequest pageRequest) {
        return new Page<>(Collections.emptyList(), pageRequest.getPage(), pageRequest.getSize(), 0);
    }
}

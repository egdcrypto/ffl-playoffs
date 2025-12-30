package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.LeaderboardEntryDTO;
import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.PageRequest;
import com.ffl.playoffs.domain.port.LeaderboardRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

/**
 * Unit tests for GetLeagueStandingsUseCase
 */
@ExtendWith(MockitoExtension.class)
class GetLeagueStandingsUseCaseTest {

    @Mock
    private LeaderboardRepository leaderboardRepository;

    private GetLeagueStandingsUseCase useCase;

    @BeforeEach
    void setUp() {
        useCase = new GetLeagueStandingsUseCase(leaderboardRepository);
    }

    @Nested
    @DisplayName("Execute")
    class Execute {

        @Test
        @DisplayName("should return standings including eliminated players")
        void shouldReturnStandingsIncludingEliminated() {
            UUID leagueId = UUID.randomUUID();
            PageRequest pageRequest = PageRequest.of(0, 20);
            List<LeaderboardEntryDTO> entries = List.of(
                    createEntry(1, "Player 1", 100.0, false),
                    createEntry(2, "Player 2", 80.0, true)
            );
            Page<LeaderboardEntryDTO> expectedPage = new Page<>(entries, 0, 20, 2);

            when(leaderboardRepository.findByGameId(eq(leagueId), any(PageRequest.class)))
                    .thenReturn(expectedPage);

            Page<LeaderboardEntryDTO> result = useCase.execute(leagueId, pageRequest, true);

            assertNotNull(result);
            assertEquals(2, result.getContent().size());
            verify(leaderboardRepository).findByGameId(leagueId, pageRequest);
            verify(leaderboardRepository, never()).findActivePlayersByGameId(any(), any());
        }

        @Test
        @DisplayName("should return standings excluding eliminated players")
        void shouldReturnStandingsExcludingEliminated() {
            UUID leagueId = UUID.randomUUID();
            PageRequest pageRequest = PageRequest.of(0, 20);
            List<LeaderboardEntryDTO> entries = List.of(
                    createEntry(1, "Player 1", 100.0, false)
            );
            Page<LeaderboardEntryDTO> expectedPage = new Page<>(entries, 0, 20, 1);

            when(leaderboardRepository.findActivePlayersByGameId(eq(leagueId), any(PageRequest.class)))
                    .thenReturn(expectedPage);

            Page<LeaderboardEntryDTO> result = useCase.execute(leagueId, pageRequest, false);

            assertNotNull(result);
            assertEquals(1, result.getContent().size());
            verify(leaderboardRepository).findActivePlayersByGameId(leagueId, pageRequest);
            verify(leaderboardRepository, never()).findByGameId(any(), any());
        }

        @Test
        @DisplayName("should return empty page when no players")
        void shouldReturnEmptyPageWhenNoPlayers() {
            UUID leagueId = UUID.randomUUID();
            PageRequest pageRequest = PageRequest.of(0, 20);
            Page<LeaderboardEntryDTO> expectedPage = new Page<>(List.of(), 0, 20, 0);

            when(leaderboardRepository.findByGameId(eq(leagueId), any(PageRequest.class)))
                    .thenReturn(expectedPage);

            Page<LeaderboardEntryDTO> result = useCase.execute(leagueId, pageRequest, true);

            assertNotNull(result);
            assertTrue(result.getContent().isEmpty());
            assertEquals(0, result.getTotalElements());
        }
    }

    private LeaderboardEntryDTO createEntry(int rank, String name, double score, boolean eliminated) {
        LeaderboardEntryDTO dto = new LeaderboardEntryDTO();
        dto.setRank(rank);
        dto.setPlayerId(UUID.randomUUID());
        dto.setPlayerName(name);
        dto.setTotalScore(score);
        dto.setEliminated(eliminated);
        return dto;
    }
}

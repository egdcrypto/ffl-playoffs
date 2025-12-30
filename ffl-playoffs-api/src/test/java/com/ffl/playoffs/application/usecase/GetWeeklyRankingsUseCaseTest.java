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
 * Unit tests for GetWeeklyRankingsUseCase
 */
@ExtendWith(MockitoExtension.class)
class GetWeeklyRankingsUseCaseTest {

    @Mock
    private LeaderboardRepository leaderboardRepository;

    private GetWeeklyRankingsUseCase useCase;

    @BeforeEach
    void setUp() {
        useCase = new GetWeeklyRankingsUseCase(leaderboardRepository);
    }

    @Nested
    @DisplayName("Execute")
    class Execute {

        @Test
        @DisplayName("should return rankings for valid week")
        void shouldReturnRankingsForValidWeek() {
            UUID leagueId = UUID.randomUUID();
            int week = 2;
            PageRequest pageRequest = PageRequest.of(0, 20);
            List<LeaderboardEntryDTO> entries = List.of(
                    createEntry(1, "Player 1", 52.3),
                    createEntry(2, "Player 2", 45.5)
            );
            Page<LeaderboardEntryDTO> expectedPage = new Page<>(entries, 0, 20, 2);

            when(leaderboardRepository.findByGameIdAndWeek(eq(leagueId), eq(week), any(PageRequest.class)))
                    .thenReturn(expectedPage);

            Page<LeaderboardEntryDTO> result = useCase.execute(leagueId, week, pageRequest);

            assertNotNull(result);
            assertEquals(2, result.getContent().size());
            verify(leaderboardRepository).findByGameIdAndWeek(leagueId, week, pageRequest);
        }

        @Test
        @DisplayName("should throw exception for week less than 1")
        void shouldThrowExceptionForWeekLessThan1() {
            UUID leagueId = UUID.randomUUID();
            PageRequest pageRequest = PageRequest.of(0, 20);

            assertThrows(IllegalArgumentException.class, () ->
                    useCase.execute(leagueId, 0, pageRequest));
        }

        @Test
        @DisplayName("should throw exception for week greater than 4")
        void shouldThrowExceptionForWeekGreaterThan4() {
            UUID leagueId = UUID.randomUUID();
            PageRequest pageRequest = PageRequest.of(0, 20);

            assertThrows(IllegalArgumentException.class, () ->
                    useCase.execute(leagueId, 5, pageRequest));
        }

        @Test
        @DisplayName("should accept week 1")
        void shouldAcceptWeek1() {
            UUID leagueId = UUID.randomUUID();
            PageRequest pageRequest = PageRequest.of(0, 20);
            Page<LeaderboardEntryDTO> expectedPage = new Page<>(List.of(), 0, 20, 0);

            when(leaderboardRepository.findByGameIdAndWeek(eq(leagueId), eq(1), any(PageRequest.class)))
                    .thenReturn(expectedPage);

            Page<LeaderboardEntryDTO> result = useCase.execute(leagueId, 1, pageRequest);

            assertNotNull(result);
        }

        @Test
        @DisplayName("should accept week 4")
        void shouldAcceptWeek4() {
            UUID leagueId = UUID.randomUUID();
            PageRequest pageRequest = PageRequest.of(0, 20);
            Page<LeaderboardEntryDTO> expectedPage = new Page<>(List.of(), 0, 20, 0);

            when(leaderboardRepository.findByGameIdAndWeek(eq(leagueId), eq(4), any(PageRequest.class)))
                    .thenReturn(expectedPage);

            Page<LeaderboardEntryDTO> result = useCase.execute(leagueId, 4, pageRequest);

            assertNotNull(result);
        }
    }

    private LeaderboardEntryDTO createEntry(int rank, String name, double score) {
        LeaderboardEntryDTO dto = new LeaderboardEntryDTO();
        dto.setRank(rank);
        dto.setPlayerId(UUID.randomUUID());
        dto.setPlayerName(name);
        dto.setTotalScore(score);
        return dto;
    }
}
